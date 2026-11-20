import 'package:get/get.dart';

import '../../domain/entities/tenant.dart';
import '../../domain/usecases/tenants_usecases.dart';

class TenantController extends GetxController {
  final GetTenantsForApartmentUseCase getTenantsUseCase;
  final GetActiveTenantUseCase getActiveTenantUseCase;
  final RegisterTenantUseCase registerTenantUseCase;
  final VacateTenantUseCase vacateTenantUseCase;

  TenantController({
    required this.getTenantsUseCase,
    required this.getActiveTenantUseCase,
    required this.registerTenantUseCase,
    required this.vacateTenantUseCase,
  });

  final RxList<Tenant> tenantsHistory = <Tenant>[].obs;
  final Rxn<Tenant> activeTenant = Rxn<Tenant>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

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

  Future<bool> registerTenant(Tenant tenant) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await registerTenantUseCase(tenant);
      await loadTenants(tenant.apartmentId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> vacateCurrentTenant({
    required int tenantId,
    required int apartmentId,
    required DateTime moveOutDate,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await vacateTenantUseCase(tenantId: tenantId, moveOutDate: moveOutDate);
      await loadTenants(apartmentId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
