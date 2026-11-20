import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/enums/property_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../controllers/property_controller.dart';
import 'property_form_view.dart';

class PropertyDetailsView extends StatelessWidget {
  final int propertyId;

  const PropertyDetailsView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    final PropertyController controller = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تفاصيل العقار'),
        actions: [
          IconButton(
            tooltip: 'تعديل',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final prop = controller.currentProperty.value;
              if (prop != null) {
                Get.to(() => PropertyFormView(property: prop));
              }
            },
          ),
          IconButton(
            tooltip: 'حذف',
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () {
              final prop = controller.currentProperty.value;
              if (prop != null) {
                _confirmDelete(context, prop, controller);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isDetailsLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل تفاصيل العقار...');
        }

        final property = controller.currentProperty.value;
        if (property == null) {
          return const Center(child: Text('العقار غير موجود'));
        }

        final stats = controller.currentPropertyStats.value;
        final apartments = controller.currentPropertyApartments;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Property Header Card
              _buildHeaderCard(property),
              const SizedBox(height: 16),

              // 2. Occupancy & Financial Summary KPI Grid
              _buildStatsGrid(stats),
              const SizedBox(height: 20),

              // 3. Complete Property Information
              const Text(
                'بيانات العقار التفصيلية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _buildDetailsCard(property),
              const SizedBox(height: 24),

              // 4. Associated Apartments Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'الوحدات السكنية التابعة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${apartments.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildApartmentsList(apartments),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(dynamic property) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: property.imagePath != null && property.imagePath!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      property.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.apartment,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.apartment,
                    size: 36,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        property.propertyType.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${property.district}، ${property.city}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.layers_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${property.numberOfFloors} طوابق • ${property.address}',
                      style: const TextStyle(
                        fontSize: 12,
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

  Widget _buildStatsGrid(dynamic stats) {
    final total = stats?.totalApartments ?? 0;
    final occupied = stats?.occupiedApartments ?? 0;
    final available = stats?.availableApartments ?? 0;
    final rate = (stats?.occupancyRate ?? 0.0) as double;
    final income = stats?.expectedMonthlyIncome ?? 0;

    return Column(
      children: [
        // Occupancy progress bar
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'نسبة إشغال العقار',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${rate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: rate >= 80 ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0.0 : (occupied / total),
                  backgroundColor: AppColors.surfaceMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rate >= 80 ? AppColors.success : AppColors.warning,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$occupied من إجمالي $total شقق مؤجرة حالياً',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 3-Card Metrics Row
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'إجمالي الشقق',
                value: '$total',
                icon: Icons.meeting_room_outlined,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: 'الشقق المؤجرة',
                value: '$occupied',
                icon: Icons.check_circle_outline,
                iconColor: AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: 'الشقق الشاغرة',
                value: '$available',
                icon: Icons.door_front_door_outlined,
                iconColor: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Expected Monthly Income Card
        StatCard(
          title: 'الإيراد الشهري المتوقع للوحدات المؤجرة',
          value: CurrencyFormatter.format(income),
          subtitle:
              'مجموع القيمة الإيجارية الشهرية للشقق المؤجرة في هذا العقار',
          icon: Icons.monetization_on_outlined,
          iconColor: AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildDetailsCard(dynamic property) {
    return AppCard(
      child: Column(
        children: [
          _buildInfoRow(label: 'معرّف العقار (ID)', value: '#${property.id}'),
          const Divider(height: 18),
          _buildInfoRow(
            label: 'نوع العقار',
            value: property.propertyType.displayName,
          ),
          const Divider(height: 18),
          _buildInfoRow(label: 'المدينة', value: property.city),
          const Divider(height: 18),
          _buildInfoRow(label: 'الحي', value: property.district),
          const Divider(height: 18),
          _buildInfoRow(
            label: 'العنوان الوطني / الشارع',
            value: property.address,
          ),
          const Divider(height: 18),
          _buildInfoRow(
            label: 'عدد الطوابق',
            value: '${property.numberOfFloors} طوابق',
          ),
          if (property.description != null &&
              property.description!.isNotEmpty) ...[
            const Divider(height: 18),
            _buildInfoRow(
              label: 'الوصف والملاحظات',
              value: property.description!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentsList(List<Apartment> apartments) {
    if (apartments.isEmpty) {
      return const AppCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.meeting_room_outlined,
                  size: 36,
                  color: AppColors.textMuted,
                ),
                SizedBox(height: 8),
                Text(
                  'لا توجد شقق مسجلة لهذا العقار حتى الآن.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apartments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final apt = apartments[index];
        final isOccupied = apt.status == ApartmentStatus.occupied;
        final isAvailable = apt.status == ApartmentStatus.available;

        return AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isOccupied
                    ? AppColors.successLight
                    : (isAvailable
                          ? AppColors.infoLight
                          : AppColors.warningLight),
                child: Text(
                  apt.apartmentNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isOccupied
                        ? AppColors.success
                        : (isAvailable ? AppColors.info : AppColors.warning),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شقة رقم ${apt.apartmentNumber} (الطابق ${apt.floorNumber})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'المساحة: ${apt.area} م² • الإيجار: ${CurrencyFormatter.format(apt.monthlyRent)}/شهر',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOccupied
                      ? AppColors.successLight
                      : (isAvailable
                            ? AppColors.infoLight
                            : AppColors.warningLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  apt.status.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isOccupied
                        ? AppColors.success
                        : (isAvailable ? AppColors.info : AppColors.warning),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    dynamic property,
    PropertyController controller,
  ) {
    Get.defaultDialog(
      title: 'تأكيد حذف العقار',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText:
          'هل أنت متأكد من رغبتك في حذف "${property.name}"؟\n'
          'تنبيه: لا يمكن حذف عقار يحتوي على وحدات سكنية تابعة.',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () async {
        Get.back();
        final success = await controller.removeProperty(property.id);
        if (success) {
          Get.back(); // Exit details screen
          Get.snackbar(
            'تم الحذف',
            'تم حذف العقار بنجاح.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
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
        }
      },
    );
  }
}
