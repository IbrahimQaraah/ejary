import 'package:drift/native.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/enums/apartment_status.dart';
import 'package:production_login/core/enums/payer_responsibility.dart';
import 'package:production_login/core/enums/payment_method.dart';
import 'package:production_login/core/enums/payment_type.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/core/enums/service_type.dart';
import 'package:production_login/core/error/exceptions.dart';
import 'package:production_login/features/apartments/data/repositories/apartment_repository_impl.dart';
import 'package:production_login/features/apartments/domain/entities/apartment.dart';
import 'package:production_login/features/apartments/domain/entities/apartment_specification.dart';
import 'package:production_login/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:production_login/features/payments/domain/entities/payment.dart';
import 'package:production_login/features/payments/domain/usecases/payments_usecases.dart';
import 'package:production_login/features/properties/data/repositories/property_repository_impl.dart';
import 'package:production_login/features/properties/domain/entities/property.dart';
import 'package:production_login/features/services/data/repositories/service_repository_impl.dart';
import 'package:production_login/features/services/domain/entities/service.dart';
import 'package:production_login/features/services/domain/usecases/services_usecases.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl propertyRepo;
  late ApartmentRepositoryImpl apartmentRepo;
  late ServiceRepositoryImpl serviceRepo;
  late PaymentRepositoryImpl paymentRepo;

  late GetAllServicesUseCase getAllServicesUseCase;
  late CreateServiceBillUseCase createServiceBillUseCase;
  late CalculateServiceBalanceUseCase calculateServiceBalanceUseCase;
  late RecordPaymentUseCase recordPaymentUseCase;

  int apartmentId = 0;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);
    serviceRepo = ServiceRepositoryImpl(db);
    paymentRepo = PaymentRepositoryImpl(db);

    getAllServicesUseCase = GetAllServicesUseCase(serviceRepo);
    createServiceBillUseCase = CreateServiceBillUseCase(serviceRepo);
    calculateServiceBalanceUseCase = CalculateServiceBalanceUseCase(
      paymentRepo,
    );
    recordPaymentUseCase = RecordPaymentUseCase(paymentRepo);

    final now = DateTime.now();
    final propId = await propertyRepo.createProperty(
      Property(
        id: 0,
        name: 'عمارة الفردوس',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'الغدير',
        address: 'شارع السيل الكبير',
        numberOfFloors: 3,
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
        area: 110,
        monthlyRent: 280000,
        status: ApartmentStatus.available,
        createdAt: now,
        updatedAt: now,
      ),
      specification: const ApartmentSpecification(
        id: 0,
        apartmentId: 0,
        bedrooms: 2,
        bathrooms: 1,
        livingRooms: 1,
        kitchens: 1,
        balconies: 0,
        hasAc: true,
        hasParking: false,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Services & Utilities Module Business Rules Verification', () {
    test(
      '1. Create electricity bill with meter readings & consumption',
      () async {
        final now = DateTime.now();
        final billId = await createServiceBillUseCase(
          ServiceBill(
            id: 0,
            apartmentId: apartmentId,
            serviceType: ServiceType.electricity,
            previousReading: 1200.0,
            currentReading: 1450.0,
            consumption: 250.0,
            unitPrice: 0,
            totalAmount: 45000, // 450 SAR
            billingDate: now,
            dueDate: now.add(const Duration(days: 15)),
            payerResponsibility: PayerResponsibility.tenant,
            notes: 'فاتورة كهرباء شهر نوفمبر',
            createdAt: now,
          ),
        );

        expect(billId, isPositive);

        final balance = await calculateServiceBalanceUseCase(
          serviceId: billId,
          apartmentId: apartmentId,
          totalBillAmount: 45000,
        );

        expect(balance.totalBillAmount, equals(45000));
        expect(balance.totalPaid, equals(0));
        expect(balance.outstandingBalance, equals(45000));
        expect(balance.isFullyPaid, isFalse);

        final all = await getAllServicesUseCase();
        expect(all.length, equals(1));
      },
    );

    test(
      '2. Owner responsibility bill (operational expense without tenant)',
      () async {
        final now = DateTime.now();
        final billId = await createServiceBillUseCase(
          ServiceBill(
            id: 0,
            apartmentId: apartmentId,
            serviceType: ServiceType.other,
            consumption: 0,
            unitPrice: 0,
            totalAmount: 60000, // 600 SAR
            billingDate: now,
            dueDate: now.add(const Duration(days: 30)),
            payerResponsibility: PayerResponsibility.owner,
            notes: 'صيانة دورية للمصاعد والمضخات',
            createdAt: now,
          ),
        );

        expect(billId, isPositive);

        // Pay owner bill directly without tenant
        await recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            tenantId: null, // Owner pays, no tenant required
            serviceId: billId,
            paymentType: PaymentType.service,
            amount: 60000,
            paymentDate: now,
            paidBy: PayerResponsibility.owner,
            paymentMethod: PaymentMethod.bankTransfer,
            referenceNumber: 'OWNER-PAY-01',
            createdAt: now,
          ),
        );

        final balance = await calculateServiceBalanceUseCase(
          serviceId: billId,
          apartmentId: apartmentId,
          totalBillAmount: 60000,
        );

        expect(balance.totalPaid, equals(60000));
        expect(balance.outstandingBalance, equals(0));
        expect(balance.isFullyPaid, isTrue);
      },
    );

    test('3. Partial payments of service bill reduce balance and prevent overpayment', () async {
      final now = DateTime.now();
      final billId = await createServiceBillUseCase(
        ServiceBill(
          id: 0,
          apartmentId: apartmentId,
          serviceType: ServiceType.water,
          consumption: 40.0,
          unitPrice: 0,
          totalAmount: 20000, // 200 SAR
          billingDate: now,
          dueDate: now.add(const Duration(days: 10)),
          payerResponsibility: PayerResponsibility.tenant,
          createdAt: now,
        ),
      );

      // Partial payment 1: 100 SAR
      await recordPaymentUseCase(
        PaymentTransaction(
          id: 0,
          apartmentId: apartmentId,
          serviceId: billId,
          paymentType: PaymentType.service,
          amount: 10000,
          paymentDate: now,
          paidBy: PayerResponsibility.tenant,
          paymentMethod: PaymentMethod.cash,
          createdAt: now,
        ),
      );

      var balance = await calculateServiceBalanceUseCase(
        serviceId: billId,
        apartmentId: apartmentId,
        totalBillAmount: 20000,
      );
      expect(balance.totalPaid, equals(10000));
      expect(balance.outstandingBalance, equals(10000));
      expect(balance.isFullyPaid, isFalse);

      // Overpayment attempt: 150 SAR when only 100 is remaining
      expect(
        () => recordPaymentUseCase(
          PaymentTransaction(
            id: 0,
            apartmentId: apartmentId,
            serviceId: billId,
            paymentType: PaymentType.service,
            amount: 15000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.cash,
            createdAt: now,
          ),
        ),
        throwsA(isA<BusinessRuleException>()),
      );
    });
  });
}
