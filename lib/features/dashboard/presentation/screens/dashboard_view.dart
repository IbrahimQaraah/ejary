import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../navigation/presentation/controllers/navigation_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    final NavigationController navCtrl = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.domain, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لوحة التحكم العقارية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'نظام إدارة الأملاك والمستأجرين',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'تحديث البيانات',
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () => controller.loadDashboard(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.metrics.value == null) {
          return const LoadingWidget(
            message: 'جاري تحميل مؤشرات الأداء العقارية...',
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.metrics.value == null) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadDashboard(),
          );
        }

        final m = controller.metrics.value;
        if (m == null) {
          return const Center(child: Text('لا توجد بيانات متاحة'));
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.loadDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Welcome & Occupancy Summary Banner
                _buildOccupancyBanner(m),
                const SizedBox(height: 20),

                // 2. Financial Overview Cards
                const Text(
                  'المؤشرات المالية الرئيسية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFinancialGrid(m),
                const SizedBox(height: 24),

                // 3. Operational Overview Cards (Units & Tenants)
                const Text(
                  'إحصائيات الوحدات السكنية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildOperationalGrid(m, navCtrl),
                const SizedBox(height: 24),

                // 4. Quick Actions
                const Text(
                  'إجراءات سريعة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildQuickActions(context, navCtrl),
                const SizedBox(height: 24),

                // 5. Recent Financial Transactions Ledger
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'آخر المعاملات المالية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          navCtrl.changeIndex(3), // Navigate to Payments Tab
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildRecentTransactions(m),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOccupancyBanner(dynamic m) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F173F35),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'نسبة الإشغال العام',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${m.occupiedApartments} من ${m.totalApartments} وحدات',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${m.occupancyRate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                m.occupancyRate >= 80
                    ? 'إشغال ممتاز'
                    : (m.occupancyRate >= 50 ? 'إشغال متوسط' : 'يتطلب تأجير'),
                style: TextStyle(
                  color: m.occupancyRate >= 80
                      ? const Color(0xFF68D391)
                      : const Color(0xFFFBD38D),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: m.totalApartments == 0
                  ? 0.0
                  : (m.occupiedApartments / m.totalApartments),
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF48BB78),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialGrid(dynamic m) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'الدخل الشهري المتوقع',
                value: CurrencyFormatter.format(m.expectedMonthlyIncome),
                subtitle: 'إجمالي إيجارات العقود النشطة',
                icon: Icons.trending_up,
                iconColor: AppColors.primary,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'المبالغ المحصلة',
                value: CurrencyFormatter.format(m.collectedPayments),
                subtitle: 'إجمالي المقبوضات المسجلة',
                icon: Icons.check_circle_outline,
                iconColor: AppColors.success,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'المستحقات المتبقية',
                value: CurrencyFormatter.format(m.outstandingBalances),
                subtitle: 'إيجارات وفواتير قيد التحصيل',
                icon: Icons.hourglass_top,
                iconColor: AppColors.warning,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'فواتير الخدمات والمرافق',
                value: CurrencyFormatter.format(m.utilityExpenses),
                subtitle: 'كهرباء، مياه، غاز وإنترنت',
                icon: Icons.receipt_long,
                iconColor: AppColors.secondary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOperationalGrid(dynamic m, NavigationController navCtrl) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'إجمالي العقارات',
            value: '${m.totalProperties}',
            subtitle: 'مباني ومجمعات',
            icon: Icons.apartment,
            iconColor: AppColors.primary,
            onTap: () => navCtrl.changeIndex(1), // Properties
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            title: 'الوحدات الشاغرة',
            value: '${m.availableApartments}',
            subtitle: 'جاهزة للتأجير',
            icon: Icons.door_front_door_outlined,
            iconColor: AppColors.info,
            onTap: () => navCtrl.changeIndex(4), // More -> Apartments
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            title: 'المستأجرون النشطون',
            value: '${m.totalActiveTenants}',
            subtitle: 'عقود سارية',
            icon: Icons.person_pin,
            iconColor: AppColors.secondary,
            onTap: () => navCtrl.changeIndex(2), // Tenants
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    NavigationController navCtrl,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'إدارة العقارات',
            icon: Icons.add_business,
            color: AppColors.primary,
            onTap: () => navCtrl.changeIndex(1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            label: 'إدارة المستأجرين',
            icon: Icons.person_add_alt_1,
            color: AppColors.secondary,
            onTap: () => navCtrl.changeIndex(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            label: 'سجل الدفعات',
            icon: Icons.payment,
            color: const Color(0xFF2E7D32),
            onTap: () => navCtrl.changeIndex(3),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(dynamic m) {
    if (m.recentTransactions.isEmpty) {
      return const AppCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 40,
                  color: AppColors.textMuted,
                ),
                SizedBox(height: 10),
                Text(
                  'لا توجد حركات مالية مسجلة بعد',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: m.recentTransactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final tx = m.recentTransactions[index];
          final isReversal = tx.isReversal;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: isReversal
                  ? AppColors.dangerLight
                  : (tx.paidBy == PayerResponsibility.tenant
                        ? AppColors.successLight
                        : AppColors.infoLight),
              child: Icon(
                isReversal
                    ? Icons.replay
                    : (tx.paidBy == PayerResponsibility.tenant
                          ? Icons.arrow_downward
                          : Icons.arrow_upward),
                color: isReversal
                    ? AppColors.danger
                    : (tx.paidBy == PayerResponsibility.tenant
                          ? AppColors.success
                          : AppColors.info),
                size: 20,
              ),
            ),
            title: Text(
              tx.paymentType == PaymentType.rent
                  ? 'دفعة إيجار (شقة #${tx.apartmentId})'
                  : 'فاتورة خدمات (شقة #${tx.apartmentId})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              '${tx.paidBy == PayerResponsibility.tenant ? "دُفعت بواسطة المستأجر" : "سُددت بواسطة المالك"} • طريقة الدفع: ${tx.paymentMethod.displayName}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(tx.amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isReversal ? AppColors.danger : AppColors.primary,
                  ),
                ),
                if (tx.billingPeriod != null)
                  Text(
                    'فترة ${tx.billingPeriod}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
