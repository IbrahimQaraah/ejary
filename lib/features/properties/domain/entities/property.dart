import '../../../../core/enums/property_type.dart';

class Property {
  final int id;
  final String name;
  final PropertyType propertyType;
  final String city;
  final String district;
  final String address;
  final String? description;
  final String? imagePath;
  final int numberOfFloors;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Property({
    required this.id,
    required this.name,
    required this.propertyType,
    required this.city,
    required this.district,
    required this.address,
    this.description,
    this.imagePath,
    required this.numberOfFloors,
    required this.createdAt,
    required this.updatedAt,
  });
}
