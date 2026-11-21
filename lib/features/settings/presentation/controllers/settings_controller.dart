import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/database/app_database.dart';
import '../../../apartments/presentation/controllers/apartment_controller.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../payments/presentation/controllers/payment_controller.dart';
import '../../../properties/presentation/controllers/property_controller.dart';
import '../../../services/presentation/controllers/service_bill_controller.dart';
import '../../../tenants/presentation/controllers/tenant_controller.dart';

class DatabaseTableStats {
  final int propertiesCount;
  final int apartmentsCount;
  final int specificationsCount;
  final int tenantsCount;
  final int paymentsCount;
  final int servicesCount;

  DatabaseTableStats({
    required this.propertiesCount,
    required this.apartmentsCount,
    required this.specificationsCount,
    required this.tenantsCount,
    required this.paymentsCount,
    required this.servicesCount,
  });

  int get totalRecords =>
      propertiesCount +
      apartmentsCount +
      specificationsCount +
      tenantsCount +
      paymentsCount +
      servicesCount;
}

class SettingsController extends GetxController {
  final AppDatabase db;

  SettingsController(this.db);

  final Rxn<DatabaseTableStats> stats = Rxn<DatabaseTableStats>();
  final RxBool isLoading = false.obs;
  final RxString statusMessage = ''.obs;
  final RxList<String> availableBackups = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDatabaseStats();
    listAvailableBackups();
  }

  Future<void> loadDatabaseStats() async {
    try {
      isLoading.value = true;

      final propsCount =
          await (db.selectOnly(db.properties)
                ..addColumns([db.properties.id.count()]))
              .map((row) => row.read(db.properties.id.count()) ?? 0)
              .getSingle();

      final aptsCount =
          await (db.selectOnly(db.apartments)
                ..addColumns([db.apartments.id.count()]))
              .map((row) => row.read(db.apartments.id.count()) ?? 0)
              .getSingle();

      final specsCount =
          await (db.selectOnly(db.apartmentSpecifications)
                ..addColumns([db.apartmentSpecifications.id.count()]))
              .map(
                (row) => row.read(db.apartmentSpecifications.id.count()) ?? 0,
              )
              .getSingle();

      final tenantsCount =
          await (db.selectOnly(db.tenants)..addColumns([db.tenants.id.count()]))
              .map((row) => row.read(db.tenants.id.count()) ?? 0)
              .getSingle();

      final paymentsCount =
          await (db.selectOnly(db.payments)
                ..addColumns([db.payments.id.count()]))
              .map((row) => row.read(db.payments.id.count()) ?? 0)
              .getSingle();

      final servicesCount =
          await (db.selectOnly(db.services)
                ..addColumns([db.services.id.count()]))
              .map((row) => row.read(db.services.id.count()) ?? 0)
              .getSingle();

      stats.value = DatabaseTableStats(
        propertiesCount: propsCount,
        apartmentsCount: aptsCount,
        specificationsCount: specsCount,
        tenantsCount: tenantsCount,
        paymentsCount: paymentsCount,
        servicesCount: servicesCount,
      );
    } catch (e) {
      statusMessage.value = 'خطأ في قراءة إحصائيات الجداول: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Directory> get _backupDir async {
    Directory baseDir;
    try {
      baseDir = await getApplicationDocumentsDirectory();
    } catch (_) {
      baseDir = Directory.current;
    }
    final dir = Directory(p.join(baseDir.path, 'backups'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> listAvailableBackups() async {
    try {
      final dir = await _backupDir;
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json') || f.path.endsWith('.sqlite'))
          .map((f) => p.basename(f.path))
          .toList();
      files.sort((a, b) => b.compareTo(a));
      availableBackups.assignAll(files);
    } catch (_) {}
  }

  // Universal Backup (JSON Export of all 6 tables)
  Future<String?> createBackup() async {
    try {
      isLoading.value = true;
      statusMessage.value = 'جاري تصدير نسخة احتياطية من الجداول الستة...';

      final props = await db.select(db.properties).get();
      final apts = await db.select(db.apartments).get();
      final specs = await db.select(db.apartmentSpecifications).get();
      final tenants = await db.select(db.tenants).get();
      final payments = await db.select(db.payments).get();
      final services = await db.select(db.services).get();

      final backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'tableCount': 6,
        'tables': {
          'properties': props.map((p) => p.toJson()).toList(),
          'apartments': apts.map((a) => a.toJson()).toList(),
          'apartmentSpecifications': specs.map((s) => s.toJson()).toList(),
          'tenants': tenants.map((t) => t.toJson()).toList(),
          'payments': payments.map((p) => p.toJson()).toList(),
          'services': services.map((s) => s.toJson()).toList(),
        },
      };

      final now = DateTime.now();
      final filename =
          'backup_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.json';

      final dir = await _backupDir;
      final file = File(p.join(dir.path, filename));
      await file.writeAsString(jsonEncode(backupData));

      await listAvailableBackups();
      statusMessage.value = 'تم حفظ النسخة الاحتياطية بنجاح: $filename';
      return filename;
    } catch (e) {
      statusMessage.value = 'فشل إنشاء النسخة الاحتياطية: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Restore Backup
  Future<bool> restoreBackup(String filename) async {
    try {
      isLoading.value = true;
      statusMessage.value = 'جاري استعادة البيانات من $filename...';

      final dir = await _backupDir;
      final file = File(p.join(dir.path, filename));
      if (!file.existsSync()) {
        throw 'ملف النسخة الاحتياطية غير موجود.';
      }

      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      if (data['tableCount'] != 6 || !data.containsKey('tables')) {
        throw 'النسخة الاحتياطية غير صالحة ولا تطابق معمارية الجداول الستة المعتمدة.';
      }

      final tables = data['tables'] as Map<String, dynamic>;

      // Execute restoration inside a single atomic transaction
      await db.transaction(() async {
        // 1. Delete in reverse dependency order
        await db.delete(db.payments).go();
        await db.delete(db.services).go();
        await db.delete(db.tenants).go();
        await db.delete(db.apartmentSpecifications).go();
        await db.delete(db.apartments).go();
        await db.delete(db.properties).go();

        // 2. Insert in forward dependency order
        // Properties
        for (final item in tables['properties'] ?? []) {
          await db.into(db.properties).insert(PropertyEntry.fromJson(item));
        }
        // Apartments
        for (final item in tables['apartments'] ?? []) {
          await db.into(db.apartments).insert(ApartmentEntry.fromJson(item));
        }
        // Specifications
        for (final item in tables['apartmentSpecifications'] ?? []) {
          await db
              .into(db.apartmentSpecifications)
              .insert(ApartmentSpecificationEntry.fromJson(item));
        }
        // Tenants
        for (final item in tables['tenants'] ?? []) {
          await db.into(db.tenants).insert(TenantEntry.fromJson(item));
        }
        // Services (must be before payments)
        for (final item in tables['services'] ?? []) {
          await db.into(db.services).insert(ServiceEntry.fromJson(item));
        }
        // Payments
        for (final item in tables['payments'] ?? []) {
          await db.into(db.payments).insert(PaymentEntry.fromJson(item));
        }
      });

      // Reload controllers
      await loadDatabaseStats();
      _refreshAllControllers();

      statusMessage.value = 'تمت استعادة كافة البيانات بنجاح.';
      return true;
    } catch (e) {
      statusMessage.value = 'فشلت الاستعادة: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshAllControllers() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
    if (Get.isRegistered<PropertyController>()) {
      Get.find<PropertyController>().loadProperties();
    }
    if (Get.isRegistered<ApartmentController>()) {
      Get.find<ApartmentController>().loadAllApartments();
    }
    if (Get.isRegistered<TenantController>()) {
      Get.find<TenantController>().loadAllTenants();
    }
    if (Get.isRegistered<PaymentController>()) {
      Get.find<PaymentController>().loadAllPayments();
    }
    if (Get.isRegistered<ServiceBillController>()) {
      Get.find<ServiceBillController>().loadAllServices();
    }
  }
}
