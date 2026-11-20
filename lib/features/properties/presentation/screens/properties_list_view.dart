import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/property_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/property.dart';
import '../controllers/property_controller.dart';
import 'property_details_view.dart';
import 'property_form_view.dart';

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyController controller = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إدارة العقارات والمجمعات'),
        actions: [
          IconButton(
            tooltip: 'تحديث القائمة',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadProperties(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business),
        label: const Text('إضافة عقار جديد'),
        onPressed: () => Get.to(() => const PropertyFormView()),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.properties.isEmpty) {
          return const LoadingWidget(message: 'جاري تحميل العقارات...');
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.properties.isEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadProperties(),
          );
        }

        return Column(
          children: [
            // Search and Filter Bar
            _buildSearchAndFilterHeader(controller),

            // Active Filters Chips (if any)
            _buildActiveFiltersChips(controller),

            // List of Properties
            Expanded(
              child: controller.properties.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.apartment_outlined,
                      title: 'لا توجد عقارات مسجلة',
                      description: 'ابدأ بإضافة أول مبنى أو مجمع عقاري لإدارة الوحدات والمستأجرين.',
                      buttonText: 'إضافة عقار جديد',
                      onButtonPressed: () =>
                          Get.to(() => const PropertyFormView()),
                    )
                  : controller.filteredProperties.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'لا توجد نتائج مطابقة',
                      description:
                          'جرّب تعديل كلمة البحث أو إزالة بعض عوامل التصفية.',
                      buttonText: 'مسح الفلاتر',
                      onButtonPressed: () => controller.clearFilters(),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => controller.loadProperties(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: controller.filteredProperties.length,
                        itemBuilder: (context, index) {
                          final property = controller.filteredProperties[index];
                          return _buildPropertyCard(
                            context,
                            property,
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

  Widget _buildSearchAndFilterHeader(PropertyController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Search Input
              Expanded(
                child: TextField(
                  onChanged: controller.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'ابحث بالاسم، المدينة، أو الحي...',
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
              ),
              const SizedBox(width: 8),

              // Filter Action Button
              Container(
                decoration: BoxDecoration(
                  color:
                      (controller.selectedTypeFilter.value != null ||
                          controller.selectedCityFilter.isNotEmpty ||
                          controller.selectedDistrictFilter.isNotEmpty)
                      ? AppColors.primary
                      : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  tooltip: 'تصفية النتائج',
                  icon: Icon(
                    Icons.filter_list,
                    color:
                        (controller.selectedTypeFilter.value != null ||
                            controller.selectedCityFilter.isNotEmpty ||
                            controller.selectedDistrictFilter.isNotEmpty)
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                  onPressed: () => _showFilterBottomSheet(controller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips(PropertyController controller) {
    final hasFilters =
        controller.selectedTypeFilter.value != null ||
        controller.selectedCityFilter.isNotEmpty ||
        controller.selectedDistrictFilter.isNotEmpty;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (controller.selectedTypeFilter.value != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  label: Text(
                    'نوع: ${controller.selectedTypeFilter.value!.displayName}',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setTypeFilter(null),
                ),
              ),
            if (controller.selectedCityFilter.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                  label: Text(
                    'المدينة: ${controller.selectedCityFilter.value}',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setCityFilter(''),
                ),
              ),
            if (controller.selectedDistrictFilter.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.info.withValues(alpha: 0.1),
                  label: Text(
                    'الحي: ${controller.selectedDistrictFilter.value}',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setDistrictFilter(''),
                ),
              ),
            TextButton(
              onPressed: () => controller.clearFilters(),
              child: const Text(
                'مسح الكل',
                style: TextStyle(fontSize: 12, color: AppColors.danger),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(
    BuildContext context,
    Property property,
    PropertyController controller,
  ) {
    final stats = controller.propertyStats[property.id];

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      onTap: () {
        controller.loadPropertyDetails(property.id);
        Get.to(() => PropertyDetailsView(propertyId: property.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Image/Icon, Name, Type Badge, and Actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Thumbnail
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child:
                    property.imagePath != null && property.imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          property.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.location_city,
                                color: AppColors.primary,
                                size: 28,
                              ),
                        ),
                      )
                    : const Icon(
                        Icons.location_city,
                        color: AppColors.primary,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 12),

              // Title, Address, Floors
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _buildTypeBadge(property.propertyType),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${property.district}، ${property.city} • ${property.address}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'عدد الطوابق: ${property.numberOfFloors}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Statistics Row: Apartments, Occupancy, Income
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn(
                  title: 'إجمالي الشقق',
                  value: '${stats?.totalApartments ?? 0}',
                  color: AppColors.textPrimary,
                ),
                _buildDivider(),
                _buildMetricColumn(
                  title: 'مؤجرة',
                  value: '${stats?.occupiedApartments ?? 0}',
                  color: AppColors.success,
                ),
                _buildDivider(),
                _buildMetricColumn(
                  title: 'شاغرة',
                  value: '${stats?.availableApartments ?? 0}',
                  color: AppColors.info,
                ),
                _buildDivider(),
                _buildMetricColumn(
                  title: 'نسبة الإشغال',
                  value: '${(stats?.occupancyRate ?? 0.0).toStringAsFixed(0)}%',
                  color: (stats?.occupancyRate ?? 0.0) >= 80
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Footer: Expected Monthly Rent & Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإيراد المتوقع شهرياً',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(stats?.expectedMonthlyIncome ?? 0),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Edit Action
                  IconButton(
                    tooltip: 'تعديل بيانات العقار',
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        Get.to(() => PropertyFormView(property: property)),
                  ),

                  // Delete Action with Confirmation
                  IconButton(
                    tooltip: 'حذف العقار',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    onPressed: () =>
                        _confirmDeleteProperty(context, property, controller),
                  ),

                  // View Details Action
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('التفاصيل'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () {
                      controller.loadPropertyDetails(property.id);
                      Get.to(
                        () => PropertyDetailsView(propertyId: property.id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(PropertyType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.displayName,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildMetricColumn({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 24, color: AppColors.border);
  }

  void _showFilterBottomSheet(PropertyController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تصفية العقارات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                    child: const Text(
                      'إعادة ضبط',
                      style: TextStyle(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),

              // Property Type Filter
              const Text(
                'نوع العقار',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: controller.selectedTypeFilter.value == null,
                    onSelected: (selected) {
                      if (selected) controller.setTypeFilter(null);
                    },
                  ),
                  ...PropertyType.values.map((type) {
                    return ChoiceChip(
                      label: Text(type.displayName),
                      selected: controller.selectedTypeFilter.value == type,
                      onSelected: (selected) {
                        controller.setTypeFilter(selected ? type : null);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // City Filter
              if (controller.availableCities.isNotEmpty) ...[
                const Text(
                  'المدينة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('جميع المدن'),
                      selected: controller.selectedCityFilter.isEmpty,
                      onSelected: (selected) {
                        if (selected) controller.setCityFilter('');
                      },
                    ),
                    ...controller.availableCities.map((city) {
                      return ChoiceChip(
                        label: Text(city),
                        selected: controller.selectedCityFilter.value == city,
                        onSelected: (selected) {
                          controller.setCityFilter(selected ? city : '');
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // District Filter
              if (controller.availableDistricts.isNotEmpty) ...[
                const Text(
                  'الحي',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('جميع الأحياء'),
                      selected: controller.selectedDistrictFilter.isEmpty,
                      onSelected: (selected) {
                        if (selected) controller.setDistrictFilter('');
                      },
                    ),
                    ...controller.availableDistricts.map((district) {
                      return ChoiceChip(
                        label: Text(district),
                        selected:
                            controller.selectedDistrictFilter.value == district,
                        onSelected: (selected) {
                          controller.setDistrictFilter(
                            selected ? district : '',
                          );
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('تطبيق التصفية'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _confirmDeleteProperty(
    BuildContext context,
    Property property,
    PropertyController controller,
  ) {
    Get.defaultDialog(
      title: 'تأكيد حذف العقار',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText:
          'هل أنت متأكد من رغبتك في حذف "${property.name}"؟\n'
          'ملاحظة: لا يمكن حذف عقار يحتوي على وحدات سكنية مسجلة.',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () async {
        Get.back();
        final success = await controller.removeProperty(property.id);
        if (!success) {
          Get.snackbar(
            'تعذر الحذف',
            controller.errorMessage.value,
            backgroundColor: AppColors.dangerLight,
            colorText: AppColors.danger,
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.danger,
            ),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        } else {
          Get.snackbar(
            'تم الحذف',
            'تم حذف العقار بنجاح.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }
}
