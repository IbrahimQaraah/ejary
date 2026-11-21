enum PaymentMethod {
  cash,
  bankTransfer,
  cheque,
  creditCard,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'نقداً';
      case PaymentMethod.bankTransfer:
        return 'تحويل بنكي';
      case PaymentMethod.cheque:
        return 'شيك مصرفي';
      case PaymentMethod.creditCard:
        return 'بطاقة بنكية / مدى';
      case PaymentMethod.other:
        return 'أخرى';
    }
  }
}
