import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(
      SettingsController(Get.find()),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إعدادات النظام والنسخ الاحتياطي'),
        actions: [
          IconButton(
            tooltip: 'تحديث البيانات',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              controller.loadDatabaseStats();
              controller.listAvailableBackups();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'جاري معالجة البيانات...');
        }

        final stats = controller.stats.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Strict 6-Table Architecture Badge
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'معمارية قاعدة البيانات المعتمدة',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'التطبيق ملتزم بقاعدة البيانات الصارمة المكونة من 6 جداول أعمال فقط (SQLite + Drift ORM). إجمالي السجلات: ${stats?.totalRecords ?? 0}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Table Records Grid
              const Text(
                'إحصائيات جداول قاعدة البيانات (6 جداول)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  children: [
                    _buildTableStatRow(
                      tableIndex: 1,
                      tableName: 'Properties',
                      arabicName: 'العقارات والمباني',
                      count: stats?.propertiesCount ?? 0,
                      icon: Icons.apartment,
                    ),
                    const Divider(height: 16),
                    _buildTableStatRow(
                      tableIndex: 2,
                      tableName: 'Apartments',
                      arabicName: 'الشقق والوحدات السكنية',
                      count: stats?.apartmentsCount ?? 0,
                      icon: Icons.meeting_room,
                    ),
                    const Divider(height: 16),
                    _buildTableStatRow(
                      tableIndex: 3,
                      tableName: 'ApartmentSpecifications',
                      arabicName: 'المواصفات والتجهيزات الداخلية',
                      count: stats?.specificationsCount ?? 0,
                      icon: Icons.tune,
                    ),
                    const Divider(height: 16),
                    _buildTableStatRow(
                      tableIndex: 4,
                      tableName: 'Tenants',
                      arabicName: 'المستأجرون وسجلات العقود',
                      count: stats?.tenantsCount ?? 0,
                      icon: Icons.people,
                    ),
                    const Divider(height: 16),
                    _buildTableStatRow(
                      tableIndex: 5,
                      tableName: 'Payments',
                      arabicName: 'سجل المقبوضات والدفعات المالية',
                      count: stats?.paymentsCount ?? 0,
                      icon: Icons.payments,
                    ),
                    const Divider(height: 16),
                    _buildTableStatRow(
                      tableIndex: 6,
                      tableName: 'Services',
                      arabicName: 'فواتير الخدمات والمرافق',
                      count: stats?.servicesCount ?? 0,
                      icon: Icons.receipt_long,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Backup and Restore Section
              const Text(
                'النسخ الاحتياطي واستعادة البيانات',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حفظ واسترجاع كامل بيانات المحفظة العقارية',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'يتضمن النسخ الاحتياطي تصدير كامل الجداول الستة وعلاقات التكامل المرجعي والسجل المالي التاريخي بصيغة مشفرة آمنة.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.backup_outlined),
                        label: const Text(
                          'إنشاء نسخة احتياطية فورية الآن (Create Backup)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          final file = await controller.createBackup();
                          if (file != null) {
                            Get.snackbar(
                              'تم إنشاء النسخة الاحتياطية',
                              'تم تصدير وحفظ النسخة في مجلد backups بنجاح.',
                              backgroundColor: AppColors.successLight,
                              colorText: AppColors.success,
                              icon: const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                    ),
                    if (controller.availableBackups.isNotEmpty) ...[
                      const Divider(height: 24),
                      const Text(
                        'النسخ الاحتياطية المتوفرة على الجهاز:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.availableBackups.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final backupFile = controller.availableBackups[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.archive_outlined,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      backupFile,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.restore, size: 16),
                                  label: const Text(
                                    'استعادة',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () => _confirmRestore(
                                    context,
                                    backupFile,
                                    controller,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. System & App Specifications
              const Text(
                'معلومات النظام والبيئة التشغيلية',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  children: [
                    _buildSystemRow(
                      'اسم التطبيق',
                      'إدارة العقارات والأملاك (Production Login)',
                    ),
                    const Divider(height: 16),
                    _buildSystemRow('الإصدار', '1.0.0 (Production Release)'),
                    const Divider(height: 16),
                    _buildSystemRow(
                      'محرك قاعدة البيانات',
                      'SQLite 3 via Drift ORM',
                    ),
                    const Divider(height: 16),
                    _buildSystemRow(
                      'الخط الطباعي المعتمد',
                      'IBM Plex Sans Arabic',
                    ),
                    const Divider(height: 16),
                    _buildSystemRow(
                      'العملة الافتراضية',
                      'الريال السعودي (SAR)',
                    ),
                    const Divider(height: 16),
                    _buildSystemRow(
                      'اتجاه الواجهة',
                      'من اليمين إلى اليسار (RTL)',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTableStatRow({
    required int tableIndex,
    required String tableName,
    required String arabicName,
    required int count,
    required IconData icon,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                arabicName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'الجدول $tableIndex: $tableName',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: count > 0
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count سجلات',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: count > 0 ? AppColors.success : AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _confirmRestore(
    BuildContext context,
    String filename,
    SettingsController controller,
  ) {
    Get.defaultDialog(
      title: 'تأكيد استعادة النسخة الاحتياطية',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText:
          'هل أنت متأكد من استعادة النسخة ($filename)؟\n\n'
          'سيتم استبدال البيانات الحالية بالكامل بالبيانات المحفوظة في النسخة الاحتياطية وإعادة تحميل كافة الشاشات.',
      textConfirm: 'تأكيد الاستعادة',
      textCancel: 'إلغاء',
      buttonColor: AppColors.danger,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        final success = await controller.restoreBackup(filename);
        if (success) {
          Get.snackbar(
            'تمت الاستعادة بنجاح',
            'تم استرجاع كافة بيانات المحفظة والعقارات بنجاح.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'فشلت الاستعادة',
            controller.statusMessage.value,
            backgroundColor: AppColors.dangerLight,
            colorText: AppColors.danger,
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.danger,
            ),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }
}
