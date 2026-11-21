import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/tenant.dart';
import '../controllers/tenant_controller.dart';
import 'tenant_details_view.dart';
import 'tenant_form_view.dart';

class TenantsListView extends StatelessWidget {
  const TenantsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TenantController controller = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سجل المستأجرين والعقود'),
        actions: [
          IconButton(
            tooltip: 'تحديث القائمة',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadAllTenants(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('تسجيل مستأجر جديد'),
        onPressed: () => Get.to(() => const TenantFormView()),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allTenants.isEmpty) {
          return const LoadingWidget(message: 'جاري تحميل سجل المستأجرين...');
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.allTenants.isEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadAllTenants(),
          );
        }

        return Column(
          children: [
            // Search and Status Tabs
            _buildSearchAndFilterHeader(controller),

            // Quick Stats Banner
            _buildQuickStats(controller),

            // Tenants List
            Expanded(
              child: controller.allTenants.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.people_outline,
                      title: 'لا يوجد مستأجرون مسجلون',
                      description:
                          'ابدأ بتسجيل أول مستأجر وربطه بوحدة سكنية شاغرة.',
                      buttonText: 'تسجيل مستأجر جديد',
                      onButtonPressed: () =>
                          Get.to(() => const TenantFormView()),
                    )
                  : controller.filteredTenants.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'لا توجد نتائج مطابقة للبحث',
                      description: 'جرّب تغيير عبارة البحث أو إزالة التصفية.',
                      buttonText: 'عرض كافة المستأجرين',
                      onButtonPressed: () => controller.clearFilters(),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => controller.loadAllTenants(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: controller.filteredTenants.length,
                        itemBuilder: (context, index) {
                          final tenant = controller.filteredTenants[index];
                          return _buildTenantCard(context, tenant, controller);
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchAndFilterHeader(TenantController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم، رقم الجوال، الهوية أو رقم الشقة...',
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
          // Status Chips (All / Active / Vacated)
          Row(
            children: [
              _buildFilterChip(
                label: 'الكل (${controller.allTenants.length})',
                isSelected: controller.statusFilter.value == 'all',
                onSelected: () => controller.setStatusFilter('all'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'عقود نشطة (${controller.totalActiveTenants})',
                isSelected: controller.statusFilter.value == 'active',
                selectedColor: AppColors.success,
                onSelected: () => controller.setStatusFilter('active'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'عقود سابقة (${controller.totalVacatedTenants})',
                isSelected: controller.statusFilter.value == 'vacated',
                selectedColor: AppColors.textSecondary,
                onSelected: () => controller.setStatusFilter('vacated'),
              ),
            ],
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

  Widget _buildQuickStats(TenantController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${controller.totalActiveTenants} مستأجرين حاليين',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${controller.totalVacatedTenants} سجلات سابقة',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenantCard(
    BuildContext context,
    Tenant tenant,
    TenantController controller,
  ) {
    final apt = controller.apartmentsMap[tenant.apartmentId];
    final prop = apt != null ? controller.propertiesMap[apt.propertyId] : null;

    final isActive = tenant.isActive;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () => Get.to(() => TenantDetailsView(tenantId: tenant.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: isActive
                    ? AppColors.successLight
                    : AppColors.surfaceMuted,
                child: Icon(
                  Icons.person,
                  color: isActive ? AppColors.success : AppColors.textMuted,
                ),
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
                          tenant.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.successLight
                                : AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isActive ? 'عقد نشط' : 'عقد منتهي',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'جوال: ${tenant.phone} • هوية: ${tenant.nationalId}',
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
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.home_work_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    apt != null
                        ? '${prop?.name ?? 'عقار'} • شقة ${apt.apartmentNumber}'
                        : 'شقة #${tenant.apartmentId}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '${CurrencyFormatter.format(tenant.monthlyRent)}/شهر',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
