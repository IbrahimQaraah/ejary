class RentPeriodBalance {
  final int apartmentId;
  final int tenantId;
  final String billingPeriod;
  final int monthlyRent; // Obligation in minor units
  final int totalPaid; // Sum of recorded payments in minor units
  final int outstandingBalance; // monthlyRent - totalPaid

  const RentPeriodBalance({
    required this.apartmentId,
    required this.tenantId,
    required this.billingPeriod,
    required this.monthlyRent,
    required this.totalPaid,
    required this.outstandingBalance,
  });

  bool get isFullyPaid => outstandingBalance <= 0;
}

class ServiceBillBalance {
  final int serviceId;
  final int apartmentId;
  final int totalBillAmount; // Obligation in minor units
  final int totalPaid; // Sum of recorded payments in minor units
  final int outstandingBalance; // totalBillAmount - totalPaid

  const ServiceBillBalance({
    required this.serviceId,
    required this.apartmentId,
    required this.totalBillAmount,
    required this.totalPaid,
    required this.outstandingBalance,
  });

  bool get isFullyPaid => outstandingBalance <= 0;
}
