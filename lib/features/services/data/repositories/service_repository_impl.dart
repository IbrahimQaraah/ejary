import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final AppDatabase db;

  ServiceRepositoryImpl(this.db);

  ServiceBill _toDomain(ServiceEntry entry) {
    return ServiceBill(
      id: entry.id,
      apartmentId: entry.apartmentId,
      serviceType: entry.serviceType,
      previousReading: entry.previousReading,
      currentReading: entry.currentReading,
      consumption: entry.consumption,
      unitPrice: entry.unitPrice,
      totalAmount: entry.totalAmount,
      billingDate: entry.billingDate,
      dueDate: entry.dueDate,
      payerResponsibility: entry.payerResponsibility,
      notes: entry.notes,
      createdAt: entry.createdAt,
    );
  }

  @override
  Future<List<ServiceBill>> getAllServices() async {
    final query = db.select(db.services)
      ..orderBy([(t) => OrderingTerm.desc(t.billingDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<List<ServiceBill>> getServicesForApartment(int apartmentId) async {
    final query = db.select(db.services)
      ..where((t) => t.apartmentId.equals(apartmentId))
      ..orderBy([(t) => OrderingTerm.desc(t.billingDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<ServiceBill?> getServiceById(int id) async {
    final entry = await (db.select(
      db.services,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  @override
  Future<int> createServiceBill(ServiceBill serviceBill) async {
    return await db
        .into(db.services)
        .insert(
          ServicesCompanion.insert(
            apartmentId: serviceBill.apartmentId,
            serviceType: serviceBill.serviceType,
            previousReading: Value(serviceBill.previousReading),
            currentReading: Value(serviceBill.currentReading),
            consumption: Value(serviceBill.consumption),
            unitPrice: Value(serviceBill.unitPrice),
            totalAmount: serviceBill.totalAmount,
            billingDate: serviceBill.billingDate,
            dueDate: serviceBill.dueDate,
            payerResponsibility: serviceBill.payerResponsibility,
            notes: Value(serviceBill.notes),
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> updateServiceBill(ServiceBill serviceBill) async {
    await (db.update(
      db.services,
    )..where((t) => t.id.equals(serviceBill.id))).write(
      ServicesCompanion(
        previousReading: Value(serviceBill.previousReading),
        currentReading: Value(serviceBill.currentReading),
        consumption: Value(serviceBill.consumption),
        unitPrice: Value(serviceBill.unitPrice),
        totalAmount: Value(serviceBill.totalAmount),
        billingDate: Value(serviceBill.billingDate),
        dueDate: Value(serviceBill.dueDate),
        payerResponsibility: Value(serviceBill.payerResponsibility),
        notes: Value(serviceBill.notes),
      ),
    );
  }
}
