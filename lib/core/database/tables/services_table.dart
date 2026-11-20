import 'package:drift/drift.dart';

import '../../enums/payer_responsibility.dart';
import '../../enums/service_type.dart';
import 'apartments_table.dart';

@DataClassName('ServiceEntry')
class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get apartmentId =>
      integer().references(Apartments, #id, onDelete: KeyAction.restrict)();
  TextColumn get serviceType => textEnum<ServiceType>()();
  RealColumn get previousReading => real().nullable()();
  RealColumn get currentReading => real().nullable()();
  RealColumn get consumption => real().withDefault(const Constant(0.0))();
  IntColumn get unitPrice =>
      integer().withDefault(const Constant(0))(); // Minor units
  IntColumn get totalAmount => integer()(); // Minor units
  DateTimeColumn get billingDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get payerResponsibility => textEnum<PayerResponsibility>()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {
      id,
      apartmentId,
    }, // For cross-table composite foreign key validation from Payments
  ];

  @override
  List<String> get customConstraints => ['CHECK (total_amount >= 0)'];
}
