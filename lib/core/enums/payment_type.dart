enum PaymentType {
  rent,
  service;

  String get displayName {
    switch (this) {
      case PaymentType.rent:
        return 'إيجار';
      case PaymentType.service:
        return 'فاتورة خدمات ومرافق';
    }
  }
}
