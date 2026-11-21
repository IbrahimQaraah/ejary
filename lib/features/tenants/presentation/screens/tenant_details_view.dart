import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../apartments/presentation/screens/apartment_details_view.dart';
import '../../domain/entities/tenant.dart';
import '../controllers/tenant_controller.dart';
import 'tenant_form_view.dart';

class TenantDetailsView extends StatefulWidget {
  final int tenantId;

  const TenantDetailsView({super.key, required this.tenantId});

  @override
  State<TenantDetailsView> createState() => _TenantDetailsViewState();
}

class _TenantDetailsViewState extends State<TenantDetailsView> {
  final TenantController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.loadTenantDetails(widget.tenantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() {
          final t = _controller.currentTenant.value;
          return Text(t != null ? t.fullName : 'تفاصيل المستأجر');
        }),
        actions: [
          Obx(() {
            final t = _controller.currentTenant.value;
            if (t == null) return const SizedBox.shrink();

            return IconButton(
              tooltip: 'تعديل البيانات',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Get.to(() => TenantFormView(tenant: t)),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (_controller.isDetailsLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل تفاصيل المستأجر...');
        }

        final tenant = _controller.currentTenant.value;
        if (tenant == null) {
          return ErrorStateWidget(
            message: _controller.errorMessage.isNotEmpty
                ? _controller.errorMessage.value
                : 'لم يتم العثور على بيانات هذا المستأجر.',
            onRetry: () => _controller.loadTenantDetails(widget.tenantId),
          );
        }

        final apt = _controller.currentTenantApartment.value;
        final prop = _controller.currentTenantProperty.value;
        final payments = _controller.currentTenantPayments;
        final isActive = tenant.isActive;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _controller.loadTenantDetails(widget.tenantId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Tenant Info Card
                _buildHeaderCard(tenant),
                const SizedBox(height: 16),

                // 2. Financial Overview Cards
                _buildFinancialRow(tenant),
                const SizedBox(height: 16),

                // 3. Rented Apartment Details Card
                _buildApartmentCard(tenant, apt, prop),
                const SizedBox(height: 16),

                // 4. Contract Terms & Dates Card
                _buildContractCard(tenant),
                const SizedBox(height: 16),

                // 5. Payments History Section
                _buildPaymentsSection(payments),
                const SizedBox(height: 24),

                // 6. Action Buttons (Vacate / Edit)
                if (isActive) _buildActiveActionButtons(tenant),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(Tenant tenant) {
    final isActive = tenant.isActive;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isActive
                    ? AppColors.successLight
                    : AppColors.surfaceMuted,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: isActive ? AppColors.success : AppColors.textMuted,
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
                            tenant.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.successLight
                                : AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isActive ? 'عقد نشط ومستمر' : 'عقد منتهي ومغادر',
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tenant.phone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tenant.nationalId,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'العنوان / جهة العمل: ${tenant.address}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(Tenant tenant) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'الإيجار الشهري المتفق عليه',
            value: CurrencyFormatter.format(tenant.monthlyRent),
            icon: Icons.payments_outlined,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            title: 'مبلغ التأمين المسترد',
            value: CurrencyFormatter.format(tenant.depositAmount),
            icon: Icons.security_outlined,
            iconColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentCard(Tenant tenant, dynamic apt, dynamic prop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوحدة السكنية المؤجرة',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppCard(
          onTap: apt != null
              ? () => Get.to(() => ApartmentDetailsView(apartmentId: apt.id))
              : null,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.apartment, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apt != null
                          ? '${prop?.name ?? 'عقار'} • شقة رقم ${apt.apartmentNumber}'
                          : 'شقة رقم #${tenant.apartmentId}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apt != null
                          ? 'الطابق: ${apt.floorNumber} • المساحة: ${apt.area} م² • ${prop?.city ?? ''} - ${prop?.district ?? ''}'
                          : 'معرف الشقة: ${tenant.apartmentId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContractCard(Tenant tenant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'شروط العقد والتواريخ المهمة',
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
              _buildInfoRow(
                label: 'تاريخ بداية العقد',
                value: _formatDate(tenant.contractStartDate),
              ),
              const Divider(height: 18),
              _buildInfoRow(
                label: 'تاريخ انتهاء العقد',
                value: _formatDate(tenant.contractEndDate),
              ),
              const Divider(height: 18),
              _buildInfoRow(
                label: 'يوم الاستحقاق الشهري',
                value: 'اليوم ${tenant.paymentDueDay} من كل شهر ميلادي',
              ),
              const Divider(height: 18),
              _buildInfoRow(
                label: 'تاريخ استلام الوحدة (Move-in)',
                value: _formatDate(tenant.moveInDate),
              ),
              if (tenant.moveOutDate != null) ...[
                const Divider(height: 18),
                _buildInfoRow(
                  label: 'تاريخ الإخلاء والمغادرة (Move-out)',
                  value: _formatDate(tenant.moveOutDate!),
                  valueColor: AppColors.danger,
                ),
              ],
              if (tenant.notes != null && tenant.notes!.isNotEmpty) ...[
                const Divider(height: 18),
                _buildInfoRow(
                  label: 'ملاحظات وشروط خاصة',
                  value: tenant.notes!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsSection(List<dynamic> payments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'سجل الدفعات والمقبوضات',
                  style: TextStyle(
                    fontSize: 15,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${payments.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        payments.isEmpty
            ? const AppCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 32,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'لا توجد دفعات مسجلة لهذا المستأجر حتى الآن.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payments.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final p = payments[index];
                  return AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'دفعة إيجار (${p.billingPeriod})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'التاريخ: ${_formatDate(p.paymentDate)} • سند: ${p.referenceNumber ?? '#${p.id}'}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(p.amount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildActiveActionButtons(Tenant tenant) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text(
              'إنهاء العقد وإخلاء الوحدة السكنية (Vacate)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => _confirmVacate(context, tenant),
          ),
        ),
      ],
    );
  }

  void _confirmVacate(BuildContext context, Tenant tenant) {
    DateTime moveOutDate = DateTime.now();

    Get.defaultDialog(
      title: 'إنهاء العقد وإخلاء الوحدة',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            children: [
              Text(
                'سيتم تسجيل مغادرة المستأجر (${tenant.fullName}) وإخلاء الشقة لتصبح شاغرة ومتاحة للتأجير مجدداً.\n\n'
                'ملاحظة: السجل التاريخي للمستأجر وجميع دفعاته المالية محفوظة بالكامل ولن تُحذف.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: moveOutDate,
                    firstDate: tenant.moveInDate,
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    setDialogState(() => moveOutDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تاريخ الإخلاء الفعلي:',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        _formatDate(moveOutDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      textConfirm: 'تأكيد الإخلاء',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () async {
        Get.back(); // Close dialog
        final success = await _controller.vacateCurrentTenant(
          tenantId: tenant.id,
          apartmentId: tenant.apartmentId,
          moveOutDate: moveOutDate,
        );
        if (success) {
          Get.snackbar(
            'تم الإخلاء بنجاح',
            'تم إنهاء العقد وتحديث حالة الشقة إلى شاغرة ومتاحة.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'تعذر الإخلاء',
            _controller.errorMessage.value,
            backgroundColor: AppColors.dangerLight,
            colorText: AppColors.danger,
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.danger,
            ),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
