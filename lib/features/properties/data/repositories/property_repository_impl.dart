import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final AppDatabase db;

  PropertyRepositoryImpl(this.db);

  Property _toDomain(PropertyEntry entry) {
    return Property(
      id: entry.id,
      name: entry.name,
      propertyType: entry.propertyType,
      city: entry.city,
      district: entry.district,
      address: entry.address,
      description: entry.description,
      imagePath: entry.imagePath,
      numberOfFloors: entry.numberOfFloors,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  @override
  Future<List<Property>> getAllProperties() async {
    final query = db.select(db.properties)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<Property?> getPropertyById(int id) async {
    final entry = await (db.select(
      db.properties,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  @override
  Future<int> createProperty(Property property) async {
    final now = DateTime.now();
    return await db
        .into(db.properties)
        .insert(
          PropertiesCompanion.insert(
            name: property.name,
            propertyType: property.propertyType,
            city: property.city,
            district: property.district,
            address: property.address,
            description: Value(property.description),
            imagePath: Value(property.imagePath),
            numberOfFloors: property.numberOfFloors,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> updateProperty(Property property) async {
    await (db.update(
      db.properties,
    )..where((t) => t.id.equals(property.id))).write(
      PropertiesCompanion(
        name: Value(property.name),
        propertyType: Value(property.propertyType),
        city: Value(property.city),
        district: Value(property.district),
        address: Value(property.address),
        description: Value(property.description),
        imagePath: Value(property.imagePath),
        numberOfFloors: Value(property.numberOfFloors),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteProperty(int id) async {
    try {
      // Check if apartments exist for this property
      final count = await (db.select(
        db.apartments,
      )..where((t) => t.propertyId.equals(id))).get().then((l) => l.length);

      if (count > 0) {
        throw const BusinessRuleException(
          'Cannot delete property that contains existing apartments. Please delete or reassign apartments first.',
        );
      }

      await (db.delete(db.properties)..where((t) => t.id.equals(id))).go();
    } catch (e) {
      if (e is BusinessRuleException) rethrow;
      throw DatabaseException('Failed to delete property: $e');
    }
  }
}
