import '../entities/service.dart';

abstract class ServiceRepository {
  Future<List<ServiceBill>> getAllServices();
  Future<List<ServiceBill>> getServicesForApartment(int apartmentId);
  Future<ServiceBill?> getServiceById(int id);
  Future<int> createServiceBill(ServiceBill serviceBill);
  Future<void> updateServiceBill(ServiceBill serviceBill);
}
