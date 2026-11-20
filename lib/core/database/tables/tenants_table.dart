import 'package:drift/drift.dart';

import 'apartments_table.dart';

@DataClassName('TenantEntry')
class Tenants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get apartmentId =>
      integer().references(Apartments, #id, onDelete: KeyAction.restrict)();
  TextColumn get fullName => text().withLength(min: 1, max: 200)();
  TextColumn get phone => text().withLength(min: 5, max: 30)();
  TextColumn get nationalId => text().withLength(min: 5, max: 50)();
  TextColumn get address => text()();
  IntColumn get monthlyRent => integer()(); // Minor currency units
  IntColumn get depositAmount => integer().withDefault(const Constant(0))();
  DateTimeColumn get contractStartDate => dateTime()();
  DateTimeColumn get contractEndDate => dateTime()();
  IntColumn get paymentDueDay => integer()();
  DateTimeColumn get moveInDate => dateTime()();
  DateTimeColumn get moveOutDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {
      id,
      apartmentId,
    }, // For cross-table composite foreign key validation from Payments
  ];

  @override
  List<String> get customConstraints => [
    'CHECK (monthly_rent >= 0)',
    'CHECK (deposit_amount >= 0)',
    'CHECK (payment_due_day BETWEEN 1 AND 31)',
  ];
}
