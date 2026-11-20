import 'package:get/get.dart';

import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/payments_usecases.dart';

class PaymentController extends GetxController {
  final GetPaymentsForApartmentUseCase getPaymentsUseCase;
  final RecordPaymentUseCase recordPaymentUseCase;
  final CalculateRentBalanceUseCase calculateRentBalanceUseCase;
  final CalculateServiceBalanceUseCase calculateServiceBalanceUseCase;

  PaymentController({
    required this.getPaymentsUseCase,
    required this.recordPaymentUseCase,
    required this.calculateRentBalanceUseCase,
    required this.calculateServiceBalanceUseCase,
  });

  final RxList<PaymentTransaction> transactions = <PaymentTransaction>[].obs;
  final Rxn<RentPeriodBalance> currentRentBalance = Rxn<RentPeriodBalance>();
  final Rxn<ServiceBillBalance> currentServiceBalance =
      Rxn<ServiceBillBalance>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadTransactions(int apartmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await getPaymentsUseCase(apartmentId);
      transactions.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRentBalance({
    required int apartmentId,
    required int tenantId,
    required String billingPeriod,
    required int monthlyRent,
  }) async {
    try {
      final balance = await calculateRentBalanceUseCase(
        apartmentId: apartmentId,
        tenantId: tenantId,
        billingPeriod: billingPeriod,
        monthlyRent: monthlyRent,
      );
      currentRentBalance.value = balance;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchServiceBalance({
    required int serviceId,
    required int apartmentId,
    required int totalBillAmount,
  }) async {
    try {
      final balance = await calculateServiceBalanceUseCase(
        serviceId: serviceId,
        apartmentId: apartmentId,
        totalBillAmount: totalBillAmount,
      );
      currentServiceBalance.value = balance;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<bool> makePayment(PaymentTransaction payment) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await recordPaymentUseCase(payment);
      await loadTransactions(payment.apartmentId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
