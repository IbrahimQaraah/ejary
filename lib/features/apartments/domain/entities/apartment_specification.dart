class ApartmentSpecification {
  final int id;
  final int apartmentId;
  final int bedrooms;
  final int bathrooms;
  final int livingRooms;
  final int kitchens;
  final int balconies;
  final bool hasAc;
  final bool hasParking;
  final String? additionalFeatures;

  const ApartmentSpecification({
    required this.id,
    required this.apartmentId,
    required this.bedrooms,
    required this.bathrooms,
    required this.livingRooms,
    required this.kitchens,
    required this.balconies,
    required this.hasAc,
    required this.hasParking,
    this.additionalFeatures,
  });
}
