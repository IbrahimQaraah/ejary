import '../entities/financial_summary.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<List<PaymentTransaction>> getAllPayments({int? limit});
  Future<List<PaymentTransaction>> getPaymentsForApartment(int apartmentId);
  Future<List<PaymentTransaction>> getPaymentsForTenant(int tenantId);
  Future<List<PaymentTransaction>> getPaymentsForService(int serviceId);
  Future<List<PaymentTransaction>> getPaymentsForRentPeriod({
    required int apartmentId,
    required String billingPeriod,
  });
  Future<int> recordPayment(PaymentTransaction payment);
  Future<RentPeriodBalance> calculateRentPeriodBalance({
    required int apartmentId,
    required int tenantId,
    required String billingPeriod,
    required int monthlyRent,
  });
  Future<ServiceBillBalance> calculateServiceBillBalance({
    required int serviceId,
    required int apartmentId,
    required int totalBillAmount,
  });
}
