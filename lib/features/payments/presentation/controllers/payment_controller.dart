import 'package:get/get.dart';

import '../../../../core/enums/payment_type.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../../../apartments/domain/usecases/apartments_usecases.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../properties/domain/entities/property.dart';
import '../../../properties/domain/usecases/properties_usecases.dart';
import '../../../tenants/domain/entities/tenant.dart';
import '../../../tenants/domain/usecases/tenants_usecases.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/payments_usecases.dart';

class PaymentController extends GetxController {
  final GetAllPaymentsUseCase getAllPaymentsUseCase;
  final GetPaymentByIdUseCase getPaymentByIdUseCase;
  final GetPaymentsForApartmentUseCase getPaymentsUseCase;
  final RecordPaymentUseCase recordPaymentUseCase;
  final CalculateRentBalanceUseCase calculateRentBalanceUseCase;
  final CalculateServiceBalanceUseCase calculateServiceBalanceUseCase;
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetApartmentsUseCase getApartmentsUseCase;
  final GetAllTenantsUseCase getAllTenantsUseCase;

  PaymentController({
    required this.getAllPaymentsUseCase,
    required this.getPaymentByIdUseCase,
    required this.getPaymentsUseCase,
    required this.recordPaymentUseCase,
    required this.calculateRentBalanceUseCase,
    required this.calculateServiceBalanceUseCase,
    required this.getPropertiesUseCase,
    required this.getApartmentsUseCase,
    required this.getAllTenantsUseCase,
  });

  // State
  final RxList<PaymentTransaction> allPayments = <PaymentTransaction>[].obs;
  final RxList<PaymentTransaction> transactions = <PaymentTransaction>[].obs;
  final Rxn<RentPeriodBalance> currentRentBalance = Rxn<RentPeriodBalance>();
  final Rxn<ServiceBillBalance> currentServiceBalance =
      Rxn<ServiceBillBalance>();

  final RxMap<int, Property> propertiesMap = <int, Property>{}.obs;
  final RxMap<int, Apartment> apartmentsMap = <int, Apartment>{}.obs;
  final RxMap<int, Tenant> tenantsMap = <int, Tenant>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Search & Filtering
  final RxString searchQuery = ''.obs;
  final RxString typeFilter = 'all'.obs; // 'all', 'rent', 'service', 'deposit'
  final Rxn<int> propertyFilter = Rxn<int>();

  // Payment Details / Receipt
  final Rxn<PaymentTransaction> currentPayment = Rxn<PaymentTransaction>();
  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllPayments();
  }

  // Filtered Payments Getter
  List<PaymentTransaction> get filteredPayments {
    return allPayments.where((p) {
      // 1. Payment Type Filter
      if (typeFilter.value == 'rent' && p.paymentType != PaymentType.rent) {
        return false;
      }
      if (typeFilter.value == 'service' &&
          p.paymentType != PaymentType.service) {
        return false;
      }

      // 2. Property Filter
      if (propertyFilter.value != null) {
        final apt = apartmentsMap[p.apartmentId];
        if (apt == null || apt.propertyId != propertyFilter.value) {
          return false;
        }
      }

      // 3. Search Query (Reference, Notes, Tenant Name, Apartment Number)
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.value.trim().toLowerCase();
        final matchesRef =
            p.referenceNumber?.toLowerCase().contains(q) ?? false;
        final matchesNotes = p.notes?.toLowerCase().contains(q) ?? false;
        final tenant = p.tenantId != null ? tenantsMap[p.tenantId!] : null;
        final matchesTenant =
            tenant?.fullName.toLowerCase().contains(q) ?? false;
        final apt = apartmentsMap[p.apartmentId];
        final matchesApt =
            apt?.apartmentNumber.toLowerCase().contains(q) ?? false;

        if (!matchesRef && !matchesNotes && !matchesTenant && !matchesApt) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int get totalCollectedAmount {
    return allPayments.fold<int>(
      0,
      (sum, p) => p.amount > 0 ? sum + p.amount : sum,
    );
  }

  void setSearchQuery(String q) => searchQuery.value = q;
  void setTypeFilter(String t) => typeFilter.value = t;
  void setPropertyFilter(int? propId) => propertyFilter.value = propId;
  void clearFilters() {
    searchQuery.value = '';
    typeFilter.value = 'all';
    propertyFilter.value = null;
  }

  // Load All Payments
  Future<void> loadAllPayments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load reference data
      final props = await getPropertiesUseCase();
      propertiesMap.clear();
      for (final p in props) {
        propertiesMap[p.id] = p;
      }

      final apts = await getApartmentsUseCase();
      apartmentsMap.clear();
      for (final a in apts) {
        apartmentsMap[a.id] = a;
      }

      final tenants = await getAllTenantsUseCase();
      tenantsMap.clear();
      for (final t in tenants) {
        tenantsMap[t.id] = t;
      }

      final payments = await getAllPaymentsUseCase();
      allPayments.assignAll(payments);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Load Single Payment Details
  Future<void> loadPaymentDetails(int paymentId) async {
    try {
      isDetailsLoading.value = true;
      final payment = await getPaymentByIdUseCase(paymentId);
      currentPayment.value = payment;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // Load Transactions for specific apartment
  Future<void> loadTransactions(int apartmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await getPaymentsUseCase(apartmentId);
      transactions.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Record a Payment
  Future<bool> makePayment(PaymentTransaction payment) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await recordPaymentUseCase(payment);
      await loadAllPayments();
      await loadTransactions(payment.apartmentId);
      _refreshDependencies();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reverse / Adjust a Payment in the Ledger (Negative adjustment entry)
  Future<bool> reversePayment({
    required PaymentTransaction originalPayment,
    required String reason,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reversal = PaymentTransaction(
        id: 0,
        apartmentId: originalPayment.apartmentId,
        tenantId: originalPayment.tenantId,
        serviceId: originalPayment.serviceId,
        paymentType: originalPayment.paymentType,
        amount: -originalPayment.amount
            .abs(), // Negative amount for auditable reversal
        dueDate: originalPayment.dueDate,
        paymentDate: DateTime.now(),
        paidBy: originalPayment.paidBy,
        paymentMethod: originalPayment.paymentMethod,
        billingPeriod: originalPayment.billingPeriod,
        referenceNumber: 'REV-#${originalPayment.id}',
        notes: 'قيد عكسي وتسوية لسند #${originalPayment.id}. السبب: $reason',
        createdAt: DateTime.now(),
      );

      await recordPaymentUseCase(reversal);
      await loadAllPayments();
      await loadTransactions(originalPayment.apartmentId);
      _refreshDependencies();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRentBalance({
    required int apartmentId,
    required int tenantId,
    required String billingPeriod,
    required int monthlyRent,
  }) async {
    try {
      final balance = await calculateRentBalanceUseCase(
        apartmentId: apartmentId,
        tenantId: tenantId,
        billingPeriod: billingPeriod,
        monthlyRent: monthlyRent,
      );
      currentRentBalance.value = balance;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchServiceBalance({
    required int serviceId,
    required int apartmentId,
    required int totalBillAmount,
  }) async {
    try {
      final balance = await calculateServiceBalanceUseCase(
        serviceId: serviceId,
        apartmentId: apartmentId,
        totalBillAmount: totalBillAmount,
      );
      currentServiceBalance.value = balance;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  void _refreshDependencies() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
  }
}
