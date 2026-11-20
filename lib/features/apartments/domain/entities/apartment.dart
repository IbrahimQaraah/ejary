import '../../../../core/enums/apartment_status.dart';

class Apartment {
  final int id;
  final int propertyId;
  final String apartmentNumber;
  final int floorNumber;
  final double area;
  final int monthlyRent; // Minor units (e.g. cents)
  final ApartmentStatus status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Apartment({
    required this.id,
    required this.propertyId,
    required this.apartmentNumber,
    required this.floorNumber,
    required this.area,
    required this.monthlyRent,
    required this.status,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}
