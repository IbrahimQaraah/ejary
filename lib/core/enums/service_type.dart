enum ServiceType {
  water,
  electricity,
  gas,
  internet,
  other;

  String get displayName {
    switch (this) {
      case ServiceType.water:
        return 'مياه';
      case ServiceType.electricity:
        return 'كهرباء';
      case ServiceType.gas:
        return 'غاز';
      case ServiceType.internet:
        return 'إنترنت';
      case ServiceType.other:
        return 'صيانة وخدمات أخرى';
    }
  }
}
