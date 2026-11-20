import 'package:get/get.dart';

import '../../domain/entities/service.dart';
import '../../domain/usecases/services_usecases.dart';

class ServiceBillController extends GetxController {
  final GetServicesForApartmentUseCase getServicesUseCase;
  final CreateServiceBillUseCase createServiceBillUseCase;

  ServiceBillController({
    required this.getServicesUseCase,
    required this.createServiceBillUseCase,
  });

  final RxList<ServiceBill> services = <ServiceBill>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadServices(int apartmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await getServicesUseCase(apartmentId);
      services.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addServiceBill(ServiceBill bill) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await createServiceBillUseCase(bill);
      await loadServices(bill.apartmentId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
