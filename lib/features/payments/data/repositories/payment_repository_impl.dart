import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final AppDatabase db;

  PaymentRepositoryImpl(this.db);

  PaymentTransaction _toDomain(PaymentEntry entry) {
    return PaymentTransaction(
      id: entry.id,
      apartmentId: entry.apartmentId,
      tenantId: entry.tenantId,
      serviceId: entry.serviceId,
      paymentType: entry.paymentType,
      amount: entry.amount,
      dueDate: entry.dueDate,
      paymentDate: entry.paymentDate,
      paidBy: entry.paidBy,
      paymentMethod: entry.paymentMethod,
      billingPeriod: entry.billingPeriod,
      referenceNumber: entry.referenceNumber,
      notes: entry.notes,
      createdAt: entry.createdAt,
    );
  }

  @override
  Future<PaymentTransaction?> getPaymentById(int id) async {
    final entry = await (db.select(
      db.payments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  @override
  Future<List<PaymentTransaction>> getAllPayments({int? limit}) async {
    final query = db.select(db.payments)
      ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]);
    if (limit != null) {
      query.limit(limit);
    }
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<List<PaymentTransaction>> getPaymentsForApartment(
    int apartmentId,
  ) async {
    final query = db.select(db.payments)
      ..where((t) => t.apartmentId.equals(apartmentId))
      ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<List<PaymentTransaction>> getPaymentsForTenant(int tenantId) async {
    final query = db.select(db.payments)
      ..where((t) => t.tenantId.equals(tenantId))
      ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<List<PaymentTransaction>> getPaymentsForService(int serviceId) async {
    final query = db.select(db.payments)
      ..where((t) => t.serviceId.equals(serviceId))
      ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<List<PaymentTransaction>> getPaymentsForRentPeriod({
    required int apartmentId,
    required String billingPeriod,
  }) async {
    final query = db.select(db.payments)
      ..where(
        (t) =>
            t.apartmentId.equals(apartmentId) &
            t.paymentType.equals(PaymentType.rent.name) &
            t.billingPeriod.equals(billingPeriod),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.paymentDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<RentPeriodBalance> calculateRentPeriodBalance({
    required int apartmentId,
    required int tenantId,
    required String billingPeriod,
    required int monthlyRent,
  }) async {
    final payments = await getPaymentsForRentPeriod(
      apartmentId: apartmentId,
      billingPeriod: billingPeriod,
    );

    // Sum all payments (positive payments reduce balance, negative reversal adjustments increase it)
    final totalPaid = payments.fold<int>(0, (sum, p) => sum + p.amount);
    final outstanding = monthlyRent - totalPaid;

    return RentPeriodBalance(
      apartmentId: apartmentId,
      tenantId: tenantId,
      billingPeriod: billingPeriod,
      monthlyRent: monthlyRent,
      totalPaid: totalPaid,
      outstandingBalance: outstanding < 0 ? 0 : outstanding,
    );
  }

  @override
  Future<ServiceBillBalance> calculateServiceBillBalance({
    required int serviceId,
    required int apartmentId,
    required int totalBillAmount,
  }) async {
    final payments = await getPaymentsForService(serviceId);
    final totalPaid = payments.fold<int>(0, (sum, p) => sum + p.amount);
    final outstanding = totalBillAmount - totalPaid;

    return ServiceBillBalance(
      serviceId: serviceId,
      apartmentId: apartmentId,
      totalBillAmount: totalBillAmount,
      totalPaid: totalPaid,
      outstandingBalance: outstanding < 0 ? 0 : outstanding,
    );
  }

  @override
  Future<int> recordPayment(PaymentTransaction payment) async {
    return await db.transaction(() async {
      // 1. Apartment validation
      final apartment = await (db.select(
        db.apartments,
      )..where((t) => t.id.equals(payment.apartmentId))).getSingleOrNull();
      if (apartment == null) {
        throw BusinessRuleException(
          'Apartment #${payment.apartmentId} does not exist.',
        );
      }

      // 2. Rent Payment Business Logic
      if (payment.paymentType == PaymentType.rent) {
        if (payment.tenantId == null) {
          throw const BusinessRuleException(
            'Tenant ID is mandatory for rent payments.',
          );
        }
        if (payment.serviceId != null) {
          throw const BusinessRuleException(
            'Service ID must be null for rent payments.',
          );
        }
        if (payment.billingPeriod == null || payment.billingPeriod!.isEmpty) {
          throw const BusinessRuleException(
            'Billing period (YYYY-MM) is required for rent payments.',
          );
        }

        // Verify tenant belongs to the specified apartment
        final tenant =
            await (db.select(db.tenants)..where(
                  (t) =>
                      t.id.equals(payment.tenantId!) &
                      t.apartmentId.equals(payment.apartmentId),
                ))
                .getSingleOrNull();
        if (tenant == null) {
          throw BusinessRuleException(
            'Tenant #${payment.tenantId} does not belong to apartment #${payment.apartmentId}.',
          );
        }

        // For non-reversal payment transactions, ensure we do not exceed outstanding rent balance
        if (payment.amount > 0) {
          final balance = await calculateRentPeriodBalance(
            apartmentId: payment.apartmentId,
            tenantId: payment.tenantId!,
            billingPeriod: payment.billingPeriod!,
            monthlyRent: tenant.monthlyRent,
          );

          if (payment.amount > balance.outstandingBalance) {
            throw BusinessRuleException(
              'Payment amount of ${CurrencyFormatter.format(payment.amount)} exceeds the remaining rent balance of ${CurrencyFormatter.format(balance.outstandingBalance)} for period ${payment.billingPeriod}.',
            );
          }
        }
      }

      // 3. Service Payment Business Logic
      if (payment.paymentType == PaymentType.service) {
        if (payment.serviceId == null) {
          throw const BusinessRuleException(
            'Service ID is mandatory for service bill payments.',
          );
        }

        // Verify service belongs to the specified apartment
        final service =
            await (db.select(db.services)..where(
                  (t) =>
                      t.id.equals(payment.serviceId!) &
                      t.apartmentId.equals(payment.apartmentId),
                ))
                .getSingleOrNull();
        if (service == null) {
          throw BusinessRuleException(
            'Service bill #${payment.serviceId} does not belong to apartment #${payment.apartmentId}.',
          );
        }

        // If tenantId is supplied, verify tenant belongs to this apartment
        if (payment.tenantId != null) {
          final tenant =
              await (db.select(db.tenants)..where(
                    (t) =>
                        t.id.equals(payment.tenantId!) &
                        t.apartmentId.equals(payment.apartmentId),
                  ))
                  .getSingleOrNull();
          if (tenant == null) {
            throw BusinessRuleException(
              'Tenant #${payment.tenantId} does not belong to apartment #${payment.apartmentId}.',
            );
          }
        }

        // For non-reversal payment transactions, ensure we do not exceed outstanding service bill balance
        if (payment.amount > 0) {
          final balance = await calculateServiceBillBalance(
            serviceId: payment.serviceId!,
            apartmentId: payment.apartmentId,
            totalBillAmount: service.totalAmount,
          );

          if (payment.amount > balance.outstandingBalance) {
            throw BusinessRuleException(
              'Payment amount of ${CurrencyFormatter.format(payment.amount)} exceeds the remaining service balance of ${CurrencyFormatter.format(balance.outstandingBalance)} for service bill #${payment.serviceId}.',
            );
          }
        }
      }

      // 4. Insert into the immutable Payments ledger
      final now = DateTime.now();
      return await db
          .into(db.payments)
          .insert(
            PaymentsCompanion.insert(
              apartmentId: payment.apartmentId,
              tenantId: Value(payment.tenantId),
              serviceId: Value(payment.serviceId),
              paymentType: payment.paymentType,
              amount: payment.amount,
              dueDate: Value(payment.dueDate),
              paymentDate: payment.paymentDate,
              paidBy: payment.paidBy,
              paymentMethod: payment.paymentMethod,
              billingPeriod: Value(payment.billingPeriod),
              referenceNumber: Value(payment.referenceNumber),
              notes: Value(payment.notes),
              createdAt: now,
            ),
          );
    });
  }
}
