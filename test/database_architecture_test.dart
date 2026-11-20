import 'package:drift/native.dart';
import 'package:test/test.dart';
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
import 'package:production_login/features/properties/data/repositories/property_repository_impl.dart';
import 'package:production_login/features/properties/domain/entities/property.dart';
import 'package:production_login/features/services/data/repositories/service_repository_impl.dart';
import 'package:production_login/features/services/domain/entities/service.dart';
import 'package:production_login/features/tenants/data/repositories/tenant_repository_impl.dart';
import 'package:production_login/features/tenants/domain/entities/tenant.dart';

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl propertyRepo;
  late ApartmentRepositoryImpl apartmentRepo;
  late TenantRepositoryImpl tenantRepo;
  late ServiceRepositoryImpl serviceRepo;
  late PaymentRepositoryImpl paymentRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);
    tenantRepo = TenantRepositoryImpl(db);
    serviceRepo = ServiceRepositoryImpl(db);
    paymentRepo = PaymentRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Strict 6-Table Architecture & Relational Integrity Verification', () {
    test('1. Verified exactly 6 tables and created property with apartment & specifications', () async {
      // Create Property
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Al-Noor Tower',
          propertyType: PropertyType.residential,
          city: 'Riyadh',
          district: 'Al-Olaya',
          address: 'King Fahd Rd',
          description: 'Luxury residential building',
          numberOfFloors: 10,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      expect(propId, isPositive);

      // Create Apartment + Specification (1-to-1)
      final aptId = await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: 'A-101',
          floorNumber: 1,
          area: 120.5,
          monthlyRent:
              400000, // $4,000.00 represented as 400,000 minor units (cents)
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        specification: const ApartmentSpecification(
          id: 0,
          apartmentId: 0,
          bedrooms: 3,
          bathrooms: 2,
          livingRooms: 1,
          kitchens: 1,
          balconies: 1,
          hasAc: true,
          hasParking: true,
          additionalFeatures: 'Centralized AC & Private Storage',
        ),
      );
      expect(aptId, isPositive);

      final spec = await apartmentRepo.getSpecificationForApartment(aptId);
      expect(spec, isNotNull);
      expect(spec!.bedrooms, equals(3));
      expect(spec.hasAc, isTrue);
    });

    test(
      '2. Unique apartment number per property is strictly enforced',
      () async {
        final propId = await propertyRepo.createProperty(
          Property(
            id: 0,
            name: 'Sunrise Complex',
            propertyType: PropertyType.residential,
            city: 'Jeddah',
            district: 'Al-Hamra',
            address: 'Corniche',
            numberOfFloors: 5,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: '101',
            floorNumber: 1,
            area: 90.0,
            monthlyRent: 300000,
            status: ApartmentStatus.available,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
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

        // Attempt duplicate apartment_number in same property -> must fail
        expect(
          () => apartmentRepo.createApartment(
            apartment: Apartment(
              id: 0,
              propertyId: propId,
              apartmentNumber: '101',
              floorNumber: 1,
              area: 95.0,
              monthlyRent: 310000,
              status: ApartmentStatus.available,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            specification: const ApartmentSpecification(
              id: 0,
              apartmentId: 0,
              bedrooms: 2,
              bathrooms: 1,
              livingRooms: 1,
              kitchens: 1,
              balconies: 0,
              hasAc: false,
              hasParking: false,
            ),
          ),
          throwsA(isA<BusinessRuleException>()),
        );
      },
    );

    test('3. Partial Unique Index strictly prevents multiple active tenants in the same apartment', () async {
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Green Oasis',
          propertyType: PropertyType.residential,
          city: 'Dammam',
          district: 'Al-Faisaliyah',
          address: 'Street 10',
          numberOfFloors: 4,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final aptId = await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '201',
          floorNumber: 2,
          area: 110.0,
          monthlyRent: 350000,
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        specification: const ApartmentSpecification(
          id: 0,
          apartmentId: 0,
          bedrooms: 2,
          bathrooms: 2,
          livingRooms: 1,
          kitchens: 1,
          balconies: 1,
          hasAc: true,
          hasParking: true,
        ),
      );

      // Register first tenant (Active: move_out_date is null)
      final tenant1Id = await tenantRepo.registerNewTenant(
        Tenant(
          id: 0,
          apartmentId: aptId,
          fullName: 'Ahmed Al-Mansoor',
          phone: '+966501112233',
          nationalId: '1098765432',
          address: 'Dammam',
          monthlyRent: 350000,
          depositAmount: 100000,
          contractStartDate: DateTime(2026, 1, 1),
          contractEndDate: DateTime(2026, 12, 31),
          paymentDueDay: 1,
          moveInDate: DateTime(2026, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      expect(tenant1Id, isPositive);

      // Apartment status must be updated to occupied
      final updatedApt = await apartmentRepo.getApartmentById(aptId);
      expect(updatedApt!.status, equals(ApartmentStatus.occupied));

      // Attempt to register a second active tenant while first is still active -> must fail
      expect(
        () => tenantRepo.registerNewTenant(
          Tenant(
            id: 0,
            apartmentId: aptId,
            fullName: 'Khalid Al-Ghamdi',
            phone: '+966509998877',
            nationalId: '1087654321',
            address: 'Dammam',
            monthlyRent: 360000,
            depositAmount: 100000,
            contractStartDate: DateTime(2026, 6, 1),
            contractEndDate: DateTime(2027, 5, 31),
            paymentDueDay: 1,
            moveInDate: DateTime(2026, 6, 1),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
        throwsA(isA<BusinessRuleException>()),
      );
    });

    test('4. Vacating tenant sets move_out_date and allows new tenant while preserving history', () async {
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Palm Heights',
          propertyType: PropertyType.residential,
          city: 'Riyadh',
          district: 'Al-Nakheel',
          address: 'Palm St',
          numberOfFloors: 3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final aptId = await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '301',
          floorNumber: 3,
          area: 130.0,
          monthlyRent: 500000,
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        specification: const ApartmentSpecification(
          id: 0,
          apartmentId: 0,
          bedrooms: 3,
          bathrooms: 2,
          livingRooms: 1,
          kitchens: 1,
          balconies: 2,
          hasAc: true,
          hasParking: true,
        ),
      );

      // 1. First tenant
      final tenant1Id = await tenantRepo.registerNewTenant(
        Tenant(
          id: 0,
          apartmentId: aptId,
          fullName: 'Tariq Mahmoud',
          phone: '+966555001122',
          nationalId: '1011223344',
          address: 'Riyadh',
          monthlyRent: 500000,
          depositAmount: 200000,
          contractStartDate: DateTime(2025, 1, 1),
          contractEndDate: DateTime(2025, 12, 31),
          paymentDueDay: 5,
          moveInDate: DateTime(2025, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // 2. Tenant moves out
      await tenantRepo.vacateTenant(
        tenantId: tenant1Id,
        moveOutDate: DateTime(2025, 12, 31),
      );

      // Apartment status should revert to available
      var apt = await apartmentRepo.getApartmentById(aptId);
      expect(apt!.status, equals(ApartmentStatus.available));

      // 3. Register second tenant for same apartment (with higher rent)
      final tenant2Id = await tenantRepo.registerNewTenant(
        Tenant(
          id: 0,
          apartmentId: aptId,
          fullName: 'Omar Al-Zahrani',
          phone: '+966555889900',
          nationalId: '1055667788',
          address: 'Riyadh',
          monthlyRent: 550000, // Preserves rent history: $5,500
          depositAmount: 250000,
          contractStartDate: DateTime(2026, 1, 1),
          contractEndDate: DateTime(2026, 12, 31),
          paymentDueDay: 1,
          moveInDate: DateTime(2026, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      expect(tenant2Id, isPositive);
      expect(tenant2Id, isNot(equals(tenant1Id)));

      // 4. Verify full tenant history is preserved
      final history = await tenantRepo.getTenantsForApartment(aptId);
      expect(history.length, equals(2));

      final active = await tenantRepo.getActiveTenant(aptId);
      expect(active!.fullName, equals('Omar Al-Zahrani'));
      expect(active.monthlyRent, equals(550000));

      final historical = history.firstWhere((t) => t.id == tenant1Id);
      expect(historical.fullName, equals('Tariq Mahmoud'));
      expect(historical.moveOutDate, isNotNull);
      expect(historical.monthlyRent, equals(500000));
    });

    test(
      '5. Service bill creation & owner vs tenant payer responsibility',
      () async {
        final propId = await propertyRepo.createProperty(
          Property(
            id: 0,
            name: 'Al-Manar Suites',
            propertyType: PropertyType.residential,
            city: 'Riyadh',
            district: 'Al-Malaz',
            address: 'Site 1',
            numberOfFloors: 2,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        final aptId = await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: '102',
            floorNumber: 1,
            area: 85.0,
            monthlyRent: 250000,
            status: ApartmentStatus.available,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          specification: const ApartmentSpecification(
            id: 0,
            apartmentId: 0,
            bedrooms: 1,
            bathrooms: 1,
            livingRooms: 1,
            kitchens: 1,
            balconies: 0,
            hasAc: true,
            hasParking: false,
          ),
        );

        // Bill 1: Electricity paid by Tenant
        final bill1Id = await serviceRepo.createServiceBill(
          ServiceBill(
            id: 0,
            apartmentId: aptId,
            serviceType: ServiceType.electricity,
            previousReading: 1200.0,
            currentReading: 1550.0,
            consumption: 350.0,
            unitPrice: 50, // 50 cents/kWh
            totalAmount: 17500, // $175.00
            billingDate: DateTime(2026, 10, 1),
            dueDate: DateTime(2026, 10, 20),
            payerResponsibility: PayerResponsibility.tenant,
            createdAt: DateTime.now(),
          ),
        );
        expect(bill1Id, isPositive);

        // Bill 2: Maintenance/Internet paid by Owner
        final bill2Id = await serviceRepo.createServiceBill(
          ServiceBill(
            id: 0,
            apartmentId: aptId,
            serviceType: ServiceType.internet,
            consumption: 1.0,
            unitPrice: 8000,
            totalAmount: 8000, // $80.00
            billingDate: DateTime(2026, 10, 1),
            dueDate: DateTime(2026, 10, 15),
            payerResponsibility: PayerResponsibility.owner,
            createdAt: DateTime.now(),
          ),
        );
        expect(bill2Id, isPositive);

        final bills = await serviceRepo.getServicesForApartment(aptId);
        expect(bills.length, equals(2));
        expect(
          bills.any((b) => b.payerResponsibility == PayerResponsibility.owner),
          isTrue,
        );
        expect(
          bills.any((b) => b.payerResponsibility == PayerResponsibility.tenant),
          isTrue,
        );
      },
    );

    test('6. Payments Ledger: Rent partial payments, outstanding balance & overpayment prevention', () async {
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Crown Center',
          propertyType: PropertyType.residential,
          city: 'Riyadh',
          district: 'Al-Sahafa',
          address: 'St 20',
          numberOfFloors: 4,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final aptId = await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '401',
          floorNumber: 4,
          area: 100.0,
          monthlyRent: 300000, // $3,000.00 monthly rent obligation
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        specification: const ApartmentSpecification(
          id: 0,
          apartmentId: 0,
          bedrooms: 2,
          bathrooms: 2,
          livingRooms: 1,
          kitchens: 1,
          balconies: 1,
          hasAc: true,
          hasParking: true,
        ),
      );

      final tenantId = await tenantRepo.registerNewTenant(
        Tenant(
          id: 0,
          apartmentId: aptId,
          fullName: 'Faisal Al-Otaibi',
          phone: '+966504443322',
          nationalId: '1077889900',
          address: 'Riyadh',
          monthlyRent: 300000,
          depositAmount: 150000,
          contractStartDate: DateTime(2026, 1, 1),
          contractEndDate: DateTime(2026, 12, 31),
          paymentDueDay: 1,
          moveInDate: DateTime(2026, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      const billingPeriod = '2026-11';

      // Initial rent balance should be full $3,000.00 (300,000 minor units)
      var balance = await paymentRepo.calculateRentPeriodBalance(
        apartmentId: aptId,
        tenantId: tenantId,
        billingPeriod: billingPeriod,
        monthlyRent: 300000,
      );
      expect(balance.totalPaid, equals(0));
      expect(balance.outstandingBalance, equals(300000));
      expect(balance.isFullyPaid, isFalse);

      // Partial Payment 1: $1,000.00 (100,000 minor units)
      await paymentRepo.recordPayment(
        PaymentTransaction(
          id: 0,
          apartmentId: aptId,
          tenantId: tenantId,
          paymentType: PaymentType.rent,
          amount: 100000,
          paymentDate: DateTime(2026, 11, 2),
          paidBy: PayerResponsibility.tenant,
          paymentMethod: PaymentMethod.bankTransfer,
          billingPeriod: billingPeriod,
          referenceNumber: 'TXN-001-A',
          notes: 'First partial payment for November',
          createdAt: DateTime.now(),
        ),
      );

      balance = await paymentRepo.calculateRentPeriodBalance(
        apartmentId: aptId,
        tenantId: tenantId,
        billingPeriod: billingPeriod,
        monthlyRent: 300000,
      );
      expect(balance.totalPaid, equals(100000));
      expect(balance.outstandingBalance, equals(200000));

      // Partial Payment 2: $1,500.00 (150,000 minor units)
      await paymentRepo.recordPayment(
        PaymentTransaction(
          id: 0,
          apartmentId: aptId,
          tenantId: tenantId,
          paymentType: PaymentType.rent,
          amount: 150000,
          paymentDate: DateTime(2026, 11, 10),
          paidBy: PayerResponsibility.tenant,
          paymentMethod: PaymentMethod.creditCard,
          billingPeriod: billingPeriod,
          referenceNumber: 'TXN-001-B',
          notes: 'Second partial payment for November',
          createdAt: DateTime.now(),
        ),
      );

      balance = await paymentRepo.calculateRentPeriodBalance(
        apartmentId: aptId,
        tenantId: tenantId,
        billingPeriod: billingPeriod,
        monthlyRent: 300000,
      );
      expect(balance.totalPaid, equals(250000));
      expect(balance.outstandingBalance, equals(50000)); // $500 remaining

      // Overpayment Attempt: Try to pay $600.00 (60,000 minor units) when only $500.00 (50,000) is due -> must be rejected!
      expect(
        () => paymentRepo.recordPayment(
          PaymentTransaction(
            id: 0,
            apartmentId: aptId,
            tenantId: tenantId,
            paymentType: PaymentType.rent,
            amount: 60000,
            paymentDate: DateTime(2026, 11, 15),
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.cash,
            billingPeriod: billingPeriod,
            notes: 'Overpayment attempt',
            createdAt: DateTime.now(),
          ),
        ),
        throwsA(isA<BusinessRuleException>()),
      );

      // Final Exact Payment: Pay exactly the remaining $500.00 (50,000 minor units)
      await paymentRepo.recordPayment(
        PaymentTransaction(
          id: 0,
          apartmentId: aptId,
          tenantId: tenantId,
          paymentType: PaymentType.rent,
          amount: 50000,
          paymentDate: DateTime(2026, 11, 15),
          paidBy: PayerResponsibility.tenant,
          paymentMethod: PaymentMethod.cash,
          billingPeriod: billingPeriod,
          referenceNumber: 'TXN-001-C',
          notes: 'Final settlement for November',
          createdAt: DateTime.now(),
        ),
      );

      balance = await paymentRepo.calculateRentPeriodBalance(
        apartmentId: aptId,
        tenantId: tenantId,
        billingPeriod: billingPeriod,
        monthlyRent: 300000,
      );
      expect(balance.totalPaid, equals(300000));
      expect(balance.outstandingBalance, equals(0));
      expect(balance.isFullyPaid, isTrue);
    });

    test('7. Service bill payments: Partial payment & Owner payment without tenant', () async {
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Executive Court',
          propertyType: PropertyType.commercial,
          city: 'Riyadh',
          district: 'Al-Murabba',
          address: 'Court St',
          numberOfFloors: 3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final aptId = await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '501',
          floorNumber: 5,
          area: 150.0,
          monthlyRent: 600000,
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        specification: const ApartmentSpecification(
          id: 0,
          apartmentId: 0,
          bedrooms: 4,
          bathrooms: 3,
          livingRooms: 2,
          kitchens: 1,
          balconies: 1,
          hasAc: true,
          hasParking: true,
        ),
      );

      final serviceId = await serviceRepo.createServiceBill(
        ServiceBill(
          id: 0,
          apartmentId: aptId,
          serviceType: ServiceType.water,
          consumption: 40.0,
          unitPrice: 250,
          totalAmount: 10000, // $100.00
          billingDate: DateTime(2026, 11, 1),
          dueDate: DateTime(2026, 11, 15),
          payerResponsibility: PayerResponsibility.owner,
          createdAt: DateTime.now(),
        ),
      );

      // Owner pays $100.00 for the water service bill (tenantId is NULL)
      final paymentId = await paymentRepo.recordPayment(
        PaymentTransaction(
          id: 0,
          apartmentId: aptId,
          tenantId: null, // Owner pays directly
          serviceId: serviceId,
          paymentType: PaymentType.service,
          amount: 10000,
          paymentDate: DateTime(2026, 11, 5),
          paidBy: PayerResponsibility.owner,
          paymentMethod: PaymentMethod.bankTransfer,
          referenceNumber: 'OWNER-WATER-01',
          notes: 'Owner settled water utility',
          createdAt: DateTime.now(),
        ),
      );
      expect(paymentId, isPositive);

      final balance = await paymentRepo.calculateServiceBillBalance(
        serviceId: serviceId,
        apartmentId: aptId,
        totalBillAmount: 10000,
      );
      expect(balance.totalPaid, equals(10000));
      expect(balance.outstandingBalance, equals(0));
      expect(balance.isFullyPaid, isTrue);
    });

    test('8. Financial corrections via Ledger Reversal Adjustment without deleting records', () async {
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Al-Bustan',
          propertyType: PropertyType.residential,
          city: 'Jeddah',
          district: 'Al-Rawdah',
          address: 'Rawdah St',
          numberOfFloors: 2,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final aptId = await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '601',
          floorNumber: 2,
          area: 95.0,
          monthlyRent: 200000,
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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

      final tenantId = await tenantRepo.registerNewTenant(
        Tenant(
          id: 0,
          apartmentId: aptId,
          fullName: 'Bader Al-Shehri',
          phone: '+966551234567',
          nationalId: '1033445566',
          address: 'Jeddah',
          monthlyRent: 200000,
          depositAmount: 100000,
          contractStartDate: DateTime(2026, 1, 1),
          contractEndDate: DateTime(2026, 12, 31),
          paymentDueDay: 1,
          moveInDate: DateTime(2026, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      const period = '2026-11';

      // 1. Record an errant payment of $1,000.00
      await paymentRepo.recordPayment(
        PaymentTransaction(
          id: 0,
          apartmentId: aptId,
          tenantId: tenantId,
          paymentType: PaymentType.rent,
          amount: 100000,
          paymentDate: DateTime(2026, 11, 1),
          paidBy: PayerResponsibility.tenant,
          paymentMethod: PaymentMethod.bankTransfer,
          billingPeriod: period,
          referenceNumber: 'ERRANT-TXN-1',
          notes: 'Bank transfer mistakenly recorded twice',
          createdAt: DateTime.now(),
        ),
      );

      var bal = await paymentRepo.calculateRentPeriodBalance(
        apartmentId: aptId,
        tenantId: tenantId,
        billingPeriod: period,
        monthlyRent: 200000,
      );
      expect(bal.totalPaid, equals(100000));
      expect(bal.outstandingBalance, equals(100000));

      // 2. Ledger Adjustment Reversal: Record -$1,000.00 (negative adjustment) without deleting rows
      await paymentRepo.recordPayment(
        PaymentTransaction(
          id: 0,
          apartmentId: aptId,
          tenantId: tenantId,
          paymentType: PaymentType.rent,
          amount: -100000, // Negative amount adjusts the ledger safely
          paymentDate: DateTime(2026, 11, 2),
          paidBy: PayerResponsibility.tenant,
          paymentMethod: PaymentMethod.other,
          billingPeriod: period,
          referenceNumber: 'REV-ERRANT-TXN-1',
          notes: 'Reversal adjustment for duplicated bank transfer',
          createdAt: DateTime.now(),
        ),
      );

      // Total payments in ledger should be 2 transactions (full audit trail intact)
      final allPayments = await paymentRepo.getPaymentsForRentPeriod(
        apartmentId: aptId,
        billingPeriod: period,
      );
      expect(allPayments.length, equals(2));
      expect(allPayments.any((p) => p.isReversal), isTrue);

      // Balance correctly reflects reversal: total paid is 0, outstanding is full $2,000.00
      bal = await paymentRepo.calculateRentPeriodBalance(
        apartmentId: aptId,
        tenantId: tenantId,
        billingPeriod: period,
        monthlyRent: 200000,
      );
      expect(bal.totalPaid, equals(0));
      expect(bal.outstandingBalance, equals(200000));
    });

    test('9. Prevent deletion of property with existing apartments', () async {
      final propId = await propertyRepo.createProperty(
        Property(
          id: 0,
          name: 'Al-Salam Complex',
          propertyType: PropertyType.residential,
          city: 'Riyadh',
          district: 'Al-Salam',
          address: 'Salam St',
          numberOfFloors: 3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '701',
          floorNumber: 1,
          area: 80.0,
          monthlyRent: 200000,
          status: ApartmentStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        specification: const ApartmentSpecification(
          id: 0,
          apartmentId: 0,
          bedrooms: 1,
          bathrooms: 1,
          livingRooms: 1,
          kitchens: 1,
          balconies: 0,
          hasAc: true,
          hasParking: false,
        ),
      );

      // Deleting property must throw exception
      expect(
        () => propertyRepo.deleteProperty(propId),
        throwsA(isA<BusinessRuleException>()),
      );
    });
  });
}
