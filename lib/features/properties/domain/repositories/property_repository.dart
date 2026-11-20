import '../entities/property.dart';

abstract class PropertyRepository {
  Future<List<Property>> getAllProperties();
  Future<Property?> getPropertyById(int id);
  Future<int> createProperty(Property property);
  Future<void> updateProperty(Property property);
  Future<void> deleteProperty(int id);
}
