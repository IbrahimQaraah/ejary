import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/enums/payment_type.dart';

class PaymentTransaction {
  final int id;
  final int apartmentId;
  final int? tenantId;
  final int? serviceId;
  final PaymentType paymentType;
  final int amount; // Minor units (signed)
  final DateTime? dueDate;
  final DateTime paymentDate;
  final PayerResponsibility paidBy;
  final PaymentMethod paymentMethod;
  final String? billingPeriod;
  final String? referenceNumber;
  final String? notes;
  final DateTime createdAt;

  const PaymentTransaction({
    required this.id,
    required this.apartmentId,
    this.tenantId,
    this.serviceId,
    required this.paymentType,
    required this.amount,
    this.dueDate,
    required this.paymentDate,
    required this.paidBy,
    required this.paymentMethod,
    this.billingPeriod,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
  });

  bool get isReversal => amount < 0;
}
