import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/enums/apartment_status.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/tenant_repository.dart';

class TenantRepositoryImpl implements TenantRepository {
  final AppDatabase db;

  TenantRepositoryImpl(this.db);

  Tenant _toDomain(TenantEntry entry) {
    return Tenant(
      id: entry.id,
      apartmentId: entry.apartmentId,
      fullName: entry.fullName,
      phone: entry.phone,
      nationalId: entry.nationalId,
      address: entry.address,
      monthlyRent: entry.monthlyRent,
      depositAmount: entry.depositAmount,
      contractStartDate: entry.contractStartDate,
      contractEndDate: entry.contractEndDate,
      paymentDueDay: entry.paymentDueDay,
      moveInDate: entry.moveInDate,
      moveOutDate: entry.moveOutDate,
      notes: entry.notes,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  @override
  Future<List<Tenant>> getAllTenants() async {
    final query = db.select(db.tenants)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<List<Tenant>> getTenantsForApartment(int apartmentId) async {
    final query = db.select(db.tenants)
      ..where((t) => t.apartmentId.equals(apartmentId))
      ..orderBy([(t) => OrderingTerm.desc(t.contractStartDate)]);
    final entries = await query.get();
    return entries.map(_toDomain).toList();
  }

  @override
  Future<Tenant?> getActiveTenant(int apartmentId) async {
    final entry =
        await (db.select(db.tenants)..where(
              (t) => t.apartmentId.equals(apartmentId) & t.moveOutDate.isNull(),
            ))
            .getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  @override
  Future<Tenant?> getTenantById(int id) async {
    final entry = await (db.select(
      db.tenants,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  @override
  Future<int> registerNewTenant(Tenant tenant) async {
    return await db.transaction(() async {
      // 1. Verify no active tenant exists for this apartment
      final activeTenant =
          await (db.select(db.tenants)..where(
                (t) =>
                    t.apartmentId.equals(tenant.apartmentId) &
                    t.moveOutDate.isNull(),
              ))
              .getSingleOrNull();

      if (activeTenant != null) {
        throw BusinessRuleException(
          'Apartment #${tenant.apartmentId} already has an active tenant (${activeTenant.fullName}). '
          'Please record the departure (move-out date) of the current tenant before adding a new tenant.',
        );
      }

      final now = DateTime.now();

      // 2. Insert new tenant occupancy record
      final tenantId = await db
          .into(db.tenants)
          .insert(
            TenantsCompanion.insert(
              apartmentId: tenant.apartmentId,
              fullName: tenant.fullName,
              phone: tenant.phone,
              nationalId: tenant.nationalId,
              address: tenant.address,
              monthlyRent: tenant.monthlyRent,
              depositAmount: Value(tenant.depositAmount),
              contractStartDate: tenant.contractStartDate,
              contractEndDate: tenant.contractEndDate,
              paymentDueDay: tenant.paymentDueDay,
              moveInDate: tenant.moveInDate,
              moveOutDate:
                  const Value.absent(), // Active tenant has null move_out_date
              notes: Value(tenant.notes),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // 3. Keep apartment status consistent with occupancy records
      await (db.update(
        db.apartments,
      )..where((t) => t.id.equals(tenant.apartmentId))).write(
        ApartmentsCompanion(
          status: const Value(ApartmentStatus.occupied),
          updatedAt: Value(now),
        ),
      );

      return tenantId;
    });
  }

  @override
  Future<void> vacateTenant({
    required int tenantId,
    required DateTime moveOutDate,
  }) async {
    await db.transaction(() async {
      final tenantEntry = await (db.select(
        db.tenants,
      )..where((t) => t.id.equals(tenantId))).getSingleOrNull();

      if (tenantEntry == null) {
        throw const NotFoundException('Tenant not found.');
      }

      if (moveOutDate.isBefore(tenantEntry.moveInDate)) {
        throw const BusinessRuleException(
          'Move-out date cannot be earlier than move-in date.',
        );
      }

      final now = DateTime.now();

      // 1. Update move_out_date on historical record (never delete)
      await (db.update(db.tenants)..where((t) => t.id.equals(tenantId))).write(
        TenantsCompanion(
          moveOutDate: Value(moveOutDate),
          updatedAt: Value(now),
        ),
      );

      // 2. Update apartment status to available
      await (db.update(
        db.apartments,
      )..where((t) => t.id.equals(tenantEntry.apartmentId))).write(
        ApartmentsCompanion(
          status: const Value(ApartmentStatus.available),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> updateTenant(Tenant tenant) async {
    await (db.update(db.tenants)..where((t) => t.id.equals(tenant.id))).write(
      TenantsCompanion(
        fullName: Value(tenant.fullName),
        phone: Value(tenant.phone),
        nationalId: Value(tenant.nationalId),
        address: Value(tenant.address),
        monthlyRent: Value(tenant.monthlyRent),
        depositAmount: Value(tenant.depositAmount),
        contractStartDate: Value(tenant.contractStartDate),
        contractEndDate: Value(tenant.contractEndDate),
        paymentDueDay: Value(tenant.paymentDueDay),
        moveInDate: Value(tenant.moveInDate),
        moveOutDate: Value(tenant.moveOutDate),
        notes: Value(tenant.notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}
