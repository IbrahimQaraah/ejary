import 'package:drift/drift.dart';

import '../../enums/apartment_status.dart';
import 'properties_table.dart';

@DataClassName('ApartmentEntry')
class Apartments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get propertyId =>
      integer().references(Properties, #id, onDelete: KeyAction.restrict)();
  TextColumn get apartmentNumber => text().withLength(min: 1, max: 50)();
  IntColumn get floorNumber => integer()();
  RealColumn get area => real()();
  IntColumn get monthlyRent => integer()(); // Minor units (e.g. cents)
  TextColumn get status => textEnum<ApartmentStatus>()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {propertyId, apartmentNumber},
  ];

  @override
  List<String> get customConstraints => [
    'CHECK (area > 0.0)',
    'CHECK (monthly_rent >= 0)',
  ];
}
