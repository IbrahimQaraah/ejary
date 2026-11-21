import '../entities/tenant.dart';
import '../repositories/tenant_repository.dart';

class GetTenantsForApartmentUseCase {
  final TenantRepository repository;
  GetTenantsForApartmentUseCase(this.repository);

  Future<List<Tenant>> call(int apartmentId) =>
      repository.getTenantsForApartment(apartmentId);
}

class GetAllTenantsUseCase {
  final TenantRepository repository;
  GetAllTenantsUseCase(this.repository);

  Future<List<Tenant>> call() => repository.getAllTenants();
}

class GetTenantByIdUseCase {
  final TenantRepository repository;
  GetTenantByIdUseCase(this.repository);

  Future<Tenant?> call(int id) => repository.getTenantById(id);
}

class UpdateTenantUseCase {
  final TenantRepository repository;
  UpdateTenantUseCase(this.repository);

  Future<void> call(Tenant tenant) => repository.updateTenant(tenant);
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
