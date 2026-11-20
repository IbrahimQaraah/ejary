import 'package:drift/drift.dart';

import '../../enums/payer_responsibility.dart';
import '../../enums/payment_method.dart';
import '../../enums/payment_type.dart';
import 'apartments_table.dart';
import 'services_table.dart';
import 'tenants_table.dart';

@DataClassName('PaymentEntry')
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get apartmentId =>
      integer().references(Apartments, #id, onDelete: KeyAction.restrict)();
  IntColumn get tenantId => integer().nullable().references(
    Tenants,
    #id,
    onDelete: KeyAction.restrict,
  )();
  IntColumn get serviceId => integer().nullable().references(
    Services,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get paymentType => textEnum<PaymentType>()();
  IntColumn get amount => integer()(); // Minor units (signed: positive for payments, negative for auditable ledger reversal adjustments)
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get paidBy => textEnum<PayerResponsibility>()();
  TextColumn get paymentMethod => textEnum<PaymentMethod>()();
  TextColumn get billingPeriod => text().nullable()(); // E.g. '2026-11'
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<String> get customConstraints => [
    'CONSTRAINT chk_rent_rule CHECK (payment_type != \'rent\' OR (tenant_id IS NOT NULL AND service_id IS NULL AND billing_period IS NOT NULL))',
    'CONSTRAINT chk_service_rule CHECK (payment_type != \'service\' OR (service_id IS NOT NULL AND (paid_by = \'tenant\' OR tenant_id IS NULL)))',
    'FOREIGN KEY (tenant_id, apartment_id) REFERENCES tenants (id, apartment_id) ON DELETE RESTRICT',
    'FOREIGN KEY (service_id, apartment_id) REFERENCES services (id, apartment_id) ON DELETE RESTRICT',
  ];
}
