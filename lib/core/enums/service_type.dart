enum ServiceType {
  water,
  electricity,
  gas,
  internet,
  other;

  String get displayName {
    switch (this) {
      case ServiceType.water:
        return 'Water';
      case ServiceType.electricity:
        return 'Electricity';
      case ServiceType.gas:
        return 'Gas';
      case ServiceType.internet:
        return 'Internet';
      case ServiceType.other:
        return 'Other';
    }
  }
}
