import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/enums/apartment_status.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/apartment.dart';
import '../../domain/entities/apartment_specification.dart';
import '../../domain/repositories/apartment_repository.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final AppDatabase db;

  ApartmentRepositoryImpl(this.db);

  Apartment _toApartmentDomain(ApartmentEntry entry) {
    return Apartment(
      id: entry.id,
      propertyId: entry.propertyId,
      apartmentNumber: entry.apartmentNumber,
      floorNumber: entry.floorNumber,
      area: entry.area,
      monthlyRent: entry.monthlyRent,
      status: entry.status,
      description: entry.description,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  ApartmentSpecification _toSpecDomain(ApartmentSpecificationEntry entry) {
    return ApartmentSpecification(
      id: entry.id,
      apartmentId: entry.apartmentId,
      bedrooms: entry.bedrooms,
      bathrooms: entry.bathrooms,
      livingRooms: entry.livingRooms,
      kitchens: entry.kitchens,
      balconies: entry.balconies,
      hasAc: entry.hasAc,
      hasParking: entry.hasParking,
      additionalFeatures: entry.additionalFeatures,
    );
  }

  @override
  Future<List<Apartment>> getAllApartments() async {
    final entries = await (db.select(
      db.apartments,
    )..orderBy([(t) => OrderingTerm.asc(t.apartmentNumber)])).get();
    return entries.map(_toApartmentDomain).toList();
  }

  @override
  Future<List<Apartment>> getApartmentsByPropertyId(int propertyId) async {
    final query = db.select(db.apartments)
      ..where((t) => t.propertyId.equals(propertyId))
      ..orderBy([(t) => OrderingTerm.asc(t.apartmentNumber)]);
    final entries = await query.get();
    return entries.map(_toApartmentDomain).toList();
  }

  @override
  Future<Apartment?> getApartmentById(int id) async {
    final entry = await (db.select(
      db.apartments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return entry != null ? _toApartmentDomain(entry) : null;
  }

  @override
  Future<ApartmentSpecification?> getSpecificationForApartment(
    int apartmentId,
  ) async {
    final entry = await (db.select(
      db.apartmentSpecifications,
    )..where((t) => t.apartmentId.equals(apartmentId))).getSingleOrNull();
    return entry != null ? _toSpecDomain(entry) : null;
  }

  @override
  Future<int> createApartment({
    required Apartment apartment,
    required ApartmentSpecification specification,
  }) async {
    return await db.transaction(() async {
      // 1. Check uniqueness of apartment_number in same property
      final existing =
          await (db.select(db.apartments)..where(
                (t) =>
                    t.propertyId.equals(apartment.propertyId) &
                    t.apartmentNumber.equals(apartment.apartmentNumber),
              ))
              .getSingleOrNull();

      if (existing != null) {
        throw BusinessRuleException(
          'Apartment number "${apartment.apartmentNumber}" already exists in this property.',
        );
      }

      final now = DateTime.now();
      final apartmentId = await db
          .into(db.apartments)
          .insert(
            ApartmentsCompanion.insert(
              propertyId: apartment.propertyId,
              apartmentNumber: apartment.apartmentNumber,
              floorNumber: apartment.floorNumber,
              area: apartment.area,
              monthlyRent: apartment.monthlyRent,
              status: apartment.status,
              description: Value(apartment.description),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // 2. Insert specification
      await db
          .into(db.apartmentSpecifications)
          .insert(
            ApartmentSpecificationsCompanion.insert(
              apartmentId: apartmentId,
              bedrooms: Value(specification.bedrooms),
              bathrooms: Value(specification.bathrooms),
              livingRooms: Value(specification.livingRooms),
              kitchens: Value(specification.kitchens),
              balconies: Value(specification.balconies),
              hasAc: Value(specification.hasAc),
              hasParking: Value(specification.hasParking),
              additionalFeatures: Value(specification.additionalFeatures),
            ),
          );

      return apartmentId;
    });
  }

  @override
  Future<void> updateApartment(Apartment apartment) async {
    await (db.update(
      db.apartments,
    )..where((t) => t.id.equals(apartment.id))).write(
      ApartmentsCompanion(
        apartmentNumber: Value(apartment.apartmentNumber),
        floorNumber: Value(apartment.floorNumber),
        area: Value(apartment.area),
        monthlyRent: Value(apartment.monthlyRent),
        status: Value(apartment.status),
        description: Value(apartment.description),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> updateSpecification(ApartmentSpecification specification) async {
    await (db.update(
      db.apartmentSpecifications,
    )..where((t) => t.apartmentId.equals(specification.apartmentId))).write(
      ApartmentSpecificationsCompanion(
        bedrooms: Value(specification.bedrooms),
        bathrooms: Value(specification.bathrooms),
        livingRooms: Value(specification.livingRooms),
        kitchens: Value(specification.kitchens),
        balconies: Value(specification.balconies),
        hasAc: Value(specification.hasAc),
        hasParking: Value(specification.hasParking),
        additionalFeatures: Value(specification.additionalFeatures),
      ),
    );
  }

  @override
  Future<void> updateApartmentAndSpecification({
    required Apartment apartment,
    required ApartmentSpecification specification,
  }) async {
    await db.transaction(() async {
      final current = await (db.select(
        db.apartments,
      )..where((t) => t.id.equals(apartment.id))).getSingleOrNull();

      if (current == null) {
        throw const BusinessRuleException('الشقة المحددة غير موجودة.');
      }

      // Check uniqueness if apartment number or property changed
      if (current.apartmentNumber != apartment.apartmentNumber ||
          current.propertyId != apartment.propertyId) {
        final existing =
            await (db.select(db.apartments)..where(
                  (t) =>
                      t.propertyId.equals(apartment.propertyId) &
                      t.apartmentNumber.equals(apartment.apartmentNumber) &
                      t.id.isNotValue(apartment.id),
                ))
                .getSingleOrNull();

        if (existing != null) {
          throw BusinessRuleException(
            'رقم الشقة "${apartment.apartmentNumber}" مسجل مسبقاً في هذا العقار.',
          );
        }
      }

      final now = DateTime.now();
      await (db.update(
        db.apartments,
      )..where((t) => t.id.equals(apartment.id))).write(
        ApartmentsCompanion(
          propertyId: Value(apartment.propertyId),
          apartmentNumber: Value(apartment.apartmentNumber),
          floorNumber: Value(apartment.floorNumber),
          area: Value(apartment.area),
          monthlyRent: Value(apartment.monthlyRent),
          status: Value(apartment.status),
          description: Value(apartment.description),
          updatedAt: Value(now),
        ),
      );

      final existingSpec = await (db.select(
        db.apartmentSpecifications,
      )..where((t) => t.apartmentId.equals(apartment.id))).getSingleOrNull();

      if (existingSpec == null) {
        await db
            .into(db.apartmentSpecifications)
            .insert(
              ApartmentSpecificationsCompanion.insert(
                apartmentId: apartment.id,
                bedrooms: Value(specification.bedrooms),
                bathrooms: Value(specification.bathrooms),
                livingRooms: Value(specification.livingRooms),
                kitchens: Value(specification.kitchens),
                balconies: Value(specification.balconies),
                hasAc: Value(specification.hasAc),
                hasParking: Value(specification.hasParking),
                additionalFeatures: Value(specification.additionalFeatures),
              ),
            );
      } else {
        await (db.update(
          db.apartmentSpecifications,
        )..where((t) => t.apartmentId.equals(apartment.id))).write(
          ApartmentSpecificationsCompanion(
            bedrooms: Value(specification.bedrooms),
            bathrooms: Value(specification.bathrooms),
            livingRooms: Value(specification.livingRooms),
            kitchens: Value(specification.kitchens),
            balconies: Value(specification.balconies),
            hasAc: Value(specification.hasAc),
            hasParking: Value(specification.hasParking),
            additionalFeatures: Value(specification.additionalFeatures),
          ),
        );
      }
    });
  }

  @override
  Future<void> updateApartmentStatus(
    int apartmentId,
    ApartmentStatus status,
  ) async {
    await (db.update(
      db.apartments,
    )..where((t) => t.id.equals(apartmentId))).write(
      ApartmentsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteApartment(int id) async {
    try {
      // Check if tenant history or payments exist
      final tenantCount = await (db.select(
        db.tenants,
      )..where((t) => t.apartmentId.equals(id))).get().then((l) => l.length);
      if (tenantCount > 0) {
        throw const BusinessRuleException(
          'Cannot delete apartment with existing tenant records.',
        );
      }

      final paymentsCount = await (db.select(
        db.payments,
      )..where((t) => t.apartmentId.equals(id))).get().then((l) => l.length);
      if (paymentsCount > 0) {
        throw const BusinessRuleException(
          'Cannot delete apartment with recorded financial payments.',
        );
      }

      await (db.delete(db.apartments)..where((t) => t.id.equals(id))).go();
    } catch (e) {
      if (e is BusinessRuleException) rethrow;
      throw DatabaseException('Failed to delete apartment: $e');
    }
  }
}
