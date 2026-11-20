import 'package:drift/native.dart';
import 'package:test/test.dart';
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
import 'package:production_login/features/properties/domain/entities/property_stats.dart';
import 'package:production_login/features/properties/domain/usecases/properties_usecases.dart';

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl propertyRepo;
  late ApartmentRepositoryImpl apartmentRepo;
  late GetPropertiesUseCase getPropertiesUseCase;
  late GetPropertyByIdUseCase getPropertyByIdUseCase;
  late CreatePropertyUseCase createPropertyUseCase;
  late UpdatePropertyUseCase updatePropertyUseCase;
  late DeletePropertyUseCase deletePropertyUseCase;
  late GetApartmentsByPropertyUseCase getApartmentsUseCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    propertyRepo = PropertyRepositoryImpl(db);
    apartmentRepo = ApartmentRepositoryImpl(db);

    getPropertiesUseCase = GetPropertiesUseCase(propertyRepo);
    getPropertyByIdUseCase = GetPropertyByIdUseCase(propertyRepo);
    createPropertyUseCase = CreatePropertyUseCase(propertyRepo);
    updatePropertyUseCase = UpdatePropertyUseCase(propertyRepo);
    deletePropertyUseCase = DeletePropertyUseCase(propertyRepo);
    getApartmentsUseCase = GetApartmentsByPropertyUseCase(apartmentRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('Properties Module Clean Architecture Verification', () {
    test('1. Property creation with full fields', () async {
      final now = DateTime.now();
      final prop = Property(
        id: 0,
        name: 'برج الأندلس السكني',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'العليا',
        address: 'طريق الملك فهد، مبنى 45',
        description: 'مجمع سكني فاخر متكامل الخدمات',
        imagePath: 'https://images.unsplash.com/property1.jpg',
        numberOfFloors: 8,
        createdAt: now,
        updatedAt: now,
      );

      final propId = await createPropertyUseCase(prop);
      expect(propId, isPositive);

      final properties = await getPropertiesUseCase();
      expect(properties.length, equals(1));

      final created = properties.first;
      expect(created.name, equals('برج الأندلس السكني'));
      expect(created.propertyType, equals(PropertyType.residential));
      expect(created.city, equals('الرياض'));
      expect(created.district, equals('العليا'));
      expect(created.numberOfFloors, equals(8));
      expect(
        created.imagePath,
        equals('https://images.unsplash.com/property1.jpg'),
      );
    });

    test('2. Property editing / updating details', () async {
      final now = DateTime.now();
      final propId = await createPropertyUseCase(
        Property(
          id: 0,
          name: 'عمارة النرجس',
          propertyType: PropertyType.residential,
          city: 'جدة',
          district: 'الروضة',
          address: 'شارع صاري',
          numberOfFloors: 3,
          createdAt: now,
          updatedAt: now,
        ),
      );

      var properties = await getPropertiesUseCase();
      expect(properties.length, equals(1));

      final updated = Property(
        id: propId,
        name: 'عمارة النرجس المحدثة',
        propertyType: PropertyType.commercial,
        city: 'جدة',
        district: 'الروضة',
        address: 'شارع الأمير سلطان',
        description: 'تم تحويل العقار إلى تجاري',
        numberOfFloors: 4,
        createdAt: now,
        updatedAt: DateTime.now(),
      );

      await updatePropertyUseCase(updated);

      final fetched = await getPropertyByIdUseCase(propId);
      expect(fetched, isNotNull);
      expect(fetched!.name, equals('عمارة النرجس المحدثة'));
      expect(fetched.propertyType, equals(PropertyType.commercial));
      expect(fetched.numberOfFloors, equals(4));
      expect(fetched.address, equals('شارع الأمير سلطان'));
    });

    test('3. Property deletion restriction when apartments exist', () async {
      final now = DateTime.now();
      final propId = await createPropertyUseCase(
        Property(
          id: 0,
          name: 'مجمع الواحة',
          propertyType: PropertyType.residential,
          city: 'الدمام',
          district: 'الشاطئ',
          address: 'شارع الخليج',
          numberOfFloors: 5,
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Add apartment associated with this property
      await apartmentRepo.createApartment(
        apartment: Apartment(
          id: 0,
          propertyId: propId,
          apartmentNumber: '101',
          floorNumber: 1,
          area: 120.0,
          monthlyRent: 350000,
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

      // Deletion must throw BusinessRuleException
      expect(
        () => deletePropertyUseCase(propId),
        throwsA(isA<BusinessRuleException>()),
      );

      final properties = await getPropertiesUseCase();
      expect(properties.length, equals(1));
    });

    test('4. Successful property deletion when no apartments exist', () async {
      final now = DateTime.now();
      final propId = await createPropertyUseCase(
        Property(
          id: 0,
          name: 'أرض فارغة / عقار تحت الإنشاء',
          propertyType: PropertyType.residential,
          city: 'الرياض',
          district: 'الملقا',
          address: 'طريق أنس بن مالك',
          numberOfFloors: 2,
          createdAt: now,
          updatedAt: now,
        ),
      );

      var properties = await getPropertiesUseCase();
      expect(properties.length, equals(1));

      await deletePropertyUseCase(propId);

      properties = await getPropertiesUseCase();
      expect(properties.length, equals(0));
    });

    test('5. Property search by name, city, district, and address', () async {
      final now = DateTime.now();
      await createPropertyUseCase(
        Property(
          id: 0,
          name: 'برج المملكة بلازا',
          propertyType: PropertyType.commercial,
          city: 'الرياض',
          district: 'العليا',
          address: 'طريق العروبة',
          numberOfFloors: 12,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await createPropertyUseCase(
        Property(
          id: 0,
          name: 'فيلا الياسمين',
          propertyType: PropertyType.villa,
          city: 'الرياض',
          district: 'الياسمين',
          address: 'شارع القادسية',
          numberOfFloors: 2,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await createPropertyUseCase(
        Property(
          id: 0,
          name: 'عمارة الكورنيش',
          propertyType: PropertyType.residential,
          city: 'جدة',
          district: 'الشاطئ',
          address: 'طريق الكورنيش',
          numberOfFloors: 6,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final all = await getPropertiesUseCase();
      expect(all.length, equals(3));

      // Helper function matching controller search logic
      List<Property> search(String query) {
        final q = query.trim().toLowerCase();
        return all.where((p) {
          return p.name.toLowerCase().contains(q) ||
              p.city.toLowerCase().contains(q) ||
              p.district.toLowerCase().contains(q) ||
              p.address.toLowerCase().contains(q);
        }).toList();
      }

      // Search by name
      expect(search('المملكة').length, equals(1));
      expect(search('المملكة').first.name, equals('برج المملكة بلازا'));

      // Search by district
      expect(search('الياسمين').length, equals(1));
      expect(search('الياسمين').first.name, equals('فيلا الياسمين'));

      // Search by city
      expect(search('جدة').length, equals(1));
      expect(search('جدة').first.name, equals('عمارة الكورنيش'));
    });

    test('6. Property filtering by type, city, and district', () async {
      final now = DateTime.now();
      await createPropertyUseCase(
        Property(
          id: 0,
          name: 'مبنى 1',
          propertyType: PropertyType.residential,
          city: 'الرياض',
          district: 'الصحافة',
          address: 'شارع 1',
          numberOfFloors: 3,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await createPropertyUseCase(
        Property(
          id: 0,
          name: 'مبنى 2',
          propertyType: PropertyType.commercial,
          city: 'الرياض',
          district: 'العليا',
          address: 'شارع 2',
          numberOfFloors: 4,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await createPropertyUseCase(
        Property(
          id: 0,
          name: 'مبنى 3',
          propertyType: PropertyType.residential,
          city: 'مكة',
          district: 'العزيزية',
          address: 'شارع 3',
          numberOfFloors: 5,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final all = await getPropertiesUseCase();

      // Filter by type: residential
      final residential = all
          .where((p) => p.propertyType == PropertyType.residential)
          .toList();
      expect(residential.length, equals(2));

      // Filter by city: الرياض (residential in Riyadh)
      final riyadhResidential = residential
          .where((p) => p.city == 'الرياض')
          .toList();
      expect(riyadhResidential.length, equals(1));
      expect(riyadhResidential.first.name, equals('مبنى 1'));
    });

    test(
      '7. Apartment relationship queries & occupancy calculations',
      () async {
        final now = DateTime.now();
        final propId = await createPropertyUseCase(
          Property(
            id: 0,
            name: 'برج السعادة',
            propertyType: PropertyType.residential,
            city: 'الرياض',
            district: 'حطين',
            address: 'شارع تركي الأول',
            numberOfFloors: 4,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Add 2 occupied apartments ($4,000 and $5,000 monthly rent)
        await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: 'A1',
            floorNumber: 1,
            area: 100.0,
            monthlyRent: 400000,
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
            balconies: 0,
            hasAc: true,
            hasParking: true,
          ),
        );

        await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: 'A2',
            floorNumber: 1,
            area: 120.0,
            monthlyRent: 500000,
            status: ApartmentStatus.occupied,
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

        // Add 1 available and 1 maintenance apartment
        await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: 'B1',
            floorNumber: 2,
            area: 90.0,
            monthlyRent: 350000,
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

        await apartmentRepo.createApartment(
          apartment: Apartment(
            id: 0,
            propertyId: propId,
            apartmentNumber: 'B2',
            floorNumber: 2,
            area: 95.0,
            monthlyRent: 360000,
            status: ApartmentStatus.maintenance,
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
            hasAc: false,
            hasParking: false,
          ),
        );

        // Query apartments for this property
        final apts = await getApartmentsUseCase(propId);
        expect(apts.length, equals(4));

        // Calculate stats using PropertyStats logic
        int occupied = 0;
        int available = 0;
        int maintenance = 0;
        int expectedIncome = 0;

        for (final apt in apts) {
          if (apt.status == ApartmentStatus.occupied) {
            occupied++;
            expectedIncome += apt.monthlyRent;
          } else if (apt.status == ApartmentStatus.available) {
            available++;
          } else if (apt.status == ApartmentStatus.maintenance) {
            maintenance++;
          }
        }

        final rate = apts.isNotEmpty ? (occupied / apts.length) * 100 : 0.0;
        final stats = PropertyStats(
          propertyId: propId,
          totalApartments: apts.length,
          occupiedApartments: occupied,
          availableApartments: available,
          maintenanceApartments: maintenance,
          occupancyRate: rate,
          expectedMonthlyIncome: expectedIncome,
        );

        expect(stats.totalApartments, equals(4));
        expect(stats.occupiedApartments, equals(2));
        expect(stats.availableApartments, equals(1));
        expect(stats.maintenanceApartments, equals(1));

        // Occupancy percentage: 2 / 4 = 50.0%
        expect(stats.occupancyRate, equals(50.0));

        // Expected monthly income: 400,000 + 500,000 = 900,000 minor units ($9,000.00)
        expect(stats.expectedMonthlyIncome, equals(900000));
      },
    );
  });
}
