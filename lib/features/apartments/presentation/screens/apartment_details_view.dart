import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../tenants/domain/entities/tenant.dart';
import '../../domain/entities/apartment.dart';
import '../../domain/entities/apartment_specification.dart';
import '../controllers/apartment_controller.dart';
import 'apartment_form_view.dart';

class ApartmentDetailsView extends StatefulWidget {
  final int apartmentId;

  const ApartmentDetailsView({super.key, required this.apartmentId});

  @override
  State<ApartmentDetailsView> createState() => _ApartmentDetailsViewState();
}

class _ApartmentDetailsViewState extends State<ApartmentDetailsView> {
  final ApartmentController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.loadApartmentDetails(widget.apartmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() {
          final apt = _controller.currentApartment.value;
          return Text(
            apt != null
                ? 'تفاصيل الشقة ${apt.apartmentNumber}'
                : 'تفاصيل الشقة',
          );
        }),
        actions: [
          Obx(() {
            final apt = _controller.currentApartment.value;
            final spec = _controller.currentApartmentSpec.value;
            if (apt == null) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (val) {
                if (val == 'edit') {
                  Get.to(
                    () =>
                        ApartmentFormView(apartment: apt, specification: spec),
                  );
                } else if (val == 'delete') {
                  _confirmDelete(context, apt);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text('تعديل بيانات الشقة'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.danger,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'حذف الشقة',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (_controller.isDetailsLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل تفاصيل الشقة...');
        }

        final apt = _controller.currentApartment.value;
        if (apt == null) {
          return ErrorStateWidget(
            message: _controller.errorMessage.isNotEmpty
                ? _controller.errorMessage.value
                : 'لم يتم العثور على بيانات هذه الشقة.',
            onRetry: () => _controller.loadApartmentDetails(widget.apartmentId),
          );
        }

        final spec = _controller.currentApartmentSpec.value;
        final prop = _controller.currentApartmentProperty.value;
        final tenant = _controller.currentApartmentTenant.value;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _controller.loadApartmentDetails(widget.apartmentId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Card
                _buildHeaderCard(apt, prop),
                const SizedBox(height: 16),

                // 2. Financial Metrics Row
                _buildFinancialRow(apt),
                const SizedBox(height: 16),

                // 3. Occupancy & Tenant Status Section
                _buildOccupancySection(apt, tenant),
                const SizedBox(height: 16),

                // 4. Specifications & Amenities Card
                _buildSpecificationsSection(spec),
                const SizedBox(height: 16),

                // 5. Property Association Card
                if (prop != null) _buildPropertyCard(prop),
                const SizedBox(height: 24),

                // 6. Action Buttons Bar
                _buildActionButtons(apt, spec),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(Apartment apt, dynamic prop) {
    final isOccupied = apt.status == ApartmentStatus.occupied;
    final isAvailable = apt.status == ApartmentStatus.available;

    return AppCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isOccupied
                      ? AppColors.successLight
                      : (isAvailable
                            ? AppColors.infoLight
                            : AppColors.warningLight),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    apt.apartmentNumber,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isOccupied
                          ? AppColors.success
                          : (isAvailable ? AppColors.info : AppColors.warning),
                    ),
                  ),
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
                        Text(
                          'شقة رقم ${apt.apartmentNumber}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
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
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isOccupied
                                  ? AppColors.success
                                  : (isAvailable
                                        ? AppColors.info
                                        : AppColors.warning),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prop != null
                          ? '${prop.name} • الطابق ${apt.floorNumber}'
                          : 'الطابق ${apt.floorNumber}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المساحة الإجمالية: ${apt.area} م²',
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
          if (apt.description != null && apt.description!.isNotEmpty) ...[
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    apt.description!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialRow(Apartment apt) {
    final annualRent = apt.monthlyRent * 12;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'الإيجار الشهري',
            value: CurrencyFormatter.format(apt.monthlyRent),
            icon: Icons.payments_outlined,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            title: 'الإيجار السنوي التقديري',
            value: CurrencyFormatter.format(annualRent),
            icon: Icons.calendar_today_outlined,
            iconColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOccupancySection(Apartment apt, Tenant? tenant) {
    final isOccupied = apt.status == ApartmentStatus.occupied;
    final isAvailable = apt.status == ApartmentStatus.available;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'حالة الإشغال والمستأجر',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppCard(
          child: isOccupied
              ? (tenant != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.successLight,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tenant.fullName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'الهاتف: ${tenant.phone}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            'رقم الهوية / الإقامة',
                            tenant.nationalId,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'بداية عقد الإيجار',
                            _formatDate(tenant.contractStartDate),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'نهاية عقد الإيجار',
                            _formatDate(tenant.contractEndDate),
                          ),
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.success),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'الشقة مسجلة كمؤجرة. لم يتم العثور على سجل مستأجر نشط مسجل حالياً.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ))
              : isAvailable
              ? const Row(
                  children: [
                    Icon(
                      Icons.door_front_door_outlined,
                      color: AppColors.info,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الوحدة شاغرة ومتاحة للتأجير',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'يمكنك تسكين مستأجر جديد في هذه الوحدة من قائمة المستأجرين.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Row(
                  children: [
                    Icon(
                      Icons.build_circle_outlined,
                      color: AppColors.warning,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الوحدة قيد الصيانة والتجهيز',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'الوحدة غير متاحة للتأجير حالياً حتى اكتمال أعمال الصيانة.',
                            style: TextStyle(
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
      ],
    );
  }

  Widget _buildSpecificationsSection(ApartmentSpecification? spec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المواصفات والتجهيزات الداخلية',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppCard(
          child: Column(
            children: [
              // Grid of Key Counts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpecItem(
                    Icons.bed_outlined,
                    '${spec?.bedrooms ?? 0}',
                    'غرف نوم',
                  ),
                  _buildSpecItem(
                    Icons.bathtub_outlined,
                    '${spec?.bathrooms ?? 0}',
                    'دورات مياه',
                  ),
                  _buildSpecItem(
                    Icons.weekend_outlined,
                    '${spec?.livingRooms ?? 0}',
                    'صالات',
                  ),
                  _buildSpecItem(
                    Icons.kitchen_outlined,
                    '${spec?.kitchens ?? 0}',
                    'مطابخ',
                  ),
                  _buildSpecItem(
                    Icons.deck_outlined,
                    '${spec?.balconies ?? 0}',
                    'شرفات',
                  ),
                ],
              ),
              const Divider(height: 24),

              // Badges for AC and Parking
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: (spec?.hasAc ?? false)
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (spec?.hasAc ?? false)
                                ? Icons.ac_unit
                                : Icons.ac_unit_outlined,
                            size: 18,
                            color: (spec?.hasAc ?? false)
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            (spec?.hasAc ?? false)
                                ? 'تكييف راكب'
                                : 'بدون تكييف',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (spec?.hasAc ?? false)
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: (spec?.hasParking ?? false)
                            ? AppColors.secondary.withValues(alpha: 0.08)
                            : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (spec?.hasParking ?? false)
                                ? Icons.directions_car
                                : Icons.directions_car_outlined,
                            size: 18,
                            color: (spec?.hasParking ?? false)
                                ? AppColors.secondary
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            (spec?.hasParking ?? false)
                                ? 'موقف مخصص'
                                : 'بدون موقف',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (spec?.hasParking ?? false)
                                  ? AppColors.secondary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (spec?.additionalFeatures != null &&
                  spec!.additionalFeatures!.isNotEmpty) ...[
                const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.stars_outlined,
                      size: 18,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تجهيزات ومميزات إضافية:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            spec.additionalFeatures!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(dynamic prop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'العقار التابع له',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppCard(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.apartment, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prop.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${prop.city} • ${prop.district} • ${prop.address}',
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
      ],
    );
  }

  Widget _buildActionButtons(Apartment apt, ApartmentSpecification? spec) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.edit_outlined),
            label: const Text('تعديل البيانات'),
            onPressed: () => Get.to(
              () => ApartmentFormView(apartment: apt, specification: spec),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('حذف الشقة'),
            onPressed: () => _confirmDelete(context, apt),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void _confirmDelete(BuildContext context, Apartment apt) {
    Get.defaultDialog(
      title: 'تأكيد حذف الشقة',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText:
          'هل أنت متأكد من رغبتك في حذف الشقة رقم (${apt.apartmentNumber}) ومواصفاتها؟\n\n'
          'تنبيه: لا يمكن حذف شقة مرتبطة بمستأجرين أو دفعات مالية مسجلة.',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () async {
        Get.back(); // Close dialog
        final success = await _controller.removeApartment(
          apt.id,
          apt.propertyId,
        );
        if (success) {
          Get.back(); // Close details screen
          Get.snackbar(
            'تم الحذف',
            'تم حذف الشقة ومواصفاتها بنجاح.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'تعذر الحذف',
            _controller.errorMessage.value,
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
