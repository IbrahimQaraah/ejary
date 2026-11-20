import '../entities/tenant.dart';
import '../repositories/tenant_repository.dart';

class GetTenantsForApartmentUseCase {
  final TenantRepository repository;
  GetTenantsForApartmentUseCase(this.repository);

  Future<List<Tenant>> call(int apartmentId) =>
      repository.getTenantsForApartment(apartmentId);
}

class GetActiveTenantUseCase {
  final TenantRepository repository;
  GetActiveTenantUseCase(this.repository);

  Future<Tenant?> call(int apartmentId) =>
      repository.getActiveTenant(apartmentId);
}

class RegisterTenantUseCase {
  final TenantRepository repository;
  RegisterTenantUseCase(this.repository);

  Future<int> call(Tenant tenant) => repository.registerNewTenant(tenant);
}

class VacateTenantUseCase {
  final TenantRepository repository;
  VacateTenantUseCase(this.repository);

  Future<void> call({required int tenantId, required DateTime moveOutDate}) =>
      repository.vacateTenant(tenantId: tenantId, moveOutDate: moveOutDate);
}
