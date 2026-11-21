import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/apartment.dart';
import '../controllers/apartment_controller.dart';
import 'apartment_details_view.dart';
import 'apartment_form_view.dart';

class ApartmentsListView extends StatelessWidget {
  final int? initialPropertyIdFilter;

  const ApartmentsListView({super.key, this.initialPropertyIdFilter});

  @override
  Widget build(BuildContext context) {
    final ApartmentController controller = Get.find();

    if (initialPropertyIdFilter != null &&
        controller.selectedPropertyFilter.value != initialPropertyIdFilter) {
      controller.setPropertyFilter(initialPropertyIdFilter);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إدارة الشقق والوحدات السكنية'),
        actions: [
          IconButton(
            tooltip: 'تحديث القائمة',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadAllApartments(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_home_work_outlined),
        label: const Text('إضافة شقة جديدة'),
        onPressed: () => Get.to(
          () =>
              ApartmentFormView(preselectedPropertyId: initialPropertyIdFilter),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.apartments.isEmpty) {
          return const LoadingWidget(message: 'جاري تحميل الشقق والوحدات...');
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.apartments.isEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadAllApartments(),
          );
        }

        return Column(
          children: [
            // Search and Filter Bar
            _buildSearchAndFilterHeader(controller),

            // Active Filters Chips (if any)
            _buildActiveFiltersChips(controller),

            // List of Apartments
            Expanded(
              child: controller.apartments.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.meeting_room_outlined,
                      title: 'لا توجد شقق مسجلة',
                      description:
                          'ابدأ بتسجيل أول وحدة سكنية وربطها بالعقار المحدد.',
                      buttonText: 'إضافة شقة جديدة',
                      onButtonPressed: () => Get.to(
                        () => ApartmentFormView(
                          preselectedPropertyId: initialPropertyIdFilter,
                        ),
                      ),
                    )
                  : controller.filteredApartments.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'لا توجد نتائج مطابقة',
                      description:
                          'جرّب تعديل كلمة البحث أو إزالة بعض خيارات التصفية.',
                      buttonText: 'مسح الفلاتر',
                      onButtonPressed: () => controller.clearFilters(),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => controller.loadAllApartments(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: controller.filteredApartments.length,
                        itemBuilder: (context, index) {
                          final apt = controller.filteredApartments[index];
                          return _buildApartmentCard(context, apt, controller);
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchAndFilterHeader(ApartmentController controller) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Search Input
          Expanded(
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'ابحث برقم الشقة أو اسم العقار...',
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
                  (controller.selectedPropertyFilter.value != null ||
                      controller.selectedFloorFilter.value != null ||
                      controller.selectedStatusFilter.value != null ||
                      controller.minRentFilter.value != null)
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
                    (controller.selectedPropertyFilter.value != null ||
                        controller.selectedFloorFilter.value != null ||
                        controller.selectedStatusFilter.value != null ||
                        controller.minRentFilter.value != null)
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
              onPressed: () => _showFilterBottomSheet(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips(ApartmentController controller) {
    final hasFilters =
        controller.selectedPropertyFilter.value != null ||
        controller.selectedFloorFilter.value != null ||
        controller.selectedStatusFilter.value != null ||
        controller.minRentFilter.value != null;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (controller.selectedPropertyFilter.value != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  label: Text(
                    'عقار: ${controller.propertiesMap[controller.selectedPropertyFilter.value]?.name ?? controller.selectedPropertyFilter.value}',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setPropertyFilter(null),
                ),
              ),
            if (controller.selectedStatusFilter.value != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                  label: Text(
                    'الحالة: ${controller.selectedStatusFilter.value!.displayName}',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setStatusFilter(null),
                ),
              ),
            if (controller.selectedFloorFilter.value != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.info.withValues(alpha: 0.1),
                  label: Text(
                    'الطابق: ${controller.selectedFloorFilter.value}',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setFloorFilter(null),
                ),
              ),
            if (controller.minRentFilter.value != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Chip(
                  backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                  label: Text(
                    'إيجار: ${CurrencyFormatter.format(controller.minRentFilter.value!)}+',
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => controller.setRentRange(null, null),
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

  Widget _buildApartmentCard(
    BuildContext context,
    Apartment apt,
    ApartmentController controller,
  ) {
    final spec = controller.specifications[apt.id];
    final propName =
        controller.propertiesMap[apt.propertyId]?.name ??
        'عقار #${apt.propertyId}';
    final isOccupied = apt.status == ApartmentStatus.occupied;
    final isAvailable = apt.status == ApartmentStatus.available;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      onTap: () {
        controller.loadApartmentDetails(apt.id);
        Get.to(() => ApartmentDetailsView(apartmentId: apt.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Number, Property Name, Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: isOccupied
                    ? AppColors.successLight
                    : (isAvailable
                          ? AppColors.infoLight
                          : AppColors.warningLight),
                child: Text(
                  apt.apartmentNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isOccupied
                        ? AppColors.success
                        : (isAvailable ? AppColors.info : AppColors.warning),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title, Property Name, Floor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'شقة ${apt.apartmentNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _buildStatusBadge(apt.status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.apartment,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            propName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'الطابق: ${apt.floorNumber} • المساحة: ${apt.area} م²',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Specifications Summary
          if (spec != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpecItem(Icons.bed_outlined, '${spec.bedrooms} غرف'),
                  _buildSpecItem(
                    Icons.bathtub_outlined,
                    '${spec.bathrooms} حمام',
                  ),
                  _buildSpecItem(
                    Icons.weekend_outlined,
                    '${spec.livingRooms} صالة',
                  ),
                  if (spec.hasAc) _buildSpecItem(Icons.ac_unit, 'مكيفة'),
                  if (spec.hasParking)
                    _buildSpecItem(Icons.local_parking, 'موقف'),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Footer: Monthly Rent & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإيجار الشهري',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(apt.monthlyRent),
                    style: const TextStyle(
                      fontSize: 15,
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
                    tooltip: 'تعديل بيانات الشقة',
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () => Get.to(
                      () => ApartmentFormView(
                        apartment: apt,
                        specification: spec,
                      ),
                    ),
                  ),

                  // Delete Action with safety check
                  IconButton(
                    tooltip: 'حذف الشقة',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    onPressed: () =>
                        _confirmDeleteApartment(context, apt, controller),
                  ),

                  // Details Action
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
                      controller.loadApartmentDetails(apt.id);
                      Get.to(() => ApartmentDetailsView(apartmentId: apt.id));
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

  Widget _buildStatusBadge(ApartmentStatus status) {
    Color bg;
    Color text;

    switch (status) {
      case ApartmentStatus.occupied:
        bg = AppColors.successLight;
        text = AppColors.success;
        break;
      case ApartmentStatus.available:
        bg = AppColors.infoLight;
        text = AppColors.info;
        break;
      case ApartmentStatus.maintenance:
        bg = AppColors.warningLight;
        text = AppColors.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(ApartmentController controller) {
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
                    'تصفية الشقق والوحدات',
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

              // Status Filter
              const Text(
                'حالة الشقة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: controller.selectedStatusFilter.value == null,
                    onSelected: (selected) {
                      if (selected) controller.setStatusFilter(null);
                    },
                  ),
                  ...ApartmentStatus.values.map((status) {
                    return ChoiceChip(
                      label: Text(status.displayName),
                      selected: controller.selectedStatusFilter.value == status,
                      onSelected: (selected) {
                        controller.setStatusFilter(selected ? status : null);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Property Filter
              if (controller.propertiesMap.isNotEmpty) ...[
                const Text(
                  'العقار التابع له',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('جميع العقارات'),
                      selected: controller.selectedPropertyFilter.value == null,
                      onSelected: (selected) {
                        if (selected) controller.setPropertyFilter(null);
                      },
                    ),
                    ...controller.propertiesMap.values.map((prop) {
                      return ChoiceChip(
                        label: Text(prop.name),
                        selected:
                            controller.selectedPropertyFilter.value == prop.id,
                        onSelected: (selected) {
                          controller.setPropertyFilter(
                            selected ? prop.id : null,
                          );
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Floor Filter
              if (controller.availableFloors.isNotEmpty) ...[
                const Text(
                  'الطابق',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('جميع الطوابق'),
                      selected: controller.selectedFloorFilter.value == null,
                      onSelected: (selected) {
                        if (selected) controller.setFloorFilter(null);
                      },
                    ),
                    ...controller.availableFloors.map((floor) {
                      return ChoiceChip(
                        label: Text('الطابق $floor'),
                        selected: controller.selectedFloorFilter.value == floor,
                        onSelected: (selected) {
                          controller.setFloorFilter(selected ? floor : null);
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

  void _confirmDeleteApartment(
    BuildContext context,
    Apartment apt,
    ApartmentController controller,
  ) {
    Get.defaultDialog(
      title: 'تأكيد حذف الشقة',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText:
          'هل أنت متأكد من رغبتك في حذف الشقة رقم "${apt.apartmentNumber}"؟\n'
          'تنبيه: لا يمكن حذف شقة مرتبطة بسجلات مستأجرين أو دفعات مالية مسجلة.',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () async {
        Get.back();
        final success = await controller.removeApartment(
          apt.id,
          apt.propertyId,
        );
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
            'تم حذف الشقة ومواصفاتها بنجاح.',
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
