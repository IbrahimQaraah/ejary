import '../../../payments/domain/entities/payment.dart';

class DashboardMetrics {
  final int totalProperties;
  final int totalApartments;
  final int occupiedApartments;
  final int availableApartments;
  final int maintenanceApartments;
  final int expectedMonthlyIncome; // Minor units (cents)
  final int collectedPayments; // Minor units (cents)
  final int outstandingBalances; // Minor units (cents)
  final int utilityExpenses; // Minor units (cents)
  final int totalActiveTenants;
  final List<PaymentTransaction> recentTransactions;

  const DashboardMetrics({
    required this.totalProperties,
    required this.totalApartments,
    required this.occupiedApartments,
    required this.availableApartments,
    required this.maintenanceApartments,
    required this.expectedMonthlyIncome,
    required this.collectedPayments,
    required this.outstandingBalances,
    required this.utilityExpenses,
    required this.totalActiveTenants,
    required this.recentTransactions,
  });

  double get occupancyRate =>
      totalApartments == 0 ? 0.0 : (occupiedApartments / totalApartments) * 100;
}
