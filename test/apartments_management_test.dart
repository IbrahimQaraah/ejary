import 'package:drift/native.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/enums/apartment_status.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/core/error/exceptions.dart';
import 'package:production_login/features/apartments/data/repositories/apartment_repository_impl.dart';
import 'package:production_login/features/apartments/domain/entities/apartment.dart';
import 'package:production_login/features/apartments/domain/entities/apartment_specification.dart';
import 'package:production_login/features/apartments/domain/usecases/apartments_usecases.dart';
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

  // UseCases
  late GetApartmentsUseCase getAllApartmentsUseCase;
  late GetApartmentByIdUseCase getApartmentByIdUseCase;
  late GetApartmentsByPropertyUseCase getApartmentsByPropertyUseCase;
  late GetApartmentSpecificationUseCase getSpecificationUseCase;
  late CreateApartmentUseCase createApartmentUseCase;
  late UpdateApartmentUseCase updateApartmentUseCase;
  late UpdateApartmentStatusUseCase updateApartmentStatusUseCase;
  late DeleteApartmentUseCase deleteApartmentUseCase;

  int propertyAId = 0;
  int propertyBId = 0;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);
    tenantRepo = TenantRepositoryImpl(db);

    getAllApartmentsUseCase = GetApartmentsUseCase(apartmentRepo);
    getApartmentByIdUseCase = GetApartmentByIdUseCase(apartmentRepo);
    getApartmentsByPropertyUseCase = GetApartmentsByPropertyUseCase(
      apartmentRepo,
    );
    getSpecificationUseCase = GetApartmentSpecificationUseCase(apartmentRepo);
    createApartmentUseCase = CreateApartmentUseCase(apartmentRepo);
    updateApartmentUseCase = UpdateApartmentUseCase(apartmentRepo);
    updateApartmentStatusUseCase = UpdateApartmentStatusUseCase(apartmentRepo);
    deleteApartmentUseCase = DeleteApartmentUseCase(apartmentRepo);

    // Create seed properties
    final now = DateTime.now();
    propertyAId = await propertyRepo.createProperty(
      Property(
        id: 0,
        name: 'برج الياسمين',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'النرجس',
        address: 'شارع عثمان بن عفان',
        numberOfFloors: 5,
        createdAt: now,
        updatedAt: now,
      ),
    );

    propertyBId = await propertyRepo.createProperty(
      Property(
        id: 0,
        name: 'عمارة الفلاح',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'الفلاح',
        address: 'طريق المطار',
        numberOfFloors: 3,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group(
    'Apartments Module Clean Architecture & Business Rules Verification',
    () {
      test(
        '1. Create apartment and specification in a single transaction',
        () async {
          final now = DateTime.now();
          final apt = Apartment(
            id: 0,
            propertyId: propertyAId,
            apartmentNumber: '101',
            floorNumber: 1,
            area: 135.5,
            monthlyRent: 350000, // 3,500.00 SAR in minor units
            status: ApartmentStatus.available,
            description: 'شقة فاخرة واجهة أمامية',
            createdAt: now,
            updatedAt: now,
          );

          final spec = ApartmentSpecification(
            id: 0,
            apartmentId: 0,
            bedrooms: 3,
            bathrooms: 2,
            livingRooms: 1,
            kitchens: 1,
            balconies: 1,
            hasAc: true,
            hasParking: true,
            additionalFeatures: 'مطبخ راكب إيطالي، أجهزة كهربائية مدمجة',
          );

          final aptId = await createApartmentUseCase(
            apartment: apt,
            specification: spec,
          );

          expect(aptId, isPositive);

          // Verify apartment retrieval
          final createdApt = await getApartmentByIdUseCase(aptId);
          expect(createdApt, isNotNull);
          expect(createdApt!.apartmentNumber, equals('101'));
          expect(createdApt.floorNumber, equals(1));
          expect(createdApt.area, equals(135.5));
          expect(createdApt.monthlyRent, equals(350000));
          expect(createdApt.status, equals(ApartmentStatus.available));
          expect(createdApt.description, equals('شقة فاخرة واجهة أمامية'));

          // Verify specification retrieval
          final createdSpec = await getSpecificationUseCase(aptId);
          expect(createdSpec, isNotNull);
          expect(createdSpec!.apartmentId, equals(aptId));
          expect(createdSpec.bedrooms, equals(3));
          expect(createdSpec.bathrooms, equals(2));
          expect(createdSpec.livingRooms, equals(1));
          expect(createdSpec.kitchens, equals(1));
          expect(createdSpec.balconies, equals(1));
          expect(createdSpec.hasAc, isTrue);
          expect(createdSpec.hasParking, isTrue);
          expect(
            createdSpec.additionalFeatures,
            equals('مطبخ راكب إيطالي، أجهزة كهربائية مدمجة'),
          );
        },
      );

      test(
        '2. Rejection of duplicate apartment number in the same property',
        () async {
          final now = DateTime.now();
          final apt1 = Apartment(
            id: 0,
            propertyId: propertyAId,
            apartmentNumber: '201',
            floorNumber: 2,
            area: 120,
            monthlyRent: 300000,
            status: ApartmentStatus.available,
            createdAt: now,
            updatedAt: now,
          );
          final spec = const ApartmentSpecification(
            id: 0,
            apartmentId: 0,
            bedrooms: 2,
            bathrooms: 2,
            livingRooms: 1,
            kitchens: 1,
            balconies: 0,
            hasAc: true,
            hasParking: false,
          );

          await createApartmentUseCase(apartment: apt1, specification: spec);

          // Attempt duplicate apartment number in propertyA
          final aptDuplicate = Apartment(
            id: 0,
            propertyId: propertyAId,
            apartmentNumber: '201',
            floorNumber: 2,
            area: 120,
            monthlyRent: 320000,
            status: ApartmentStatus.available,
            createdAt: now,
            updatedAt: now,
          );

          expect(
            () => createApartmentUseCase(
              apartment: aptDuplicate,
              specification: spec,
            ),
            throwsA(isA<BusinessRuleException>()),
          );
        },
      );

      test(
        '3. Same apartment number in different properties is allowed',
        () async {
          final now = DateTime.now();
          final spec = const ApartmentSpecification(
            id: 0,
            apartmentId: 0,
            bedrooms: 2,
            bathrooms: 1,
            livingRooms: 1,
            kitchens: 1,
            balconies: 0,
            hasAc: true,
            hasParking: true,
          );

          // Apt 101 in Property A
          final aptA = Apartment(
            id: 0,
            propertyId: propertyAId,
            apartmentNumber: '101',
            floorNumber: 1,
            area: 100,
            monthlyRent: 250000,
            status: ApartmentStatus.available,
            createdAt: now,
            updatedAt: now,
          );
          final idA = await createApartmentUseCase(
            apartment: aptA,
            specification: spec,
          );

          // Apt 101 in Property B
          final aptB = Apartment(
            id: 0,
            propertyId: propertyBId,
            apartmentNumber: '101',
            floorNumber: 1,
            area: 110,
            monthlyRent: 260000,
            status: ApartmentStatus.available,
            createdAt: now,
            updatedAt: now,
          );
          final idB = await createApartmentUseCase(
            apartment: aptB,
            specification: spec,
          );

          expect(idA, isPositive);
          expect(idB, isPositive);
          expect(idA, isNot(equals(idB)));

          final listA = await getApartmentsByPropertyUseCase(propertyAId);
          final listB = await getApartmentsByPropertyUseCase(propertyBId);

          expect(listA.length, equals(1));
          expect(listB.length, equals(1));
          expect(listA.first.apartmentNumber, equals('101'));
          expect(listB.first.apartmentNumber, equals('101'));
        },
      );

      test(
        '4. Update apartment details and specification atomically',
        () async {
          final now = DateTime.now();
          final aptId = await createApartmentUseCase(
            apartment: Apartment(
              id: 0,
              propertyId: propertyAId,
              apartmentNumber: '301',
              floorNumber: 3,
              area: 140,
              monthlyRent: 380000,
              status: ApartmentStatus.available,
              description: 'الوصف الأصلي',
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
              hasAc: false,
              hasParking: false,
            ),
          );

          // Update both
          await updateApartmentUseCase(
            apartment: Apartment(
              id: aptId,
              propertyId: propertyAId,
              apartmentNumber: '301-A',
              floorNumber: 3,
              area: 155,
              monthlyRent: 420000,
              status: ApartmentStatus.maintenance,
              description: 'تم التجديد بالكامل مع تركيب رخام',
              createdAt: now,
              updatedAt: DateTime.now(),
            ),
            specification: ApartmentSpecification(
              id: 0,
              apartmentId: aptId,
              bedrooms: 4,
              bathrooms: 3,
              livingRooms: 2,
              kitchens: 1,
              balconies: 2,
              hasAc: true,
              hasParking: true,
              additionalFeatures: 'موقفين سيارة مظللة وتكييف دكت جديد',
            ),
          );

          final updatedApt = await getApartmentByIdUseCase(aptId);
          expect(updatedApt!.apartmentNumber, equals('301-A'));
          expect(updatedApt.area, equals(155));
          expect(updatedApt.monthlyRent, equals(420000));
          expect(updatedApt.status, equals(ApartmentStatus.maintenance));
          expect(
            updatedApt.description,
            equals('تم التجديد بالكامل مع تركيب رخام'),
          );

          final updatedSpec = await getSpecificationUseCase(aptId);
          expect(updatedSpec!.bedrooms, equals(4));
          expect(updatedSpec.bathrooms, equals(3));
          expect(updatedSpec.livingRooms, equals(2));
          expect(updatedSpec.balconies, equals(2));
          expect(updatedSpec.hasAc, isTrue);
          expect(updatedSpec.hasParking, isTrue);
          expect(
            updatedSpec.additionalFeatures,
            equals('موقفين سيارة مظللة وتكييف دكت جديد'),
          );
        },
      );

      test('5. Update apartment status independently', () async {
        final now = DateTime.now();
        final aptId = await createApartmentUseCase(
          apartment: Apartment(
            id: 0,
            propertyId: propertyAId,
            apartmentNumber: '401',
            floorNumber: 4,
            area: 130,
            monthlyRent: 310000,
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

        await updateApartmentStatusUseCase(aptId, ApartmentStatus.occupied);
        var apt = await getApartmentByIdUseCase(aptId);
        expect(apt!.status, equals(ApartmentStatus.occupied));

        await updateApartmentStatusUseCase(aptId, ApartmentStatus.maintenance);
        apt = await getApartmentByIdUseCase(aptId);
        expect(apt!.status, equals(ApartmentStatus.maintenance));
      });

      test(
        '6. Delete apartment cascades to specification when no tenants exist',
        () async {
          final now = DateTime.now();
          final aptId = await createApartmentUseCase(
            apartment: Apartment(
              id: 0,
              propertyId: propertyAId,
              apartmentNumber: '501',
              floorNumber: 5,
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

          // Verify existence before delete
          expect(await getApartmentByIdUseCase(aptId), isNotNull);
          expect(await getSpecificationUseCase(aptId), isNotNull);

          // Delete apartment
          await deleteApartmentUseCase(aptId);

          // Both apartment and its specification should no longer exist
          expect(await getApartmentByIdUseCase(aptId), isNull);
          expect(await getSpecificationUseCase(aptId), isNull);
        },
      );

      test('7. Referential integrity: cannot delete apartment with registered tenant', () async {
        final now = DateTime.now();
        final aptId = await createApartmentUseCase(
          apartment: Apartment(
            id: 0,
            propertyId: propertyAId,
            apartmentNumber: '601',
            floorNumber: 6,
            area: 125,
            monthlyRent: 330000,
            status: ApartmentStatus.occupied,
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
            balconies: 1,
            hasAc: true,
            hasParking: true,
          ),
        );

        // Register tenant attached to this apartment
        await tenantRepo.registerNewTenant(
          Tenant(
            id: 0,
            apartmentId: aptId,
            fullName: 'سلطان الحربي',
            nationalId: '1098765432',
            phone: '0551234567',
            address: 'شارع عثمان بن عفان',
            monthlyRent: 330000,
            depositAmount: 50000,
            contractStartDate: now.subtract(const Duration(days: 30)),
            contractEndDate: now.add(const Duration(days: 335)),
            paymentDueDay: 1,
            moveInDate: now.subtract(const Duration(days: 30)),
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Deleting apartment must fail with BusinessRuleException
        expect(
          () => deleteApartmentUseCase(aptId),
          throwsA(isA<BusinessRuleException>()),
        );

        // Apartment must remain intact
        expect(await getApartmentByIdUseCase(aptId), isNotNull);
      });

      test(
        '8. GetAllApartments retrieves all apartments across properties',
        () async {
          final now = DateTime.now();
          final spec = const ApartmentSpecification(
            id: 0,
            apartmentId: 0,
            bedrooms: 2,
            bathrooms: 1,
            livingRooms: 1,
            kitchens: 1,
            balconies: 0,
            hasAc: true,
            hasParking: false,
          );

          await createApartmentUseCase(
            apartment: Apartment(
              id: 0,
              propertyId: propertyAId,
              apartmentNumber: 'A-1',
              floorNumber: 1,
              area: 90,
              monthlyRent: 200000,
              status: ApartmentStatus.available,
              createdAt: now,
              updatedAt: now,
            ),
            specification: spec,
          );

          await createApartmentUseCase(
            apartment: Apartment(
              id: 0,
              propertyId: propertyBId,
              apartmentNumber: 'B-1',
              floorNumber: 1,
              area: 95,
              monthlyRent: 210000,
              status: ApartmentStatus.available,
              createdAt: now,
              updatedAt: now,
            ),
            specification: spec,
          );

          final allApts = await getAllApartmentsUseCase();
          expect(allApts.length, equals(2));
        },
      );
    },
  );
}
