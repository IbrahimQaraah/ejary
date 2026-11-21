import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../apartments/presentation/screens/apartments_list_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('المزيد من الخدمات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Property & Units
          const Text(
            'إدارة الوحدات والمرافق',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: Icons.meeting_room,
            iconColor: AppColors.primary,
            title: 'إدارة الشقق والوحدات',
            subtitle: 'المواصفات، التجهيزات وحالة الإشغال',
            onTap: () => Get.to(() => const ApartmentsListView()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.receipt_long,
            iconColor: AppColors.secondary,
            title: 'فواتير الخدمات والمرافق',
            subtitle: 'الكهرباء، المياه، الغاز، الإنترنت وقراءات العدادات',
            onTap: () {
              Get.snackbar(
                'الخدمات',
                'سيتم فتح شاشة فواتير الخدمات في الخطوة المخصصة',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 20),

          // Section 2: Financial & Reports
          const Text(
            'التحليلات والتقارير',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: Icons.pie_chart,
            iconColor: AppColors.info,
            title: 'التقارير المالية المتقدمة',
            subtitle:
                'الدخل الشهري، نسبة التحصيل، ونفقات المالك مقابل المستأجر',
            onTap: () {
              Get.snackbar(
                'التقارير',
                'سيتم تفعيل شاشة التقارير التفصيلية في المرحلة 8',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 20),

          // Section 3: App Settings & System
          const Text(
            'إعدادات النظام',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: Icons.tune,
            iconColor: const Color(0xFF5D6D7E),
            title: 'إعدادات التطبيق',
            subtitle: 'العملة الافتراضية، التنبيهات والنسخ الاحتياطي',
            onTap: () {
              Get.snackbar(
                'الإعدادات',
                'خيارات النظام وتخصيص الواجهات',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.info_outline,
            iconColor: AppColors.primaryLight,
            title: 'حول النظام',
            subtitle: 'إصدار 1.0.0 • بنية 6 جداول معمارية نظيفة',
            onTap: () {
              Get.defaultDialog(
                title: 'نظام إدارة الأملاك العقارية',
                middleText: 'نظام إدارة متكامل مبني بمعمارية Clean Architecture وDrift ORM بستة جداول مطابقة للاشتراطات الصارمة.',
                textConfirm: 'حسناً',
                confirmTextColor: Colors.white,
                buttonColor: AppColors.primary,
                onConfirm: () => Get.back(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left, color: AppColors.textMuted, size: 22),
        ],
      ),
    );
  }
}
