import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/service.dart';
import '../controllers/service_bill_controller.dart';

class ServiceDetailsView extends StatefulWidget {
  final int serviceId;

  const ServiceDetailsView({super.key, required this.serviceId});

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  final ServiceBillController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.loadServiceDetails(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() {
          final s = _controller.currentService.value;
          return Text(
            s != null
                ? 'فاتورة ${s.serviceType.displayName}'
                : 'تفاصيل الفاتورة',
          );
        }),
      ),
      body: Obx(() {
        if (_controller.isDetailsLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل تفاصيل الفاتورة...');
        }

        final bill = _controller.currentService.value;
        if (bill == null) {
          return ErrorStateWidget(
            message: _controller.errorMessage.isNotEmpty
                ? _controller.errorMessage.value
                : 'لم يتم العثور على بيانات الفاتورة.',
            onRetry: () => _controller.loadServiceDetails(widget.serviceId),
          );
        }

        final bal = _controller.currentServiceBalance.value;
        final payments = _controller.currentServicePayments;
        final apt = _controller.apartmentsMap[bill.apartmentId];
        final prop = apt != null
            ? _controller.propertiesMap[apt.propertyId]
            : null;

        final isFullyPaid = bal?.isFullyPaid ?? false;
        final isOwner = bill.payerResponsibility == PayerResponsibility.owner;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _controller.loadServiceDetails(widget.serviceId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Bill Header Card
                AppCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  color: AppColors.secondary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bill.serviceType.displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'فاتورة #${bill.id}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isFullyPaid
                                  ? AppColors.successLight
                                  : AppColors.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isFullyPaid ? 'مسددة بالكامل' : 'مستحقة السداد',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isFullyPaid
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Balance Breakdown Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              label: 'إجمالي الفاتورة',
                              value: CurrencyFormatter.format(bill.totalAmount),
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.border,
                          ),
                          Expanded(
                            child: _buildMetricTile(
                              label: 'المسدد حتى الآن',
                              value: CurrencyFormatter.format(
                                bal?.totalPaid ?? 0,
                              ),
                              color: AppColors.success,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.border,
                          ),
                          Expanded(
                            child: _buildMetricTile(
                              label: 'المبلغ المتبقي',
                              value: CurrencyFormatter.format(
                                bal?.outstandingBalance ?? bill.totalAmount,
                              ),
                              color: isFullyPaid
                                  ? AppColors.textMuted
                                  : AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Unit and Responsibility Card
                AppCard(
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'الوحدة السكنية',
                        apt != null
                            ? 'شقة رقم ${apt.apartmentNumber} (${prop?.name ?? ''})'
                            : '#${bill.apartmentId}',
                      ),
                      const Divider(height: 18),
                      _buildInfoRow(
                        'المسؤول عن السداد',
                        isOwner ? 'المالك (نفقات تشغيلية)' : 'المستأجر الحالي',
                      ),
                      const Divider(height: 18),
                      _buildInfoRow(
                        'تاريخ الفاتورة',
                        _formatDate(bill.billingDate),
                      ),
                      const Divider(height: 18),
                      _buildInfoRow(
                        'تاريخ الاستحقاق',
                        _formatDate(bill.dueDate),
                      ),
                      if (bill.previousReading != null &&
                          bill.currentReading != null) ...[
                        const Divider(height: 18),
                        _buildInfoRow(
                          'قراءة العداد',
                          'من ${bill.previousReading} إلى ${bill.currentReading} (الاستهلاك: ${bill.consumption})',
                        ),
                      ],
                      if (bill.notes != null && bill.notes!.isNotEmpty) ...[
                        const Divider(height: 18),
                        _buildInfoRow('ملاحظات الفاتورة', bill.notes!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Payments on this bill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'سندات السداد المسجلة لهذه الفاتورة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${payments.length} سندات',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                payments.isEmpty
                    ? const AppCard(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'لم يتم سداد أي مبالغ لهذه الفاتورة بعد.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: payments.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'سند قبض #${p.id} • ${p.paymentMethod.displayName}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'بتاريخ: ${_formatDate(p.paymentDate)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
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

                const SizedBox(height: 24),

                // 4. Pay Action Button
                if (!isFullyPaid)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: Text(
                        'سداد الفاتورة (متبقي ${CurrencyFormatter.format(bal?.outstandingBalance ?? bill.totalAmount)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _showPayBillDialog(
                        context,
                        bill,
                        bal?.outstandingBalance ?? bill.totalAmount,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
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

  void _showPayBillDialog(
    BuildContext context,
    ServiceBill bill,
    int outstandingMinor,
  ) {
    final amountController = TextEditingController(
      text: (outstandingMinor / 100).toStringAsFixed(0),
    );
    PaymentMethod method = PaymentMethod.bankTransfer;

    Get.defaultDialog(
      title: 'سداد فاتورة ${bill.serviceType.displayName}',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            children: [
              Text(
                'المبلغ المتبقي: ${CurrencyFormatter.format(outstandingMinor)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'المبلغ المراد سداده (ر.س) *',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PaymentMethod>(
                initialValue: method,
                decoration: const InputDecoration(
                  labelText: 'طريقة الدفع',
                  prefixIcon: Icon(Icons.payment),
                ),
                items: PaymentMethod.values.map((m) {
                  return DropdownMenuItem(value: m, child: Text(m.displayName));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => method = val);
                },
              ),
            ],
          );
        },
      ),
      textConfirm: 'تأكيد السداد',
      textCancel: 'إلغاء',
      buttonColor: AppColors.primary,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final amtRiyal = int.tryParse(amountController.text.trim());
        if (amtRiyal == null || amtRiyal <= 0) {
          Get.snackbar('خطأ', 'يرجى إدخال مبلغ صحيح.');
          return;
        }

        final amtMinor = amtRiyal * 100;
        if (amtMinor > outstandingMinor) {
          Get.snackbar('خطأ', 'لا يمكن سداد مبلغ أكبر من الرصيد المتبقي.');
          return;
        }

        Get.back();
        final success = await _controller.payServiceBill(
          bill: bill,
          amountInMinor: amtMinor,
          method: method,
          paidBy: bill.payerResponsibility,
        );

        if (success) {
          Get.snackbar(
            'تم السداد بنجاح',
            'تم تسجيل سند سداد الفاتورة وتحديث الأرصدة بنجاح.',
            backgroundColor: AppColors.successLight,
            colorText: AppColors.success,
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'تعذر السداد',
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
}
