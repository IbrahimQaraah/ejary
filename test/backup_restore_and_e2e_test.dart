import 'dart:convert';

import 'package:drift/native.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/enums/apartment_status.dart';
import 'package:production_login/core/enums/payer_responsibility.dart';
import 'package:production_login/core/enums/payment_method.dart';
import 'package:production_login/core/enums/payment_type.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/core/enums/service_type.dart';
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
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl propertyRepo;
  late ApartmentRepositoryImpl apartmentRepo;
  late TenantRepositoryImpl tenantRepo;
  late PaymentRepositoryImpl paymentRepo;
  late ServiceRepositoryImpl serviceRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);
    tenantRepo = TenantRepositoryImpl(db);
    paymentRepo = PaymentRepositoryImpl(db);
    serviceRepo = ServiceRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group(
    'Complete Real-World End-To-End Business Workflow & Backup Verification',
    () {
      test('Full End-to-End Property, Apartment, Tenant, Payment & Service Lifecycle', () async {
        final now = DateTime.now();

        // 1. Create Property
        final propId = await propertyRepo.createProperty(
          Property(
            id: 0,
            name: 'أبراج السحاب السكنية',
            propertyType: PropertyType.residential,
            city: 'الرياض',
            district: 'الملقا',
            address: 'طريق أنس بن مالك',
            numberOfFloors: 6,
            createdAt: now,
            updatedAt: now,
          ),
        );
        expect(propId, isPositive);

        // 2. Add Apartment with specifications
        final aptId = await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: '302',
            floorNumber: 3,
            area: 150.0,
            monthlyRent: 400000, // 4,000 SAR
            status: ApartmentStatus.available,
            createdAt: now,
            updatedAt: now,
          ),
          specification: const ApartmentSpecification(
            id: 0,
            apartmentId: 0,
            bedrooms: 3,
            bathrooms: 3,
            livingRooms: 1,
            kitchens: 1,
            balconies: 1,
            hasAc: true,
            hasParking: true,
          ),
        );
        expect(aptId, isPositive);

        // Verify apartment initially available
        var apt = await apartmentRepo.getApartmentById(aptId);
        expect(apt!.status, equals(ApartmentStatus.available));

        // 3. Register Tenant in apartment
        final tenant1Id = await tenantRepo.registerNewTenant(
          Tenant(
            id: 0,
            apartmentId: aptId,
            fullName: 'طارق بن عبدالعزيز السعيد',
            phone: '0551122334',
            nationalId: '1055112233',
            address: 'الرياض',
            monthlyRent: 400000,
            depositAmount: 200000,
            contractStartDate: now,
            contractEndDate: now.add(const Duration(days: 365)),
            paymentDueDay: 1,
            moveInDate: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
        expect(tenant1Id, isPositive);

        // Verify apartment automatically became occupied
        apt = await apartmentRepo.getApartmentById(aptId);
        expect(apt!.status, equals(ApartmentStatus.occupied));

        // 4. Record Partial and Full Rent Payments
        final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';

        // 4a. Partial payment (2,000 SAR)
        await paymentRepo.recordPayment(
          PaymentTransaction(
            id: 0,
            apartmentId: aptId,
            tenantId: tenant1Id,
            paymentType: PaymentType.rent,
            amount: 200000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.bankTransfer,
            billingPeriod: period,
            referenceNumber: 'TXN-RENT-P1',
            createdAt: now,
          ),
        );

        var rentBal = await paymentRepo.calculateRentPeriodBalance(
          apartmentId: aptId,
          tenantId: tenant1Id,
          billingPeriod: period,
          monthlyRent: 400000,
        );
        expect(rentBal.totalPaid, equals(200000));
        expect(rentBal.outstandingBalance, equals(200000));
        expect(rentBal.isFullyPaid, isFalse);

        // 4b. Remaining payment (2,000 SAR)
        await paymentRepo.recordPayment(
          PaymentTransaction(
            id: 0,
            apartmentId: aptId,
            tenantId: tenant1Id,
            paymentType: PaymentType.rent,
            amount: 200000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.cash,
            billingPeriod: period,
            referenceNumber: 'TXN-RENT-P2',
            createdAt: now,
          ),
        );

        rentBal = await paymentRepo.calculateRentPeriodBalance(
          apartmentId: aptId,
          tenantId: tenant1Id,
          billingPeriod: period,
          monthlyRent: 400000,
        );
        expect(rentBal.totalPaid, equals(400000));
        expect(rentBal.outstandingBalance, equals(0));
        expect(rentBal.isFullyPaid, isTrue);

        // 5. Create Service Bill for Electricity
        final billId = await serviceRepo.createServiceBill(
          ServiceBill(
            id: 0,
            apartmentId: aptId,
            serviceType: ServiceType.electricity,
            previousReading: 2100.0,
            currentReading: 2350.0,
            consumption: 250.0,
            unitPrice: 0,
            totalAmount: 32000, // 320 SAR
            billingDate: now,
            dueDate: now.add(const Duration(days: 15)),
            payerResponsibility: PayerResponsibility.tenant,
            createdAt: now,
          ),
        );

        // Pay Electricity Bill
        await paymentRepo.recordPayment(
          PaymentTransaction(
            id: 0,
            apartmentId: aptId,
            tenantId: tenant1Id,
            serviceId: billId,
            paymentType: PaymentType.service,
            amount: 32000,
            paymentDate: now,
            paidBy: PayerResponsibility.tenant,
            paymentMethod: PaymentMethod.creditCard,
            referenceNumber: 'TXN-ELEC-01',
            createdAt: now,
          ),
        );

        final serviceBal = await paymentRepo.calculateServiceBillBalance(
          serviceId: billId,
          apartmentId: aptId,
          totalBillAmount: 32000,
        );
        expect(serviceBal.isFullyPaid, isTrue);

        // 6. Vacate Tenant
        await tenantRepo.vacateTenant(
          tenantId: tenant1Id,
          moveOutDate: now.add(const Duration(days: 30)),
        );

        // Verify apartment is available again
        apt = await apartmentRepo.getApartmentById(aptId);
        expect(apt!.status, equals(ApartmentStatus.available));

        // 7. Register New Tenant in same apartment
        final tenant2Id = await tenantRepo.registerNewTenant(
          Tenant(
            id: 0,
            apartmentId: aptId,
            fullName: 'فهد البقمي',
            phone: '0559988776',
            nationalId: '1099887766',
            address: 'الرياض',
            monthlyRent: 420000,
            depositAmount: 200000,
            contractStartDate: now.add(const Duration(days: 35)),
            contractEndDate: now.add(const Duration(days: 400)),
            paymentDueDay: 1,
            moveInDate: now.add(const Duration(days: 35)),
            createdAt: now,
            updatedAt: now,
          ),
        );
        expect(tenant2Id, isPositive);
        expect(tenant2Id, isNot(equals(tenant1Id)));

        // Verify apartment is occupied once more
        apt = await apartmentRepo.getApartmentById(aptId);
        expect(apt!.status, equals(ApartmentStatus.occupied));

        // Verify tenant history preserves both
        final tenantsHistory = await tenantRepo.getTenantsForApartment(aptId);
        expect(tenantsHistory.length, equals(2));

        // 8. Test Universal Backup and Restore of the complete database state
        final propsAll = await db.select(db.properties).get();
        final aptsAll = await db.select(db.apartments).get();
        final specsAll = await db.select(db.apartmentSpecifications).get();
        final tenantsAll = await db.select(db.tenants).get();
        final paymentsAll = await db.select(db.payments).get();
        final servicesAll = await db.select(db.services).get();

        final backupExport = {
          'version': 1,
          'tableCount': 6,
          'tables': {
            'properties': propsAll.map((p) => p.toJson()).toList(),
            'apartments': aptsAll.map((a) => a.toJson()).toList(),
            'apartmentSpecifications': specsAll.map((s) => s.toJson()).toList(),
            'tenants': tenantsAll.map((t) => t.toJson()).toList(),
            'payments': paymentsAll.map((p) => p.toJson()).toList(),
            'services': servicesAll.map((s) => s.toJson()).toList(),
          },
        };

        final serialized = jsonEncode(backupExport);
        expect(serialized.isNotEmpty, isTrue);

        // Wipe database
        await db.delete(db.payments).go();
        await db.delete(db.services).go();
        await db.delete(db.tenants).go();
        await db.delete(db.apartmentSpecifications).go();
        await db.delete(db.apartments).go();
        await db.delete(db.properties).go();

        expect((await propertyRepo.getAllProperties()).isEmpty, isTrue);
        expect((await apartmentRepo.getAllApartments()).isEmpty, isTrue);

        // Restore from backup
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final tables = decoded['tables'] as Map<String, dynamic>;

        await db.transaction(() async {
          for (final item in tables['properties']) {
            await db.into(db.properties).insert(PropertyEntry.fromJson(item));
          }
          for (final item in tables['apartments']) {
            await db.into(db.apartments).insert(ApartmentEntry.fromJson(item));
          }
          for (final item in tables['apartmentSpecifications']) {
            await db
                .into(db.apartmentSpecifications)
                .insert(ApartmentSpecificationEntry.fromJson(item));
          }
          for (final item in tables['tenants']) {
            await db.into(db.tenants).insert(TenantEntry.fromJson(item));
          }
          for (final item in tables['services']) {
            await db.into(db.services).insert(ServiceEntry.fromJson(item));
          }
          for (final item in tables['payments']) {
            await db.into(db.payments).insert(PaymentEntry.fromJson(item));
          }
        });

        // Verify complete restoration
        final restoredProps = await propertyRepo.getAllProperties();
        expect(restoredProps.length, equals(1));
        expect(restoredProps.first.name, equals('أبراج السحاب السكنية'));

        final restoredApts = await apartmentRepo.getAllApartments();
        expect(restoredApts.length, equals(1));
        expect(restoredApts.first.apartmentNumber, equals('302'));

        final restoredTenants = await tenantRepo.getAllTenants();
        expect(restoredTenants.length, equals(2));

        final restoredPayments = await paymentRepo.getAllPayments();
        expect(restoredPayments.length, equals(3));

        final restoredServices = await serviceRepo.getAllServices();
        expect(restoredServices.length, equals(1));
      });
    },
  );
}
