import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../properties/domain/entities/property.dart';
import '../../../properties/domain/usecases/properties_usecases.dart';
import '../../../properties/presentation/controllers/property_controller.dart';
import '../../../tenants/domain/entities/tenant.dart';
import '../../../tenants/domain/usecases/tenants_usecases.dart';
import '../../domain/entities/apartment.dart';
import '../../domain/entities/apartment_specification.dart';
import '../../domain/usecases/apartments_usecases.dart';

class ApartmentController extends GetxController {
  final GetApartmentsUseCase getAllApartmentsUseCase;
  final GetApartmentByIdUseCase getApartmentByIdUseCase;
  final GetApartmentsByPropertyUseCase getApartmentsByPropertyUseCase;
  final GetApartmentSpecificationUseCase getSpecificationUseCase;
  final CreateApartmentUseCase createApartmentUseCase;
  final UpdateApartmentUseCase updateApartmentUseCase;
  final UpdateApartmentStatusUseCase updateApartmentStatusUseCase;
  final DeleteApartmentUseCase deleteApartmentUseCase;
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetActiveTenantUseCase getActiveTenantUseCase;

  ApartmentController({
    required this.getAllApartmentsUseCase,
    required this.getApartmentByIdUseCase,
    required this.getApartmentsByPropertyUseCase,
    required this.getSpecificationUseCase,
    required this.createApartmentUseCase,
    required this.updateApartmentUseCase,
    required this.updateApartmentStatusUseCase,
    required this.deleteApartmentUseCase,
    required this.getPropertiesUseCase,
    required this.getActiveTenantUseCase,
  });

  // State
  final RxList<Apartment> apartments = <Apartment>[].obs;
  final RxMap<int, ApartmentSpecification> specifications =
      <int, ApartmentSpecification>{}.obs;
  final RxMap<int, Property> propertiesMap = <int, Property>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Search & Filtering
  final RxString searchQuery = ''.obs;
  final Rxn<int> selectedPropertyFilter = Rxn<int>();
  final Rxn<int> selectedFloorFilter = Rxn<int>();
  final Rxn<ApartmentStatus> selectedStatusFilter = Rxn<ApartmentStatus>();
  final Rxn<int> minRentFilter = Rxn<int>();
  final Rxn<int> maxRentFilter = Rxn<int>();

  // Apartment Details State
  final Rxn<Apartment> currentApartment = Rxn<Apartment>();
  final Rxn<ApartmentSpecification> currentApartmentSpec =
      Rxn<ApartmentSpecification>();
  final Rxn<Property> currentApartmentProperty = Rxn<Property>();
  final Rxn<Tenant> currentApartmentTenant = Rxn<Tenant>();
  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllApartments();
  }

  // Filtered apartments getter
  List<Apartment> get filteredApartments {
    return apartments.where((apt) {
      // 1. Search Query (Apartment Number or Property Name)
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.value.trim().toLowerCase();
        final matchesNum = apt.apartmentNumber.toLowerCase().contains(query);
        final propName =
            propertiesMap[apt.propertyId]?.name.toLowerCase() ?? '';
        final matchesProp = propName.contains(query);
        if (!matchesNum && !matchesProp) {
          return false;
        }
      }

      // 2. Property Filter
      if (selectedPropertyFilter.value != null) {
        if (apt.propertyId != selectedPropertyFilter.value) {
          return false;
        }
      }

      // 3. Floor Filter
      if (selectedFloorFilter.value != null) {
        if (apt.floorNumber != selectedFloorFilter.value) {
          return false;
        }
      }

      // 4. Status Filter
      if (selectedStatusFilter.value != null) {
        if (apt.status != selectedStatusFilter.value) {
          return false;
        }
      }

      // 5. Min Rent Filter
      if (minRentFilter.value != null) {
        if (apt.monthlyRent < minRentFilter.value!) {
          return false;
        }
      }

      // 6. Max Rent Filter
      if (maxRentFilter.value != null) {
        if (apt.monthlyRent > maxRentFilter.value!) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Distinct floors for filtering
  List<int> get availableFloors {
    return apartments.map((a) => a.floorNumber).toSet().toList()..sort();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setPropertyFilter(int? propertyId) {
    selectedPropertyFilter.value = propertyId;
  }

  void setFloorFilter(int? floor) {
    selectedFloorFilter.value = floor;
  }

  void setStatusFilter(ApartmentStatus? status) {
    selectedStatusFilter.value = status;
  }

  void setRentRange(int? min, int? max) {
    minRentFilter.value = min;
    maxRentFilter.value = max;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedPropertyFilter.value = null;
    selectedFloorFilter.value = null;
    selectedStatusFilter.value = null;
    minRentFilter.value = null;
    maxRentFilter.value = null;
  }

  // Load all apartments across all properties
  Future<void> loadAllApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Fetch properties for name mappings
      final props = await getPropertiesUseCase();
      propertiesMap.clear();
      for (final p in props) {
        propertiesMap[p.id] = p;
      }

      // 2. Fetch all apartments
      final list = await getAllApartmentsUseCase();
      apartments.assignAll(list);

      // 3. Fetch specifications for each apartment
      for (final apt in list) {
        final spec = await getSpecificationUseCase(apt.id);
        if (spec != null) {
          specifications[apt.id] = spec;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Load apartments for a specific property
  Future<void> loadApartmentsForProperty(int propertyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final list = await getApartmentsByPropertyUseCase(propertyId);
      apartments.assignAll(list);

      for (final apt in list) {
        final spec = await getSpecificationUseCase(apt.id);
        if (spec != null) {
          specifications[apt.id] = spec;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Alias for backward compatibility
  Future<void> loadApartments(int propertyId) =>
      loadApartmentsForProperty(propertyId);

  // Load specific apartment details
  Future<void> loadApartmentDetails(int apartmentId) async {
    try {
      isDetailsLoading.value = true;
      final apt = await getApartmentByIdUseCase(apartmentId);
      currentApartment.value = apt;

      if (apt != null) {
        // Spec
        final spec = await getSpecificationUseCase(apartmentId);
        currentApartmentSpec.value = spec;

        // Property
        if (propertiesMap.containsKey(apt.propertyId)) {
          currentApartmentProperty.value = propertiesMap[apt.propertyId];
        } else {
          final props = await getPropertiesUseCase();
          final prop = props.firstWhereOrNull((p) => p.id == apt.propertyId);
          currentApartmentProperty.value = prop;
        }

        // Active Tenant (if occupied)
        final tenant = await getActiveTenantUseCase(apartmentId);
        currentApartmentTenant.value = tenant;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // Add Apartment
  Future<bool> addApartment({
    required Apartment apartment,
    required ApartmentSpecification specification,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await createApartmentUseCase(
        apartment: apartment,
        specification: specification,
      );
      await loadAllApartments();
      _refreshDependencies(apartment.propertyId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Edit Apartment
  Future<bool> editApartment({
    required Apartment apartment,
    required ApartmentSpecification specification,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await updateApartmentUseCase(
        apartment: apartment,
        specification: specification,
      );
      await loadAllApartments();
      if (currentApartment.value?.id == apartment.id) {
        await loadApartmentDetails(apartment.id);
      }
      _refreshDependencies(apartment.propertyId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Remove Apartment
  Future<bool> removeApartment(int apartmentId, int propertyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await deleteApartmentUseCase(apartmentId);
      await loadAllApartments();
      _refreshDependencies(propertyId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshDependencies(int propertyId) {
    if (Get.isRegistered<PropertyController>()) {
      Get.find<PropertyController>().loadProperties();
      if (Get.find<PropertyController>().currentProperty.value?.id ==
          propertyId) {
        Get.find<PropertyController>().loadPropertyDetails(propertyId);
      }
    }
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
  }
}
