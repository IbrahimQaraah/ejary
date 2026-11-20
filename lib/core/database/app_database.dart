import 'package:drift/drift.dart';

import '../enums/apartment_status.dart';
import '../enums/payer_responsibility.dart';
import '../enums/payment_method.dart';
import '../enums/payment_type.dart';
import '../enums/property_type.dart';
import '../enums/service_type.dart';
import 'connection/connection.dart';
import 'tables/apartment_specifications_table.dart';
import 'tables/apartments_table.dart';
import 'tables/payments_table.dart';
import 'tables/properties_table.dart';
import 'tables/services_table.dart';
import 'tables/tenants_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Properties,
    Apartments,
    Tenants,
    ApartmentSpecifications,
    Services,
    Payments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Strictly enforce SQLite foreign keys
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onCreate: (Migrator m) async {
      await m.createAll();

      // Partial Unique Index: Guarantees at most ONE active tenant per apartment
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_tenants_active_occupancy '
        'ON tenants (apartment_id) '
        'WHERE move_out_date IS NULL;',
      );

      // Performance indexes for foreign key navigation & search
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_apartments_property_id '
        'ON apartments(property_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tenants_apartment_id '
        'ON tenants(apartment_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_services_apartment_id '
        'ON services(apartment_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_payments_apartment '
        'ON payments(apartment_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_payments_tenant '
        'ON payments(tenant_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_payments_service '
        'ON payments(service_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_payments_period '
        'ON payments(billing_period);',
      );
    },
  );
}
