import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/service_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/service.dart';
import '../controllers/service_bill_controller.dart';
import 'service_bill_form_view.dart';
import 'service_details_view.dart';

class ServicesListView extends StatelessWidget {
  const ServicesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceBillController controller = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('فواتير الخدمات والمرافق'),
        actions: [
          IconButton(
            tooltip: 'تحديث الفواتير',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadAllServices(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.receipt_long_outlined),
        label: const Text('إصدار فاتورة خدمة جديدة'),
        onPressed: () => Get.to(() => const ServiceBillFormView()),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allServices.isEmpty) {
          return const LoadingWidget(message: 'جاري تحميل فواتير الخدمات...');
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.allServices.isEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadAllServices(),
          );
        }

        return Column(
          children: [
            // Filter Bar
            _buildSearchAndFiltersHeader(controller),

            // Services List
            Expanded(
              child: controller.allServices.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.receipt_long_outlined,
                      title: 'لا توجد فواتير خدمات مسجلة',
                      description: 'سجل فواتير الكهرباء، المياه والخدمات وحدد المسؤول عن سدادها (المالك أو المستأجر).',
                      buttonText: 'إصدار فاتورة خدمة جديدة',
                      onButtonPressed: () =>
                          Get.to(() => const ServiceBillFormView()),
                    )
                  : controller.filteredServices.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'لا توجد فواتير مطابقة',
                      description: 'جرّب تعديل عبارة البحث أو إزالة التصفية.',
                      buttonText: 'عرض جميع الفواتير',
                      onButtonPressed: () => controller.clearFilters(),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => controller.loadAllServices(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: controller.filteredServices.length,
                        itemBuilder: (context, index) {
                          final bill = controller.filteredServices[index];
                          return _buildServiceCard(context, bill, controller);
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchAndFiltersHeader(ServiceBillController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'ابحث بنوع الخدمة، رقم الشقة أو الملاحظات...',
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
                  label: 'الكل (${controller.allServices.length})',
                  isSelected: controller.typeFilter.value == 'all',
                  onSelected: () => controller.setTypeFilter('all'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'كهرباء',
                  isSelected: controller.typeFilter.value == 'electricity',
                  selectedColor: const Color(0xFFD35400),
                  onSelected: () => controller.setTypeFilter('electricity'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'مياه',
                  isSelected: controller.typeFilter.value == 'water',
                  selectedColor: const Color(0xFF2980B9),
                  onSelected: () => controller.setTypeFilter('water'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'إنترنت',
                  isSelected: controller.typeFilter.value == 'internet',
                  selectedColor: const Color(0xFF8E44AD),
                  onSelected: () => controller.setTypeFilter('internet'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'أخرى / صيانة',
                  isSelected: controller.typeFilter.value == 'other',
                  selectedColor: AppColors.warning,
                  onSelected: () => controller.setTypeFilter('other'),
                ),
                const SizedBox(width: 14),
                // Payer Responsibility Quick Toggle
                _buildFilterChip(
                  label: 'على المستأجر',
                  isSelected: controller.payerFilter.value == 'tenant',
                  selectedColor: AppColors.secondary,
                  onSelected: () => controller.setPayerFilter(
                    controller.payerFilter.value == 'tenant' ? 'all' : 'tenant',
                  ),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'على المالك',
                  isSelected: controller.payerFilter.value == 'owner',
                  selectedColor: AppColors.primary,
                  onSelected: () => controller.setPayerFilter(
                    controller.payerFilter.value == 'owner' ? 'all' : 'owner',
                  ),
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

  Widget _buildServiceCard(
    BuildContext context,
    ServiceBill bill,
    ServiceBillController controller,
  ) {
    final apt = controller.apartmentsMap[bill.apartmentId];
    final prop = apt != null ? controller.propertiesMap[apt.propertyId] : null;
    final balance = controller.serviceBalances[bill.id];
    final isFullyPaid = balance?.isFullyPaid ?? false;

    IconData icon;
    Color iconColor;
    switch (bill.serviceType) {
      case ServiceType.electricity:
        icon = Icons.bolt;
        iconColor = const Color(0xFFD35400);
        break;
      case ServiceType.water:
        icon = Icons.water_drop;
        iconColor = const Color(0xFF2980B9);
        break;
      case ServiceType.gas:
        icon = Icons.local_fire_department;
        iconColor = const Color(0xFFC0392B);
        break;
      case ServiceType.internet:
        icon = Icons.wifi;
        iconColor = const Color(0xFF8E44AD);
        break;
      case ServiceType.other:
        icon = Icons.build;
        iconColor = AppColors.warning;
        break;
    }

    final isOwner = bill.payerResponsibility == PayerResponsibility.owner;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () => Get.to(() => ServiceDetailsView(serviceId: bill.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.12),
            child: Icon(icon, color: iconColor, size: 20),
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
                      bill.serviceType.displayName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(bill.totalAmount),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      apt != null
                          ? '${prop?.name ?? 'عقار'} • شقة ${apt.apartmentNumber}'
                          : 'شقة #${bill.apartmentId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isFullyPaid
                            ? AppColors.successLight
                            : AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isFullyPaid
                            ? 'مسددة'
                            : 'متبقي ${CurrencyFormatter.format(balance?.outstandingBalance ?? bill.totalAmount)}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isFullyPaid
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOwner
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : AppColors.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'مسؤولية: ${bill.payerResponsibility.displayName}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isOwner
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                      ),
                    ),
                    Text(
                      'استحقاق: ${_formatDate(bill.dueDate)}',
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

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
