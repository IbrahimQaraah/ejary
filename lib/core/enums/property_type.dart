enum PropertyType {
  residential,
  commercial,
  mixed,
  villa,
  building;

  String get displayName {
    switch (this) {
      case PropertyType.residential:
        return 'Residential';
      case PropertyType.commercial:
        return 'Commercial';
      case PropertyType.mixed:
        return 'Mixed-Use';
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.building:
        return 'Building';
    }
  }
}
