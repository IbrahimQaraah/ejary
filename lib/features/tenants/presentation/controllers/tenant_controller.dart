import 'package:get/get.dart';

import '../../../apartments/domain/entities/apartment.dart';
import '../../../apartments/domain/usecases/apartments_usecases.dart';
import '../../../apartments/presentation/controllers/apartment_controller.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../payments/domain/entities/payment.dart';
import '../../../payments/domain/usecases/payments_usecases.dart';
import '../../../properties/domain/entities/property.dart';
import '../../../properties/domain/usecases/properties_usecases.dart';
import '../../../properties/presentation/controllers/property_controller.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/usecases/tenants_usecases.dart';

class TenantController extends GetxController {
  final GetAllTenantsUseCase getAllTenantsUseCase;
  final GetTenantByIdUseCase getTenantByIdUseCase;
  final GetTenantsForApartmentUseCase getTenantsUseCase;
  final GetActiveTenantUseCase getActiveTenantUseCase;
  final RegisterTenantUseCase registerTenantUseCase;
  final VacateTenantUseCase vacateTenantUseCase;
  final UpdateTenantUseCase updateTenantUseCase;
  final GetApartmentsUseCase getApartmentsUseCase;
  final GetApartmentByIdUseCase getApartmentByIdUseCase;
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetPaymentsForApartmentUseCase getPaymentsForApartmentUseCase;

  TenantController({
    required this.getAllTenantsUseCase,
    required this.getTenantByIdUseCase,
    required this.getTenantsUseCase,
    required this.getActiveTenantUseCase,
    required this.registerTenantUseCase,
    required this.vacateTenantUseCase,
    required this.updateTenantUseCase,
    required this.getApartmentsUseCase,
    required this.getApartmentByIdUseCase,
    required this.getPropertiesUseCase,
    required this.getPaymentsForApartmentUseCase,
  });

  // State
  final RxList<Tenant> allTenants = <Tenant>[].obs;
  final RxList<Tenant> tenantsHistory = <Tenant>[].obs;
  final Rxn<Tenant> activeTenant = Rxn<Tenant>();
  final RxMap<int, Apartment> apartmentsMap = <int, Apartment>{}.obs;
  final RxMap<int, Property> propertiesMap = <int, Property>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Search & Filter
  final RxString searchQuery = ''.obs;
  final RxString statusFilter = 'all'.obs; // 'all', 'active', 'vacated'
  final Rxn<int> propertyFilter = Rxn<int>();

  // Tenant Details State
  final Rxn<Tenant> currentTenant = Rxn<Tenant>();
  final Rxn<Apartment> currentTenantApartment = Rxn<Apartment>();
  final Rxn<Property> currentTenantProperty = Rxn<Property>();
  final RxList<PaymentTransaction> currentTenantPayments =
      <PaymentTransaction>[].obs;
  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllTenants();
  }

  // Filtered tenants getter
  List<Tenant> get filteredTenants {
    return allTenants.where((t) {
      // 1. Status Filter
      if (statusFilter.value == 'active' && !t.isActive) return false;
      if (statusFilter.value == 'vacated' && t.isActive) return false;

      // 2. Property Filter
      if (propertyFilter.value != null) {
        final apt = apartmentsMap[t.apartmentId];
        if (apt == null || apt.propertyId != propertyFilter.value) {
          return false;
        }
      }

      // 3. Search Query (Name, Phone, National ID, Apartment Number)
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.value.trim().toLowerCase();
        final matchesName = t.fullName.toLowerCase().contains(q);
        final matchesPhone = t.phone.contains(q);
        final matchesNationalId = t.nationalId.contains(q);
        final apt = apartmentsMap[t.apartmentId];
        final matchesApt =
            apt != null &&
            (apt.apartmentNumber.toLowerCase().contains(q) ||
                (propertiesMap[apt.propertyId]?.name.toLowerCase().contains(
                      q,
                    ) ??
                    false));

        if (!matchesName &&
            !matchesPhone &&
            !matchesNationalId &&
            !matchesApt) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int get totalActiveTenants => allTenants.where((t) => t.isActive).length;
  int get totalVacatedTenants => allTenants.where((t) => !t.isActive).length;

  void setSearchQuery(String q) => searchQuery.value = q;
  void setStatusFilter(String s) => statusFilter.value = s;
  void setPropertyFilter(int? propId) => propertyFilter.value = propId;
  void clearFilters() {
    searchQuery.value = '';
    statusFilter.value = 'all';
    propertyFilter.value = null;
  }

  // Load all tenants across system
  Future<void> loadAllTenants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch reference data (Properties & Apartments)
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

      final list = await getAllTenantsUseCase();
      allTenants.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Load tenant details
  Future<void> loadTenantDetails(int tenantId) async {
    try {
      isDetailsLoading.value = true;
      errorMessage.value = '';

      final tenant = await getTenantByIdUseCase(tenantId);
      currentTenant.value = tenant;

      if (tenant != null) {
        // Fetch Apartment
        final apt = await getApartmentByIdUseCase(tenant.apartmentId);
        currentTenantApartment.value = apt;

        // Fetch Property
        if (apt != null) {
          if (propertiesMap.containsKey(apt.propertyId)) {
            currentTenantProperty.value = propertiesMap[apt.propertyId];
          } else {
            final props = await getPropertiesUseCase();
            currentTenantProperty.value = props.firstWhereOrNull(
              (p) => p.id == apt.propertyId,
            );
          }

          // Fetch Payments for this apartment
          final payments = await getPaymentsForApartmentUseCase(
            tenant.apartmentId,
          );
          // Filter payments made by this tenant or during this tenancy
          currentTenantPayments.assignAll(
            payments.where((p) => p.tenantId == tenant.id).toList(),
          );
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // Load tenants for specific apartment (history & active)
  Future<void> loadTenants(int apartmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final history = await getTenantsUseCase(apartmentId);
      tenantsHistory.assignAll(history);

      final active = await getActiveTenantUseCase(apartmentId);
      activeTenant.value = active;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Register New Tenant
  Future<bool> registerTenant(Tenant tenant) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await registerTenantUseCase(tenant);
      await loadAllTenants();
      await loadTenants(tenant.apartmentId);
      _refreshDependencies(tenant.apartmentId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update Tenant Details
  Future<bool> updateTenant(Tenant tenant) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await updateTenantUseCase(tenant);
      await loadAllTenants();
      if (currentTenant.value?.id == tenant.id) {
        await loadTenantDetails(tenant.id);
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Vacate Current Tenant (Sets move_out_date, frees apartment)
  Future<bool> vacateCurrentTenant({
    required int tenantId,
    required int apartmentId,
    required DateTime moveOutDate,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await vacateTenantUseCase(tenantId: tenantId, moveOutDate: moveOutDate);
      await loadAllTenants();
      await loadTenants(apartmentId);
      if (currentTenant.value?.id == tenantId) {
        await loadTenantDetails(tenantId);
      }
      _refreshDependencies(apartmentId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshDependencies(int apartmentId) {
    if (Get.isRegistered<ApartmentController>()) {
      Get.find<ApartmentController>().loadAllApartments();
      Get.find<ApartmentController>().loadApartmentDetails(apartmentId);
    }
    if (Get.isRegistered<PropertyController>()) {
      Get.find<PropertyController>().loadProperties();
    }
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
  }
}
