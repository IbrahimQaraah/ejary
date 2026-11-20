import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/service_type.dart';

class ServiceBill {
  final int id;
  final int apartmentId;
  final ServiceType serviceType;
  final double? previousReading;
  final double? currentReading;
  final double consumption;
  final int unitPrice; // Minor units
  final int totalAmount; // Minor units
  final DateTime billingDate;
  final DateTime dueDate;
  final PayerResponsibility payerResponsibility;
  final String? notes;
  final DateTime createdAt;

  const ServiceBill({
    required this.id,
    required this.apartmentId,
    required this.serviceType,
    this.previousReading,
    this.currentReading,
    required this.consumption,
    required this.unitPrice,
    required this.totalAmount,
    required this.billingDate,
    required this.dueDate,
    required this.payerResponsibility,
    this.notes,
    required this.createdAt,
  });
}
