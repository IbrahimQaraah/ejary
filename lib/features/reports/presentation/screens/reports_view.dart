import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/stat_card.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportsController controller = Get.put(
      ReportsController(
        getPropertiesUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
        getAllTenantsUseCase: Get.find(),
        getAllPaymentsUseCase: Get.find(),
        getAllServicesUseCase: Get.find(),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التقارير المالية والتحليلات المتقدمة'),
        actions: [
          IconButton(
            tooltip: 'تحديث التقرير',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadReportsData(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'جاري تجميع وحساب التقارير...');
        }

        if (controller.errorMessage.isNotEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadReportsData(),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.loadReportsData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Executive Summary Financial Row
                const Text(
                  'ملخص الأداء المالي والتحصيل',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'إجمالي الإيجارات المحصلة',
                        value: CurrencyFormatter.format(
                          controller.totalRentCollected.value,
                        ),
                        icon: Icons.payments_outlined,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: 'الإيراد الشهري المتوقع',
                        value: CurrencyFormatter.format(
                          controller.totalExpectedMonthlyIncome.value,
                        ),
                        icon: Icons.monetization_on_outlined,
                        iconColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Occupancy and Collection Rate Row
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'نسبة إشغال المحفظة',
                        value:
                            '${controller.overallOccupancyRate.value.toStringAsFixed(1)}%',
                        subtitle:
                            '${controller.occupiedApartmentsCount.value} من ${controller.totalApartmentsCount.value} شقق مؤجرة',
                        icon: Icons.pie_chart_outline,
                        iconColor: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: 'نسبة التحصيل التقديرية',
                        value:
                            '${controller.collectionRate.value.toStringAsFixed(1)}%',
                        subtitle: 'نسبة المحصل إلى المتوقع',
                        icon: Icons.trending_up,
                        iconColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Expenses and Liabilities Breakdown
                const Text(
                  'تفصيل المصاريف والالتزامات التشغيلية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    children: [
                      _buildExpenseRow(
                        title: 'نفقات تشغيلية ومرافق على عاتق المالك',
                        amount: controller.ownerExpenses.value,
                        color: AppColors.primary,
                        icon: Icons.home_repair_service_outlined,
                      ),
                      const Divider(height: 20),
                      _buildExpenseRow(
                        title: 'فواتير ومرافق على عاتق المستأجرين',
                        amount: controller.tenantExpenses.value,
                        color: AppColors.secondary,
                        icon: Icons.receipt_long_outlined,
                      ),
                      const Divider(height: 20),
                      _buildExpenseRow(
                        title: 'إجمالي مبالغ التأمين المحتجزة',
                        amount: controller.totalDepositsHeld.value,
                        color: AppColors.info,
                        icon: Icons.security_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Per-Property Portfolio Breakdown
                const Text(
                  'تقرير أداء العقارات والمجمعات السكنية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                controller.propertyReports.isEmpty
                    ? const AppCard(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'لا توجد عقارات مسجلة لعرض التقارير.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.propertyReports.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = controller.propertyReports[index];
                          return _buildPropertyReportCard(item);
                        },
                      ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildExpenseRow({
    required String title,
    required int amount,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyReportCard(PropertyReportItem item) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.property.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'إشغال: ${item.occupancyRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${item.property.city} - ${item.property.district} • ${item.property.numberOfFloors} طوابق',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.totalApartments == 0
                  ? 0.0
                  : (item.occupiedApartments / item.totalApartments),
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(
                item.occupancyRate >= 70
                    ? AppColors.success
                    : AppColors.warning,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'الوحدات: ${item.occupiedApartments} مؤجرة من ${item.totalApartments}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'المحصل: ${CurrencyFormatter.format(item.actualCollectedRent)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
