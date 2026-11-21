import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/database/connection/connection.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/features/properties/data/repositories/property_repository_impl.dart';
import 'package:production_login/features/properties/domain/entities/property.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('drift_conn_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test(
    '1. resolveDatabaseDirectory returns a valid accessible directory',
    () async {
      final dir = await resolveDatabaseDirectory();
      expect(dir, isNotNull);
      expect(dir.existsSync(), isTrue);
    },
  );

  test('2. resolveDatabaseFile ensures parent directory exists for deep nested path', () async {
    final deepNestedPath =
        '${tempDir.path}/sub_dir/level2/level3/test_prop.sqlite';
    final resolvedFile = await resolveDatabaseFile(customPath: deepNestedPath);

    expect(resolvedFile.path, equals(deepNestedPath));
    expect(resolvedFile.parent.existsSync(), isTrue);
  });

  test('3. AppDatabase opens cleanly on disk without SQLite CANTOPEN (code 14) error', () async {
    final dbPath = '${tempDir.path}/data/app_storage/property_manager.sqlite';
    final connection = openConnection(dbPath: dbPath);
    final db = AppDatabase(connection);

    final repo = PropertyRepositoryImpl(db);
    final now = DateTime.now();
    final propId = await repo.createProperty(
      Property(
        id: 0,
        name: 'عمارة النرجس التجريبية',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'الياسمين',
        address: 'شارع أنس بن مالك',
        numberOfFloors: 4,
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(propId, isPositive);
    final fetched = await repo.getPropertyById(propId);
    expect(fetched, isNotNull);
    expect(fetched!.name, equals('عمارة النرجس التجريبية'));

    // Verify file exists on disk
    final dbFile = File(dbPath);
    expect(dbFile.existsSync(), isTrue);
    expect(dbFile.lengthSync(), isPositive);

    await db.close();
  });

  test('4. Data persistence across database close and reopen cycles', () async {
    final dbPath = '${tempDir.path}/persistence_test.sqlite';

    // 1st run: Create database and insert property
    {
      final conn1 = openConnection(dbPath: dbPath);
      final db1 = AppDatabase(conn1);
      final repo1 = PropertyRepositoryImpl(db1);

      final now = DateTime.now();
      await repo1.createProperty(
        Property(
          id: 0,
          name: 'برج الأندلس الدائم',
          propertyType: PropertyType.commercial,
          city: 'جدة',
          district: 'الروضة',
          address: 'شارع التحلية',
          numberOfFloors: 10,
          createdAt: now,
          updatedAt: now,
        ),
      );

      await db1.close();
    }

    // 2nd run: Reopen database from same file and verify data is 100% preserved
    {
      final conn2 = openConnection(dbPath: dbPath);
      final db2 = AppDatabase(conn2);
      final repo2 = PropertyRepositoryImpl(db2);

      final allProps = await repo2.getAllProperties();
      expect(allProps.length, equals(1));
      expect(allProps.first.name, equals('برج الأندلس الدائم'));
      expect(allProps.first.city, equals('جدة'));

      await db2.close();
    }
  });
}
