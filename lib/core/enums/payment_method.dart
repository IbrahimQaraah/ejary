enum PaymentMethod {
  cash,
  bankTransfer,
  cheque,
  creditCard,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.cheque:
        return 'Cheque';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}
