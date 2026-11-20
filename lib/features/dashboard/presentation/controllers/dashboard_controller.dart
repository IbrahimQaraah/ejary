import 'package:get/get.dart';

import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/usecases/get_dashboard_metrics_usecase.dart';

class DashboardController extends GetxController {
  final GetDashboardMetricsUseCase getDashboardMetricsUseCase;

  DashboardController({required this.getDashboardMetricsUseCase});

  final Rxn<DashboardMetrics> metrics = Rxn<DashboardMetrics>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await getDashboardMetricsUseCase();
      metrics.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
