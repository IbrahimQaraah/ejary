import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/payment.dart';
import '../controllers/payment_controller.dart';

class PaymentDetailsView extends StatefulWidget {
  final int paymentId;

  const PaymentDetailsView({super.key, required this.paymentId});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  final PaymentController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.loadPaymentDetails(widget.paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() {
          final p = _controller.currentPayment.value;
          return Text(p != null ? 'سند قبض #${p.id}' : 'تفاصيل السند');
        }),
      ),
      body: Obx(() {
        if (_controller.isDetailsLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل تفاصيل السند...');
        }

        final payment = _controller.currentPayment.value;
        if (payment == null) {
          return ErrorStateWidget(
            message: _controller.errorMessage.isNotEmpty
                ? _controller.errorMessage.value
                : 'لم يتم العثور على بيانات هذا السند.',
            onRetry: () => _controller.loadPaymentDetails(widget.paymentId),
          );
        }

        final apt = _controller.apartmentsMap[payment.apartmentId];
        final prop = apt != null
            ? _controller.propertiesMap[apt.propertyId]
            : null;
        final tenant = payment.tenantId != null
            ? _controller.tenantsMap[payment.tenantId!]
            : null;

        final isReversal = payment.isReversal;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 1. Receipt Voucher Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Official Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      (isReversal
                                              ? AppColors.danger
                                              : AppColors.primary)
                                          .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isReversal
                                      ? Icons.undo_rounded
                                      : Icons.receipt_long,
                                  color: isReversal
                                      ? AppColors.danger
                                      : AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isReversal
                                          ? 'سند قيد عكسي وتسوية'
                                          : 'سند قبض إيجار / تحصيل',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      payment.referenceNumber != null
                                          ? 'رقم المرجع: ${payment.referenceNumber}'
                                          : 'رقم السند: #${payment.id}',
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
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isReversal
                                ? AppColors.dangerLight
                                : AppColors.successLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isReversal ? 'قيد عكسي' : 'مدفوع ومعتمد',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isReversal
                                  ? AppColors.danger
                                  : AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),

                    // Amount Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'المبلغ المحصل بالريال السعودي',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            CurrencyFormatter.format(payment.amount),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: isReversal
                                  ? AppColors.danger
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Details Rows
                    _buildReceiptRow(
                      label: 'تاريخ الدفع الفعلي',
                      value: _formatDate(payment.paymentDate),
                    ),
                    const Divider(height: 18),
                    _buildReceiptRow(
                      label: 'طريقة الدفع',
                      value: payment.paymentMethod.displayName,
                    ),
                    const Divider(height: 18),
                    _buildReceiptRow(
                      label: 'نوع المعاملة',
                      value: payment.paymentType.displayName,
                    ),
                    if (payment.billingPeriod != null) ...[
                      const Divider(height: 18),
                      _buildReceiptRow(
                        label: 'فترة الاستحقاق',
                        value: payment.billingPeriod!,
                      ),
                    ],
                    const Divider(height: 18),
                    _buildReceiptRow(
                      label: 'الدافع / المستأجر',
                      value: tenant?.fullName ?? payment.paidBy.displayName,
                    ),
                    const Divider(height: 18),
                    _buildReceiptRow(
                      label: 'الوحدة والعقار',
                      value: apt != null
                          ? '${prop?.name ?? 'عقار'} • شقة رقم ${apt.apartmentNumber}'
                          : 'شقة #${payment.apartmentId}',
                    ),
                    if (payment.notes != null && payment.notes!.isNotEmpty) ...[
                      const Divider(height: 18),
                      _buildReceiptRow(
                        label: 'ملاحظات المعاملة',
                        value: payment.notes!,
                      ),
                    ],
                    const Divider(height: 18),
                    _buildReceiptRow(
                      label: 'تاريخ تسجيل القيد في النظام',
                      value: _formatDateTime(payment.createdAt),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Reversal / Adjustment Action (Immutable Ledger correction)
              if (!isReversal)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    icon: const Icon(Icons.undo_rounded),
                    label: const Text(
                      'إجراء قيد عكسي / تسوية مالية (Ledger Reversal)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _confirmReversal(context, payment),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReceiptRow({required String label, required String value}) {
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

  void _confirmReversal(BuildContext context, PaymentTransaction payment) {
    final reasonController = TextEditingController();

    Get.defaultDialog(
      title: 'إجراء قيد عكسي وتسوية',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      content: Column(
        children: [
          const Text(
            'وفقاً لمعايير السجل المالي غير القابل للحذف (Immutable Ledger)، لن يتم حذف السند الأصلي، بل سيتم تسجيل قيد عكسي بقيمة سالبة لضبط الرصيد بدقة وتوثيق سبب التسوية.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'سبب القيد العكسي *',
              hintText: 'مثال: خطأ في إدخال المبلغ أو تم إرجاع المبلغ',
            ),
          ),
        ],
      ),
      textConfirm: 'تأكيد التسوية',
      textCancel: 'إلغاء',
      buttonColor: AppColors.danger,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final reason = reasonController.text.trim();
        if (reason.isEmpty) {
          Get.snackbar(
            'تنبيه',
            'يرجى كتابة سبب التسوية المالية.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        Get.back(); // Close dialog
        final success = await _controller.reversePayment(
          originalPayment: payment,
          reason: reason,
        );

        if (success) {
          Get.back(); // Exit details
          Get.snackbar(
            'تمت التسوية',
            'تم تسجيل القيد العكسي بنجاح وتحديث الأرصدة.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'فشلت العملية',
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

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
