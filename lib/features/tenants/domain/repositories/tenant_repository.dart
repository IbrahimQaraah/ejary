import '../entities/tenant.dart';

abstract class TenantRepository {
  Future<List<Tenant>> getAllTenants();
  Future<List<Tenant>> getTenantsForApartment(int apartmentId);
  Future<Tenant?> getActiveTenant(int apartmentId);
  Future<Tenant?> getTenantById(int id);
  Future<int> registerNewTenant(Tenant tenant);
  Future<void> vacateTenant({
    required int tenantId,
    required DateTime moveOutDate,
  });
  Future<void> updateTenant(Tenant tenant);
}
