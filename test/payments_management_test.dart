import 'package:drift/native.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/enums/apartment_status.dart';
import 'package:production_login/core/enums/payer_responsibility.dart';
import 'package:production_login/core/enums/payment_method.dart';
import 'package:production_login/core/enums/payment_type.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/core/error/exceptions.dart';
import 'package:production_login/features/apartments/data/repositories/apartment_repository_impl.dart';
import 'package:production_login/features/apartments/domain/entities/apartment.dart';
import 'package:production_login/features/apartments/domain/entities/apartment_specification.dart';
import 'package:production_login/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:production_login/features/payments/domain/entities/payment.dart';
import 'package:production_login/features/payments/domain/usecases/payments_usecases.dart';
import 'package:production_login/features/properties/data/repositories/property_repository_impl.dart';
import 'package:production_login/features/properties/domain/entities/property.dart';
import 'package:production_login/features/tenants/data/repositories/tenant_repository_impl.dart';
import 'package:production_login/features/tenants/domain/entities/tenant.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl propertyRepo;
  late ApartmentRepositoryImpl apartmentRepo;
  late TenantRepositoryImpl tenantRepo;
  late PaymentRepositoryImpl paymentRepo;

  late GetAllPaymentsUseCase getAllPaymentsUseCase;
  late RecordPaymentUseCase recordPaymentUseCase;
  late CalculateRentBalanceUseCase calculateRentBalanceUseCase;

  int apartmentId = 0;
  int tenantId = 0;
  const int monthlyRent = 300000; // 3,000 SAR

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);
    tenantRepo = TenantRepositoryImpl(db);
    paymentRepo = PaymentRepositoryImpl(db);

    getAllPaymentsUseCase = GetAllPaymentsUseCase(paymentRepo);
    recordPaymentUseCase = RecordPaymentUseCase(paymentRepo);
    calculateRentBalanceUseCase = CalculateRentBalanceUseCase(paymentRepo);

    final now = DateTime.now();
    final propId = await propertyRepo.createProperty(
      Property(
        id: 0,
        name: 'برج النخبة',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'حطين',
        address: 'شارع الأمير تركي',
        numberOfFloors: 5,
        createdAt: now,
        updatedAt: now,
      ),
    );

    apartmentId = await apartmentRepo.createApartment(
      apartment: Apartment(
        id: 0,
        propertyId: propId,
        apartmentNumber: '101',
        floorNumber: 1,
        area: 120,
        monthlyRent: monthlyRent,
        status: ApartmentStatus.available,
        createdAt: now,
        updatedAt: now,
      ),
      specification: const ApartmentSpecification(
        id: 0,
        apartmentId: 0,
        bedrooms: 2,
        bathrooms: 2,
        livingRooms: 1,
        kitchens: 1,
        balconies: 0,
        hasAc: true,
        hasParking: true,
      ),
    );

    tenantId = await tenantRepo.registerNewTenant(
      Tenant(
        id: 0,
        apartmentId: apartmentId,
        fullName: 'سامي الخالدي',
        phone: '0555555555',
        nationalId: '1055555555',
        address: 'الرياض',
        monthlyRent: monthlyRent,
        depositAmount: 100000,
        contractStartDate: now,
        contractEndDate: now.add(const Duration(days: 365)),
        paymentDueDay: 1,
        moveInDate: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Payments & Ledger Management Business Rules Verification', () {
    test(
      '1. Initial rent balance shows full monthly rent outstanding',
      () async {
        final balance = await calculateRentBalanceUseCase(
          apartmentId: apartmentId,
          tenantId: tenantId,
          billingPeriod: '2026-11',
          monthlyRent: monthlyRent,
        );

        expect(balance.monthlyRent, equals(300000));
        expect(balance.totalPaid, equals(0));
        expect(balance.outstandingBalance, equals(300000));
        expect(balance.isFullyPaid, isFalse);
      },
    );

    test(
      '2. Partial rent payments accumulate and reduce outstanding balance',
      () async {
        final now = DateTime.now();

        // First partial payment: 1,000 SAR (100,000 minor units)
        await recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            tenantId: tenantId,
            paymentType: PaymentType.rent,
            amount: 100000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.bankTransfer,
            billingPeriod: '2026-11',
            referenceNumber: 'TXN-001',
            createdAt: now,
          ),
        );

        var balance = await calculateRentBalanceUseCase(
          apartmentId: apartmentId,
          tenantId: tenantId,
          billingPeriod: '2026-11',
          monthlyRent: monthlyRent,
        );
        expect(balance.totalPaid, equals(100000));
        expect(balance.outstandingBalance, equals(200000));
        expect(balance.isFullyPaid, isFalse);

        // Second partial payment: 2,000 SAR (200,000 minor units)
        await recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            tenantId: tenantId,
            paymentType: PaymentType.rent,
            amount: 200000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.cash,
            billingPeriod: '2026-11',
            referenceNumber: 'TXN-002',
            createdAt: now,
          ),
        );

        balance = await calculateRentBalanceUseCase(
          apartmentId: apartmentId,
          tenantId: tenantId,
          billingPeriod: '2026-11',
          monthlyRent: monthlyRent,
        );
        expect(balance.totalPaid, equals(300000));
        expect(balance.outstandingBalance, equals(0));
        expect(balance.isFullyPaid, isTrue);
      },
    );

    test(
      '3. Overpayment is strictly prevented by business rule validation',
      () async {
        final now = DateTime.now();

        // Pay full 3,000 SAR
        await recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            tenantId: tenantId,
            paymentType: PaymentType.rent,
            amount: 300000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.bankTransfer,
            billingPeriod: '2026-11',
            referenceNumber: 'TXN-FULL',
            createdAt: now,
          ),
        );

        // Attempt additional payment for already settled period
        expect(
          () => recordPaymentUseCase(
            PaymentTransaction(
              id: 0,
              apartmentId: apartmentId,
              tenantId: tenantId,
              paymentType: PaymentType.rent,
              amount: 50000, // 500 SAR
              paymentDate: now,
              paidBy: PayerResponsibility.tenant,
              paymentMethod: PaymentMethod.cash,
              billingPeriod: '2026-11',
              createdAt: now,
            ),
          ),
          throwsA(isA<BusinessRuleException>()),
        );
      },
    );

    test(
      '4. Ledger reversal adjustment restores balance without deleting records',
      () async {
        final now = DateTime.now();

        final paymentId = await recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            tenantId: tenantId,
            paymentType: PaymentType.rent,
            amount: 300000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.bankTransfer,
            billingPeriod: '2026-11',
            referenceNumber: 'TXN-ERR',
            createdAt: now,
          ),
        );

        // Reversal: Record negative adjustment of -300000
        await recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            tenantId: tenantId,
            paymentType: PaymentType.rent,
            amount: -300000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.bankTransfer,
            billingPeriod: '2026-11',
            referenceNumber: 'REV-#$paymentId',
            notes: 'تسوية قيد عكسي لسند خاطئ',
            createdAt: now,
          ),
        );

        // Outstanding balance is restored back to 300,000
        final balance = await calculateRentBalanceUseCase(
          apartmentId: apartmentId,
          tenantId: tenantId,
          billingPeriod: '2026-11',
          monthlyRent: monthlyRent,
        );
        expect(balance.totalPaid, equals(0));
        expect(balance.outstandingBalance, equals(300000));
        expect(balance.isFullyPaid, isFalse);

        // Both transactions exist in ledger (total 2 records)
        final all = await getAllPaymentsUseCase();
        expect(all.length, equals(2));
        expect(all.any((p) => p.amount < 0), isTrue);
      },
    );
  });
}
