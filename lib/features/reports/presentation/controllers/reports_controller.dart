import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../apartments/domain/usecases/apartments_usecases.dart';
import '../../../payments/domain/usecases/payments_usecases.dart';
import '../../../properties/domain/entities/property.dart';
import '../../../properties/domain/usecases/properties_usecases.dart';
import '../../../services/domain/usecases/services_usecases.dart';
import '../../../tenants/domain/usecases/tenants_usecases.dart';

class PropertyReportItem {
  final Property property;
  final int totalApartments;
  final int occupiedApartments;
  final int availableApartments;
  final double occupancyRate;
  final int expectedMonthlyRent;
  final int actualCollectedRent;

  PropertyReportItem({
    required this.property,
    required this.totalApartments,
    required this.occupiedApartments,
    required this.availableApartments,
    required this.occupancyRate,
    required this.expectedMonthlyRent,
    required this.actualCollectedRent,
  });
}

class ReportsController extends GetxController {
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetApartmentsUseCase getApartmentsUseCase;
  final GetAllTenantsUseCase getAllTenantsUseCase;
  final GetAllPaymentsUseCase getAllPaymentsUseCase;
  final GetAllServicesUseCase getAllServicesUseCase;

  ReportsController({
    required this.getPropertiesUseCase,
    required this.getApartmentsUseCase,
    required this.getAllTenantsUseCase,
    required this.getAllPaymentsUseCase,
    required this.getAllServicesUseCase,
  });

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Aggregated Financial Metrics
  final RxInt totalRentCollected = 0.obs;
  final RxInt totalServicesCollected = 0.obs;
  final RxInt totalDepositsHeld = 0.obs;
  final RxInt totalExpectedMonthlyIncome = 0.obs;
  final RxDouble collectionRate = 0.0.obs;

  // Aggregated Occupancy Metrics
  final RxInt totalPropertiesCount = 0.obs;
  final RxInt totalApartmentsCount = 0.obs;
  final RxInt occupiedApartmentsCount = 0.obs;
  final RxInt availableApartmentsCount = 0.obs;
  final RxDouble overallOccupancyRate = 0.0.obs;

  // Expenses & Operational Breakdown
  final RxInt ownerExpenses = 0.obs;
  final RxInt tenantExpenses = 0.obs;

  // Per-Property Detailed Breakdown
  final RxList<PropertyReportItem> propertyReports = <PropertyReportItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReportsData();
  }

  Future<void> loadReportsData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final properties = await getPropertiesUseCase();
      final apartments = await getApartmentsUseCase();
      final tenants = await getAllTenantsUseCase();
      final payments = await getAllPaymentsUseCase();
      final services = await getAllServicesUseCase();

      totalPropertiesCount.value = properties.length;
      totalApartmentsCount.value = apartments.length;

      // Occupancy
      final occupied = apartments
          .where((a) => a.status == ApartmentStatus.occupied)
          .length;
      final available = apartments
          .where((a) => a.status == ApartmentStatus.available)
          .length;
      occupiedApartmentsCount.value = occupied;
      availableApartmentsCount.value = available;
      overallOccupancyRate.value = apartments.isNotEmpty
          ? (occupied / apartments.length) * 100
          : 0.0;

      // Expected Monthly Income from Occupied Apartments
      final expectedIncome = apartments
          .where((a) => a.status == ApartmentStatus.occupied)
          .fold<int>(0, (sum, a) => sum + a.monthlyRent);
      totalExpectedMonthlyIncome.value = expectedIncome;

      // Actual Collections by type
      int rentCollected = 0;
      int serviceCollected = 0;
      final int depositsHeld = tenants
          .where((t) => t.isActive)
          .fold<int>(0, (sum, t) => sum + t.depositAmount);

      for (final p in payments) {
        if (p.paymentType == PaymentType.rent) {
          rentCollected += p.amount;
        } else if (p.paymentType == PaymentType.service) {
          serviceCollected += p.amount;
        }
      }

      totalRentCollected.value = rentCollected;
      totalServicesCollected.value = serviceCollected;
      totalDepositsHeld.value = depositsHeld;

      collectionRate.value = expectedIncome > 0
          ? ((rentCollected / expectedIncome) * 100).clamp(0.0, 100.0)
          : 0.0;

      // Operational Expenses (Services breakdown: Owner vs Tenant)
      int ownerBills = 0;
      int tenantBills = 0;
      for (final s in services) {
        if (s.payerResponsibility == PayerResponsibility.owner) {
          ownerBills += s.totalAmount;
        } else {
          tenantBills += s.totalAmount;
        }
      }
      ownerExpenses.value = ownerBills;
      tenantExpenses.value = tenantBills;

      // Property Reports
      final reports = <PropertyReportItem>[];
      for (final prop in properties) {
        final propApts = apartments
            .where((a) => a.propertyId == prop.id)
            .toList();
        final propOccupied = propApts
            .where((a) => a.status == ApartmentStatus.occupied)
            .length;
        final propAvailable = propApts
            .where((a) => a.status == ApartmentStatus.available)
            .length;
        final propRate = propApts.isNotEmpty
            ? (propOccupied / propApts.length) * 100
            : 0.0;
        final propExpected = propApts
            .where((a) => a.status == ApartmentStatus.occupied)
            .fold<int>(0, (sum, a) => sum + a.monthlyRent);

        final aptIds = propApts.map((a) => a.id).toSet();
        final propCollected = payments
            .where(
              (p) =>
                  aptIds.contains(p.apartmentId) &&
                  p.paymentType == PaymentType.rent,
            )
            .fold<int>(0, (sum, p) => sum + p.amount);

        reports.add(
          PropertyReportItem(
            property: prop,
            totalApartments: propApts.length,
            occupiedApartments: propOccupied,
            availableApartments: propAvailable,
            occupancyRate: propRate,
            expectedMonthlyRent: propExpected,
            actualCollectedRent: propCollected,
          ),
        );
      }

      propertyReports.assignAll(reports);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
