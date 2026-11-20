class Tenant {
  final int id;
  final int apartmentId;
  final String fullName;
  final String phone;
  final String nationalId;
  final String address;
  final int monthlyRent; // Minor units
  final int depositAmount; // Minor units
  final DateTime contractStartDate;
  final DateTime contractEndDate;
  final int paymentDueDay;
  final DateTime moveInDate;
  final DateTime? moveOutDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tenant({
    required this.id,
    required this.apartmentId,
    required this.fullName,
    required this.phone,
    required this.nationalId,
    required this.address,
    required this.monthlyRent,
    required this.depositAmount,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.paymentDueDay,
    required this.moveInDate,
    this.moveOutDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => moveOutDate == null;
}
