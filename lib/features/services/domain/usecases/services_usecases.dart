import '../entities/service.dart';
import '../repositories/service_repository.dart';

class GetServicesForApartmentUseCase {
  final ServiceRepository repository;
  GetServicesForApartmentUseCase(this.repository);

  Future<List<ServiceBill>> call(int apartmentId) =>
      repository.getServicesForApartment(apartmentId);
}

class CreateServiceBillUseCase {
  final ServiceRepository repository;
  CreateServiceBillUseCase(this.repository);

  Future<int> call(ServiceBill serviceBill) =>
      repository.createServiceBill(serviceBill);
}
