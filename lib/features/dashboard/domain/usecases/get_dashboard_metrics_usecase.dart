import '../../../../core/enums/apartment_status.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../apartments/domain/repositories/apartment_repository.dart';
import '../../../payments/domain/repositories/payment_repository.dart';
import '../../../properties/domain/repositories/property_repository.dart';
import '../../../services/domain/repositories/service_repository.dart';
import '../../../tenants/domain/repositories/tenant_repository.dart';
import '../entities/dashboard_metrics.dart';

class GetDashboardMetricsUseCase {
  final PropertyRepository propertyRepository;
  final ApartmentRepository apartmentRepository;
  final TenantRepository tenantRepository;
  final ServiceRepository serviceRepository;
  final PaymentRepository paymentRepository;

  GetDashboardMetricsUseCase({
    required this.propertyRepository,
    required this.apartmentRepository,
    required this.tenantRepository,
    required this.serviceRepository,
    required this.paymentRepository,
  });

  Future<DashboardMetrics> call() async {
    final properties = await propertyRepository.getAllProperties();
    final apartments = await apartmentRepository.getAllApartments();
    final tenants = await tenantRepository.getAllTenants();
    final services = await serviceRepository.getAllServices();
    final payments = await paymentRepository.getAllPayments();

    final activeTenants = tenants.where((t) => t.isActive).toList();

    int occupied = 0;
    int available = 0;
    int maintenance = 0;
    int expectedRent = 0;

    for (final apt in apartments) {
      if (apt.status == ApartmentStatus.occupied) {
        occupied++;
      } else if (apt.status == ApartmentStatus.available) {
        available++;
      } else if (apt.status == ApartmentStatus.maintenance) {
        maintenance++;
      }
    }

    // Expected monthly income from active tenants (or occupied apartments)
    for (final t in activeTenants) {
      expectedRent += t.monthlyRent;
    }

    // Collected payments (net sum of all positive and reversal transactions)
    int collected = 0;
    for (final p in payments) {
      collected += p.amount;
    }

    // Total utility bill amounts
    int utilityTotal = 0;
    for (final s in services) {
      utilityTotal += s.totalAmount;
    }

    // Total collected for rent only
    int rentCollected = 0;
    for (final p in payments.where((p) => p.paymentType == PaymentType.rent)) {
      rentCollected += p.amount;
    }

    // Total collected for services
    int serviceCollected = 0;
    for (final p in payments.where(
      (p) => p.paymentType == PaymentType.service,
    )) {
      serviceCollected += p.amount;
    }

    // Outstanding = (expected rent from active tenancies - rent collected) + (utility bills - utility collected)
    final outstandingRent = expectedRent > rentCollected
        ? (expectedRent - rentCollected)
        : 0;
    final outstandingServices = utilityTotal > serviceCollected
        ? (utilityTotal - serviceCollected)
        : 0;
    final totalOutstanding = outstandingRent + outstandingServices;

    // Recent 10 transactions
    final recent = payments.take(10).toList();

    return DashboardMetrics(
      totalProperties: properties.length,
      totalApartments: apartments.length,
      occupiedApartments: occupied,
      availableApartments: available,
      maintenanceApartments: maintenance,
      expectedMonthlyIncome: expectedRent,
      collectedPayments: collected > 0 ? collected : 0,
      outstandingBalances: totalOutstanding,
      utilityExpenses: utilityTotal,
      totalActiveTenants: activeTenants.length,
      recentTransactions: recent,
    );
  }
}
