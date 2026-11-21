import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/payment_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/payment.dart';
import '../controllers/payment_controller.dart';
import 'payment_details_view.dart';
import 'record_payment_view.dart';

class PaymentsListView extends StatelessWidget {
  const PaymentsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سجل المقبوضات والدفعات'),
        actions: [
          IconButton(
            tooltip: 'تحديث السجل',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadAllPayments(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_card_outlined),
        label: const Text('تسجيل سند قبض جديد'),
        onPressed: () => Get.to(() => const RecordPaymentView()),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allPayments.isEmpty) {
          return const LoadingWidget(message: 'جاري تحميل السجل المالي...');
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.allPayments.isEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadAllPayments(),
          );
        }

        return Column(
          children: [
            // Header Search & Type Filters
            _buildSearchAndFilterHeader(controller),

            // Quick Stats Banner (Total Collected)
            _buildTotalCollectedBanner(controller),

            // Payments List
            Expanded(
              child: controller.allPayments.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'لا توجد دفعات أو مقبوضات مسجلة',
                      description: 'ابدأ بتسجيل أول سند قبض إيجار أو تحصيل فاتورة خدمات.',
                      buttonText: 'تسجيل سند قبض جديد',
                      onButtonPressed: () =>
                          Get.to(() => const RecordPaymentView()),
                    )
                  : controller.filteredPayments.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'لا توجد دفعات مطابقة',
                      description: 'جرّب تعديل عبارة البحث أو إزالة التصفية.',
                      buttonText: 'عرض جميع الدفعات',
                      onButtonPressed: () => controller.clearFilters(),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => controller.loadAllPayments(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: controller.filteredPayments.length,
                        itemBuilder: (context, index) {
                          final payment = controller.filteredPayments[index];
                          return _buildPaymentCard(
                            context,
                            payment,
                            controller,
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchAndFilterHeader(PaymentController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'ابحث برقم السند، اسم المستأجر أو رقم الشقة...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              suffixIcon: controller.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => controller.setSearchQuery(''),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'الكل (${controller.allPayments.length})',
                  isSelected: controller.typeFilter.value == 'all',
                  onSelected: () => controller.setTypeFilter('all'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'دفعات الإيجار',
                  isSelected: controller.typeFilter.value == 'rent',
                  selectedColor: AppColors.primary,
                  onSelected: () => controller.setTypeFilter('rent'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'فواتير الخدمات',
                  isSelected: controller.typeFilter.value == 'service',
                  selectedColor: AppColors.secondary,
                  onSelected: () => controller.setTypeFilter('service'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    Color selectedColor = AppColors.primary,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.12)
              : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? selectedColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCollectedBanner(PaymentController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.monetization_on, color: AppColors.primary, size: 22),
                SizedBox(width: 8),
                Text(
                  'إجمالي المقبوضات المحصلة:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              CurrencyFormatter.format(controller.totalCollectedAmount),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    PaymentTransaction payment,
    PaymentController controller,
  ) {
    final isReversal = payment.isReversal;
    final isRent = payment.paymentType == PaymentType.rent;
    final isService = payment.paymentType == PaymentType.service;

    final apt = controller.apartmentsMap[payment.apartmentId];
    final prop = apt != null ? controller.propertiesMap[apt.propertyId] : null;
    final tenant = payment.tenantId != null
        ? controller.tenantsMap[payment.tenantId!]
        : null;

    final IconData icon = isReversal
        ? Icons.undo_rounded
        : isRent
        ? Icons.home_outlined
        : isService
        ? Icons.receipt_long_outlined
        : Icons.security_outlined;

    final Color badgeColor = isReversal
        ? AppColors.danger
        : isRent
        ? AppColors.primary
        : isService
        ? AppColors.secondary
        : AppColors.info;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () => Get.to(() => PaymentDetailsView(paymentId: payment.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: badgeColor.withValues(alpha: 0.12),
            child: Icon(icon, color: badgeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isReversal
                          ? 'قيد تسوية / عكسي'
                          : isRent
                          ? 'سند إيجار (${payment.billingPeriod ?? ''})'
                          : isService
                          ? 'سداد فاتورة مرافق'
                          : 'مبلغ تأمين مسترد',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isReversal
                            ? AppColors.danger
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(payment.amount),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isReversal
                            ? AppColors.danger
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tenant != null
                      ? 'المستأجر: ${tenant.fullName}'
                      : 'الدافع: ${payment.paidBy.displayName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      apt != null
                          ? '${prop?.name ?? 'عقار'} • شقة ${apt.apartmentNumber}'
                          : 'شقة #${payment.apartmentId}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '${payment.paymentDate.year}/${payment.paymentDate.month.toString().padLeft(2, '0')}/${payment.paymentDate.day.toString().padLeft(2, '0')} • ${payment.paymentMethod.displayName}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
