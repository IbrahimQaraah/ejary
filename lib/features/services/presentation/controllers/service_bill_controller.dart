import 'package:get/get.dart';

import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../../../apartments/domain/usecases/apartments_usecases.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../payments/domain/entities/financial_summary.dart';
import '../../../payments/domain/entities/payment.dart';
import '../../../payments/domain/repositories/payment_repository.dart';
import '../../../payments/domain/usecases/payments_usecases.dart';
import '../../../properties/domain/entities/property.dart';
import '../../../properties/domain/usecases/properties_usecases.dart';
import '../../domain/entities/service.dart';
import '../../domain/usecases/services_usecases.dart';

class ServiceBillController extends GetxController {
  final GetAllServicesUseCase getAllServicesUseCase;
  final GetServiceByIdUseCase getServiceByIdUseCase;
  final GetServicesForApartmentUseCase getServicesUseCase;
  final CreateServiceBillUseCase createServiceBillUseCase;
  final CalculateServiceBalanceUseCase calculateServiceBalanceUseCase;
  final RecordPaymentUseCase recordPaymentUseCase;
  final PaymentRepository paymentRepository;
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetApartmentsUseCase getApartmentsUseCase;

  ServiceBillController({
    required this.getAllServicesUseCase,
    required this.getServiceByIdUseCase,
    required this.getServicesUseCase,
    required this.createServiceBillUseCase,
    required this.calculateServiceBalanceUseCase,
    required this.recordPaymentUseCase,
    required this.paymentRepository,
    required this.getPropertiesUseCase,
    required this.getApartmentsUseCase,
  });

  // State
  final RxList<ServiceBill> allServices = <ServiceBill>[].obs;
  final RxList<ServiceBill> services = <ServiceBill>[].obs;
  final RxMap<int, ServiceBillBalance> serviceBalances =
      <int, ServiceBillBalance>{}.obs;

  final RxMap<int, Property> propertiesMap = <int, Property>{}.obs;
  final RxMap<int, Apartment> apartmentsMap = <int, Apartment>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Search & Filtering
  final RxString searchQuery = ''.obs;
  final RxString typeFilter = 'all'.obs; // 'all' or ServiceType.name
  final RxString payerFilter = 'all'.obs; // 'all', 'tenant', 'owner'

  // Service Details State
  final Rxn<ServiceBill> currentService = Rxn<ServiceBill>();
  final Rxn<ServiceBillBalance> currentServiceBalance =
      Rxn<ServiceBillBalance>();
  final RxList<PaymentTransaction> currentServicePayments =
      <PaymentTransaction>[].obs;
  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllServices();
  }

  // Filtered Services Getter
  List<ServiceBill> get filteredServices {
    return allServices.where((s) {
      // 1. Service Type Filter
      if (typeFilter.value != 'all' && s.serviceType.name != typeFilter.value) {
        return false;
      }

      // 2. Payer Filter
      if (payerFilter.value == 'tenant' &&
          s.payerResponsibility != PayerResponsibility.tenant) {
        return false;
      }
      if (payerFilter.value == 'owner' &&
          s.payerResponsibility != PayerResponsibility.owner) {
        return false;
      }

      // 3. Search Query (Notes, Apartment Number, Property Name)
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.value.trim().toLowerCase();
        final matchesNotes = s.notes?.toLowerCase().contains(q) ?? false;
        final apt = apartmentsMap[s.apartmentId];
        final matchesApt =
            apt?.apartmentNumber.toLowerCase().contains(q) ?? false;
        final propName = apt != null
            ? (propertiesMap[apt.propertyId]?.name.toLowerCase() ?? '')
            : '';
        final matchesProp = propName.contains(q);

        if (!matchesNotes && !matchesApt && !matchesProp) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int get totalBillsAmount {
    return allServices.fold<int>(0, (sum, s) => sum + s.totalAmount);
  }

  void setSearchQuery(String q) => searchQuery.value = q;
  void setTypeFilter(String t) => typeFilter.value = t;
  void setPayerFilter(String p) => payerFilter.value = p;
  void clearFilters() {
    searchQuery.value = '';
    typeFilter.value = 'all';
    payerFilter.value = 'all';
  }

  // Load All Services
  Future<void> loadAllServices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

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

      final list = await getAllServicesUseCase();
      allServices.assignAll(list);

      // Compute balance for each bill
      for (final b in list) {
        final bal = await calculateServiceBalanceUseCase(
          serviceId: b.id,
          apartmentId: b.apartmentId,
          totalBillAmount: b.totalAmount,
        );
        serviceBalances[b.id] = bal;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Load Service Bill Details
  Future<void> loadServiceDetails(int serviceId) async {
    try {
      isDetailsLoading.value = true;
      final bill = await getServiceByIdUseCase(serviceId);
      currentService.value = bill;

      if (bill != null) {
        final bal = await calculateServiceBalanceUseCase(
          serviceId: bill.id,
          apartmentId: bill.apartmentId,
          totalBillAmount: bill.totalAmount,
        );
        currentServiceBalance.value = bal;

        final payments = await paymentRepository.getPaymentsForService(
          serviceId,
        );
        currentServicePayments.assignAll(payments);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // Load Services for specific Apartment
  Future<void> loadServices(int apartmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await getServicesUseCase(apartmentId);
      services.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add Service Bill
  Future<bool> addServiceBill(ServiceBill bill) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await createServiceBillUseCase(bill);
      await loadAllServices();
      await loadServices(bill.apartmentId);
      _refreshDependencies();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Pay Service Bill (partial or full)
  Future<bool> payServiceBill({
    required ServiceBill bill,
    required int amountInMinor,
    required PaymentMethod method,
    required PayerResponsibility paidBy,
    int? tenantId,
    String? referenceNumber,
    String? notes,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final payment = PaymentTransaction(
        id: 0,
        apartmentId: bill.apartmentId,
        tenantId: paidBy == PayerResponsibility.tenant ? tenantId : null,
        serviceId: bill.id,
        paymentType: PaymentType.service,
        amount: amountInMinor,
        dueDate: bill.dueDate,
        paymentDate: DateTime.now(),
        paidBy: paidBy,
        paymentMethod: method,
        referenceNumber: referenceNumber,
        notes: notes ?? 'سداد فاتورة ${bill.serviceType.displayName}',
        createdAt: DateTime.now(),
      );

      await recordPaymentUseCase(payment);
      await loadAllServices();
      if (currentService.value?.id == bill.id) {
        await loadServiceDetails(bill.id);
      }
      _refreshDependencies();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshDependencies() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
  }
}
