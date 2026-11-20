import 'package:drift/drift.dart';

import 'apartments_table.dart';

@DataClassName('ApartmentSpecificationEntry')
class ApartmentSpecifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get apartmentId => integer().unique().references(
    Apartments,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get bedrooms => integer().withDefault(const Constant(1))();
  IntColumn get bathrooms => integer().withDefault(const Constant(1))();
  IntColumn get livingRooms => integer().withDefault(const Constant(1))();
  IntColumn get kitchens => integer().withDefault(const Constant(1))();
  IntColumn get balconies => integer().withDefault(const Constant(0))();
  BoolColumn get hasAc => boolean().withDefault(const Constant(false))();
  BoolColumn get hasParking => boolean().withDefault(const Constant(false))();
  TextColumn get additionalFeatures => text().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK (bedrooms >= 0)',
    'CHECK (bathrooms >= 0)',
    'CHECK (living_rooms >= 0)',
    'CHECK (kitchens >= 0)',
    'CHECK (balconies >= 0)',
  ];
}
