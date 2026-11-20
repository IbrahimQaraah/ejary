import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/enums/property_type.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../../../apartments/domain/usecases/apartments_usecases.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_stats.dart';
import '../../domain/usecases/properties_usecases.dart';

class PropertyController extends GetxController {
  final GetPropertiesUseCase getPropertiesUseCase;
  final GetPropertyByIdUseCase getPropertyByIdUseCase;
  final CreatePropertyUseCase createPropertyUseCase;
  final UpdatePropertyUseCase updatePropertyUseCase;
  final DeletePropertyUseCase deletePropertyUseCase;
  final GetApartmentsByPropertyUseCase getApartmentsUseCase;

  PropertyController({
    required this.getPropertiesUseCase,
    required this.getPropertyByIdUseCase,
    required this.createPropertyUseCase,
    required this.updatePropertyUseCase,
    required this.deletePropertyUseCase,
    required this.getApartmentsUseCase,
  });

  // State
  final RxList<Property> properties = <Property>[].obs;
  final RxMap<int, PropertyStats> propertyStats = <int, PropertyStats>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Search & Filtering
  final RxString searchQuery = ''.obs;
  final Rxn<PropertyType> selectedTypeFilter = Rxn<PropertyType>();
  final RxString selectedCityFilter = ''.obs;
  final RxString selectedDistrictFilter = ''.obs;

  // Property Details State
  final Rxn<Property> currentProperty = Rxn<Property>();
  final RxList<Apartment> currentPropertyApartments = <Apartment>[].obs;
  final Rxn<PropertyStats> currentPropertyStats = Rxn<PropertyStats>();
  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProperties();
  }

  // Filtered properties getter
  List<Property> get filteredProperties {
    return properties.where((p) {
      // 1. Search Query (Name, Address, District, City)
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.value.trim().toLowerCase();
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesCity = p.city.toLowerCase().contains(query);
        final matchesDistrict = p.district.toLowerCase().contains(query);
        final matchesAddress = p.address.toLowerCase().contains(query);
        if (!matchesName &&
            !matchesCity &&
            !matchesDistrict &&
            !matchesAddress) {
          return false;
        }
      }

      // 2. Property Type Filter
      if (selectedTypeFilter.value != null) {
        if (p.propertyType != selectedTypeFilter.value) {
          return false;
        }
      }

      // 3. City Filter
      if (selectedCityFilter.isNotEmpty) {
        if (p.city != selectedCityFilter.value) {
          return false;
        }
      }

      // 4. District Filter
      if (selectedDistrictFilter.isNotEmpty) {
        if (p.district != selectedDistrictFilter.value) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // List of distinct cities and districts for filters
  List<String> get availableCities {
    return properties.map((p) => p.city).toSet().toList()..sort();
  }

  List<String> get availableDistricts {
    if (selectedCityFilter.isNotEmpty) {
      return properties
          .where((p) => p.city == selectedCityFilter.value)
          .map((p) => p.district)
          .toSet()
          .toList()
        ..sort();
    }
    return properties.map((p) => p.district).toSet().toList()..sort();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setTypeFilter(PropertyType? type) {
    selectedTypeFilter.value = type;
  }

  void setCityFilter(String city) {
    selectedCityFilter.value = city;
    selectedDistrictFilter.value = ''; // Reset district when city changes
  }

  void setDistrictFilter(String district) {
    selectedDistrictFilter.value = district;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedTypeFilter.value = null;
    selectedCityFilter.value = '';
    selectedDistrictFilter.value = '';
  }

  // Load all properties and compute their apartment statistics
  Future<void> loadProperties() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await getPropertiesUseCase();
      properties.assignAll(list);

      // Fetch stats for each property
      for (final p in list) {
        await _calculateStatsForProperty(p.id);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _calculateStatsForProperty(int propertyId) async {
    try {
      final apts = await getApartmentsUseCase(propertyId);
      int occupied = 0;
      int available = 0;
      int maintenance = 0;
      int expectedIncome = 0;

      for (final apt in apts) {
        if (apt.status == ApartmentStatus.occupied) {
          occupied++;
          expectedIncome += apt.monthlyRent;
        } else if (apt.status == ApartmentStatus.available) {
          available++;
        } else if (apt.status == ApartmentStatus.maintenance) {
          maintenance++;
        }
      }

      final total = apts.length;
      final rate = total > 0 ? (occupied / total) * 100 : 0.0;

      propertyStats[propertyId] = PropertyStats(
        propertyId: propertyId,
        totalApartments: total,
        occupiedApartments: occupied,
        availableApartments: available,
        maintenanceApartments: maintenance,
        occupancyRate: rate,
        expectedMonthlyIncome: expectedIncome,
      );
    } catch (_) {
      propertyStats[propertyId] = PropertyStats.empty(propertyId);
    }
  }

  // Load specific property details
  Future<void> loadPropertyDetails(int id) async {
    try {
      isDetailsLoading.value = true;
      final prop = await getPropertyByIdUseCase(id);
      currentProperty.value = prop;

      if (prop != null) {
        final apts = await getApartmentsUseCase(id);
        currentPropertyApartments.assignAll(apts);
        await _calculateStatsForProperty(id);
        currentPropertyStats.value = propertyStats[id];
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // Create Property
  Future<bool> addProperty(Property property) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await createPropertyUseCase(property);
      await loadProperties();
      _refreshDashboard();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Edit Property
  Future<bool> editProperty(Property property) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await updatePropertyUseCase(property);
      await loadProperties();
      if (currentProperty.value?.id == property.id) {
        await loadPropertyDetails(property.id);
      }
      _refreshDashboard();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Property
  Future<bool> removeProperty(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await deletePropertyUseCase(id);
      await loadProperties();
      _refreshDashboard();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshDashboard() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
  }
}
