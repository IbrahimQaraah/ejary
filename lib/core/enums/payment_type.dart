enum PaymentType {
  rent,
  service;

  String get displayName {
    switch (this) {
      case PaymentType.rent:
        return 'Rent';
      case PaymentType.service:
        return 'Service Bill';
    }
  }
}
