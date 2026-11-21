import '../entities/financial_summary.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetAllPaymentsUseCase {
  final PaymentRepository repository;
  GetAllPaymentsUseCase(this.repository);

  Future<List<PaymentTransaction>> call({int? limit}) =>
      repository.getAllPayments(limit: limit);
}

class GetPaymentByIdUseCase {
  final PaymentRepository repository;
  GetPaymentByIdUseCase(this.repository);

  Future<PaymentTransaction?> call(int id) => repository.getPaymentById(id);
}

class GetPaymentsForApartmentUseCase {
  final PaymentRepository repository;
  GetPaymentsForApartmentUseCase(this.repository);

  Future<List<PaymentTransaction>> call(int apartmentId) =>
      repository.getPaymentsForApartment(apartmentId);
}

class RecordPaymentUseCase {
  final PaymentRepository repository;
  RecordPaymentUseCase(this.repository);

  Future<int> call(PaymentTransaction payment) =>
      repository.recordPayment(payment);
}

class CalculateRentBalanceUseCase {
  final PaymentRepository repository;
  CalculateRentBalanceUseCase(this.repository);

  Future<RentPeriodBalance> call({
    required int apartmentId,
    required int tenantId,
    required String billingPeriod,
    required int monthlyRent,
  }) => repository.calculateRentPeriodBalance(
    apartmentId: apartmentId,
    tenantId: tenantId,
    billingPeriod: billingPeriod,
    monthlyRent: monthlyRent,
  );
}

class CalculateServiceBalanceUseCase {
  final PaymentRepository repository;
  CalculateServiceBalanceUseCase(this.repository);

  Future<ServiceBillBalance> call({
    required int serviceId,
    required int apartmentId,
    required int totalBillAmount,
  }) => repository.calculateServiceBillBalance(
    serviceId: serviceId,
    apartmentId: apartmentId,
    totalBillAmount: totalBillAmount,
  );
}
