enum ApartmentStatus {
  available,
  occupied,
  maintenance;

  String get displayName {
    switch (this) {
      case ApartmentStatus.available:
        return 'Available';
      case ApartmentStatus.occupied:
        return 'Occupied';
      case ApartmentStatus.maintenance:
        return 'Under Maintenance';
    }
  }
}
