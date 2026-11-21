import '../entities/service.dart';
import '../repositories/service_repository.dart';

class GetAllServicesUseCase {
  final ServiceRepository repository;
  GetAllServicesUseCase(this.repository);

  Future<List<ServiceBill>> call() => repository.getAllServices();
}

class GetServiceByIdUseCase {
  final ServiceRepository repository;
  GetServiceByIdUseCase(this.repository);

  Future<ServiceBill?> call(int id) => repository.getServiceById(id);
}

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
