import 'package:drift/drift.dart';

import '../../enums/property_type.dart';

@DataClassName('PropertyEntry')
class Properties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get propertyType => textEnum<PropertyType>()();
  TextColumn get city => text().withLength(min: 1, max: 100)();
  TextColumn get district => text().withLength(min: 1, max: 100)();
  TextColumn get address => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get numberOfFloors => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<String> get customConstraints => ['CHECK (number_of_floors >= 1)'];
}
