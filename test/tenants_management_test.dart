import 'package:drift/native.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/enums/apartment_status.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/core/error/exceptions.dart';
import 'package:production_login/features/apartments/data/repositories/apartment_repository_impl.dart';
import 'package:production_login/features/apartments/domain/entities/apartment.dart';
import 'package:production_login/features/apartments/domain/entities/apartment_specification.dart';
import 'package:production_login/features/properties/data/repositories/property_repository_impl.dart';
import 'package:production_login/features/properties/domain/entities/property.dart';
import 'package:production_login/features/tenants/data/repositories/tenant_repository_impl.dart';
import 'package:production_login/features/tenants/domain/entities/tenant.dart';
import 'package:production_login/features/tenants/domain/usecases/tenants_usecases.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl propertyRepo;
  late ApartmentRepositoryImpl apartmentRepo;
  late TenantRepositoryImpl tenantRepo;

  late GetAllTenantsUseCase getAllTenantsUseCase;
  late GetTenantByIdUseCase getTenantByIdUseCase;
  late GetTenantsForApartmentUseCase getTenantsForApartmentUseCase;
  late GetActiveTenantUseCase getActiveTenantUseCase;
  late RegisterTenantUseCase registerTenantUseCase;
  late VacateTenantUseCase vacateTenantUseCase;
  late UpdateTenantUseCase updateTenantUseCase;

  int propertyId = 0;
  int apartment1Id = 0;
  int apartment2Id = 0;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);
    tenantRepo = TenantRepositoryImpl(db);

    getAllTenantsUseCase = GetAllTenantsUseCase(tenantRepo);
    getTenantByIdUseCase = GetTenantByIdUseCase(tenantRepo);
    getTenantsForApartmentUseCase = GetTenantsForApartmentUseCase(tenantRepo);
    getActiveTenantUseCase = GetActiveTenantUseCase(tenantRepo);
    registerTenantUseCase = RegisterTenantUseCase(tenantRepo);
    vacateTenantUseCase = VacateTenantUseCase(tenantRepo);
    updateTenantUseCase = UpdateTenantUseCase(tenantRepo);

    final now = DateTime.now();
    propertyId = await propertyRepo.createProperty(
      Property(
        id: 0,
        name: 'برج الواحة',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'الصحافة',
        address: 'طريق الملك عبدالعزيز',
        numberOfFloors: 4,
        createdAt: now,
        updatedAt: now,
      ),
    );

    apartment1Id = await apartmentRepo.createApartment(
      apartment: Apartment(
        id: 0,
        propertyId: propertyId,
        apartmentNumber: '101',
        floorNumber: 1,
        area: 120,
        monthlyRent: 300000, // 3,000 SAR
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

    apartment2Id = await apartmentRepo.createApartment(
      apartment: Apartment(
        id: 0,
        propertyId: propertyId,
        apartmentNumber: '102',
        floorNumber: 1,
        area: 140,
        monthlyRent: 350000, // 3,500 SAR
        status: ApartmentStatus.available,
        createdAt: now,
        updatedAt: now,
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
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Tenants Management Module Business Rules & Clean Architecture', () {
    test(
      '1. Register new tenant updates apartment status to occupied',
      () async {
        final now = DateTime.now();
        final tenantId = await registerTenantUseCase(
          Tenant(
            id: 0,
            apartmentId: apartment1Id,
            fullName: 'خالد بن فهد المنصور',
            phone: '0501234567',
            nationalId: '1023456789',
            address: 'الرياض - حي الملز',
            monthlyRent: 300000,
            depositAmount: 150000,
            contractStartDate: now,
            contractEndDate: now.add(const Duration(days: 365)),
            paymentDueDay: 1,
            moveInDate: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        expect(tenantId, isPositive);

        // Verify active tenant
        final active = await getActiveTenantUseCase(apartment1Id);
        expect(active, isNotNull);
        expect(active!.fullName, equals('خالد بن فهد المنصور'));
        expect(active.isActive, isTrue);

        final all = await getAllTenantsUseCase();
        expect(all.length, equals(1));

        // Verify apartment status changed to occupied
        final apt = await apartmentRepo.getApartmentById(apartment1Id);
        expect(apt!.status, equals(ApartmentStatus.occupied));
      },
    );

    test(
      '2. Reject registering a second active tenant in the same apartment',
      () async {
        final now = DateTime.now();
        await registerTenantUseCase(
          Tenant(
            id: 0,
            apartmentId: apartment1Id,
            fullName: 'المستأجر الأول',
            phone: '0501111111',
            nationalId: '1011111111',
            address: 'الرياض',
            monthlyRent: 300000,
            depositAmount: 100000,
            contractStartDate: now,
            contractEndDate: now.add(const Duration(days: 365)),
            paymentDueDay: 1,
            moveInDate: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Attempt second active tenant in apartment1Id
        expect(
          () => registerTenantUseCase(
            Tenant(
              id: 0,
              apartmentId: apartment1Id,
              fullName: 'المستأجر الثاني',
              phone: '0502222222',
              nationalId: '1022222222',
              address: 'الرياض',
              monthlyRent: 300000,
              depositAmount: 100000,
              contractStartDate: now,
              contractEndDate: now.add(const Duration(days: 365)),
              paymentDueDay: 1,
              moveInDate: now,
              createdAt: now,
              updatedAt: now,
            ),
          ),
          throwsA(isA<BusinessRuleException>()),
        );
      },
    );

    test(
      '3. Vacate tenant sets move_out_date and resets apartment to available',
      () async {
        final now = DateTime.now();
        final tenantId = await registerTenantUseCase(
          Tenant(
            id: 0,
            apartmentId: apartment1Id,
            fullName: 'عمر التميمي',
            phone: '0559998877',
            nationalId: '1099988776',
            address: 'الرياض',
            monthlyRent: 300000,
            depositAmount: 100000,
            contractStartDate: now.subtract(const Duration(days: 180)),
            contractEndDate: now.add(const Duration(days: 185)),
            paymentDueDay: 5,
            moveInDate: now.subtract(const Duration(days: 180)),
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Vacate tenant
        final vacateDate = now;
        await vacateTenantUseCase(tenantId: tenantId, moveOutDate: vacateDate);

        // Active tenant should be null now
        final active = await getActiveTenantUseCase(apartment1Id);
        expect(active, isNull);

        // Tenant record preserved in history
        final history = await getTenantsForApartmentUseCase(apartment1Id);
        expect(history.length, equals(1));
        expect(history.first.moveOutDate, isNotNull);
        expect(history.first.isActive, isFalse);

        // Apartment status changed back to available
        final apt = await apartmentRepo.getApartmentById(apartment1Id);
        expect(apt!.status, equals(ApartmentStatus.available));
      },
    );

    test(
      '4. Can register a new tenant in apartment after previous one vacated',
      () async {
        final now = DateTime.now();
        final t1 = await registerTenantUseCase(
          Tenant(
            id: 0,
            apartmentId: apartment1Id,
            fullName: 'سعد القديم',
            phone: '0501234567',
            nationalId: '1012345678',
            address: 'الرياض',
            monthlyRent: 300000,
            depositAmount: 100000,
            contractStartDate: now.subtract(const Duration(days: 365)),
            contractEndDate: now.subtract(const Duration(days: 10)),
            paymentDueDay: 1,
            moveInDate: now.subtract(const Duration(days: 365)),
            createdAt: now,
            updatedAt: now,
          ),
        );

        await vacateTenantUseCase(
          tenantId: t1,
          moveOutDate: now.subtract(const Duration(days: 5)),
        );

        // Now register new tenant
        final t2 = await registerTenantUseCase(
          Tenant(
            id: 0,
            apartmentId: apartment1Id,
            fullName: 'فيصل الجديد',
            phone: '0557654321',
            nationalId: '1098765432',
            address: 'الرياض',
            monthlyRent: 320000,
            depositAmount: 150000,
            contractStartDate: now,
            contractEndDate: now.add(const Duration(days: 365)),
            paymentDueDay: 1,
            moveInDate: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        expect(t2, isPositive);
        final active = await getActiveTenantUseCase(apartment1Id);
        expect(active!.fullName, equals('فيصل الجديد'));

        final allForApt = await getTenantsForApartmentUseCase(apartment1Id);
        expect(allForApt.length, equals(2));
      },
    );

    test('5. Update tenant details', () async {
      final now = DateTime.now();
      final tenantId = await registerTenantUseCase(
        Tenant(
          id: 0,
          apartmentId: apartment2Id,
          fullName: 'ماجد العتيبي',
          phone: '0503333333',
          nationalId: '1033333333',
          address: 'الرياض',
          monthlyRent: 350000,
          depositAmount: 100000,
          contractStartDate: now,
          contractEndDate: now.add(const Duration(days: 365)),
          paymentDueDay: 1,
          moveInDate: now,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final tenant = await getTenantByIdUseCase(tenantId);
      expect(tenant, isNotNull);

      final updated = Tenant(
        id: tenant!.id,
        apartmentId: tenant.apartmentId,
        fullName: 'ماجد بن فهد العتيبي (محدث)',
        phone: '0504444444',
        nationalId: tenant.nationalId,
        address: 'الرياض - حي الياسمين',
        monthlyRent: 360000,
        depositAmount: tenant.depositAmount,
        contractStartDate: tenant.contractStartDate,
        contractEndDate: tenant.contractEndDate,
        paymentDueDay: 15,
        moveInDate: tenant.moveInDate,
        notes: 'تم تحديث رقم الهاتف ويوم الاستحقاق',
        createdAt: tenant.createdAt,
        updatedAt: DateTime.now(),
      );

      await updateTenantUseCase(updated);

      final fetched = await getTenantByIdUseCase(tenantId);
      expect(fetched!.fullName, equals('ماجد بن فهد العتيبي (محدث)'));
      expect(fetched.phone, equals('0504444444'));
      expect(fetched.paymentDueDay, equals(15));
      expect(fetched.monthlyRent, equals(360000));
    });
  });
}
