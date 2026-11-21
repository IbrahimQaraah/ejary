import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../../../tenants/domain/entities/tenant.dart';
import '../../domain/entities/payment.dart';
import '../controllers/payment_controller.dart';

class RecordPaymentView extends StatefulWidget {
  final int? preselectedApartmentId;
  final int? preselectedTenantId;
  final int? preselectedServiceId;
  final PaymentType? preselectedPaymentType;

  const RecordPaymentView({
    super.key,
    this.preselectedApartmentId,
    this.preselectedTenantId,
    this.preselectedServiceId,
    this.preselectedPaymentType,
  });

  @override
  State<RecordPaymentView> createState() => _RecordPaymentViewState();
}

class _RecordPaymentViewState extends State<RecordPaymentView> {
  final _formKey = GlobalKey<FormState>();

  late PaymentType _selectedPaymentType;
  int? _selectedApartmentId;
  int? _selectedTenantId;
  late PayerResponsibility _selectedPayer;
  late PaymentMethod _selectedMethod;
  late DateTime _paymentDate;

  late TextEditingController _amountController;
  late TextEditingController _periodController;
  late TextEditingController _referenceController;
  late TextEditingController _notesController;

  final PaymentController _controller = Get.find();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedPaymentType = widget.preselectedPaymentType ?? PaymentType.rent;
    _selectedApartmentId = widget.preselectedApartmentId;
    _selectedTenantId = widget.preselectedTenantId;
    _selectedPayer = PayerResponsibility.tenant;
    _selectedMethod = PaymentMethod.bankTransfer;
    _paymentDate = DateTime.now();

    final now = DateTime.now();
    final currentPeriod = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    _amountController = TextEditingController();
    _periodController = TextEditingController(text: currentPeriod);
    _referenceController = TextEditingController();
    _notesController = TextEditingController();

    if (_selectedApartmentId == null && _controller.apartmentsMap.isNotEmpty) {
      _selectedApartmentId = _controller.apartmentsMap.values.first.id;
    }

    _autoSelectTenantAndCalculate();
  }

  void _autoSelectTenantAndCalculate() {
    if (_selectedApartmentId != null) {
      final apt = _controller.apartmentsMap[_selectedApartmentId];
      if (apt != null) {
        // If rent, find tenant
        final tenants = _controller.tenantsMap.values
            .where((t) => t.apartmentId == _selectedApartmentId)
            .toList();
        if (tenants.isNotEmpty && _selectedTenantId == null) {
          final active = tenants.firstWhereOrNull((t) => t.isActive);
          _selectedTenantId = active?.id ?? tenants.first.id;
        }

        if (_selectedTenantId != null &&
            _selectedPaymentType == PaymentType.rent) {
          final tenant = _controller.tenantsMap[_selectedTenantId];
          final rent = tenant?.monthlyRent ?? apt.monthlyRent;
          _controller.fetchRentBalance(
            apartmentId: _selectedApartmentId!,
            tenantId: _selectedTenantId!,
            billingPeriod: _periodController.text.trim(),
            monthlyRent: rent,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _periodController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('تسجيل سند قبض مالي جديد')),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _savePayment,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'تسجيل وحفظ سند القبض',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Payment Type
              const Text(
                'نوع السند المالي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: DropdownButtonFormField<PaymentType>(
                  initialValue: _selectedPaymentType,
                  decoration: const InputDecoration(
                    labelText: 'نوع الدفعة *',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: PaymentType.rent,
                      child: Text('سند إيجار شهري'),
                    ),
                    DropdownMenuItem(
                      value: PaymentType.service,
                      child: Text('سداد فاتورة خدمات'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedPaymentType = val;
                      });
                      _autoSelectTenantAndCalculate();
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Apartment and Tenant
              const Text(
                'الوحدة والمستأجر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  children: [
                    // Apartment Dropdown
                    Obx(() {
                      final apartments = _controller.apartmentsMap.values
                          .toList();
                      return DropdownButtonFormField<int>(
                        initialValue: _selectedApartmentId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'الشقة / الوحدة *',
                          prefixIcon: Icon(Icons.meeting_room_outlined),
                        ),
                        items: apartments.map((Apartment a) {
                          final prop = _controller.propertiesMap[a.propertyId];
                          return DropdownMenuItem<int>(
                            value: a.id,
                            child: Text(
                              '${prop?.name ?? 'عقار'} • شقة ${a.apartmentNumber}',
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedApartmentId = val;
                            _selectedTenantId = null;
                          });
                          _autoSelectTenantAndCalculate();
                        },
                        validator: (val) =>
                            val == null ? 'يرجى اختيار الشقة' : null,
                      );
                    }),
                    const SizedBox(height: 14),

                    // Tenant Dropdown (Required for Rent)
                    Obx(() {
                      final tenants = _controller.tenantsMap.values
                          .where((t) => t.apartmentId == _selectedApartmentId)
                          .toList();

                      return DropdownButtonFormField<int>(
                        initialValue: _selectedTenantId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'المستأجر *',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: tenants.map((Tenant t) {
                          return DropdownMenuItem<int>(
                            value: t.id,
                            child: Text(
                              '${t.fullName} (${t.isActive ? 'عقد نشط' : 'عقد سابق'})',
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedTenantId = val;
                          });
                          _autoSelectTenantAndCalculate();
                        },
                        validator: (val) {
                          if (_selectedPaymentType == PaymentType.rent &&
                              val == null) {
                            return 'يرجى تحديد المستأجر لدفعات الإيجار';
                          }
                          return null;
                        },
                      );
                    }),

                    if (_selectedPaymentType == PaymentType.rent) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _periodController,
                        decoration: const InputDecoration(
                          labelText: 'فترة الاستحقاق (YYYY-MM) *',
                          hintText: '2026-11',
                          prefixIcon: Icon(Icons.calendar_month),
                        ),
                        onChanged: (val) {
                          if (val.trim().length >= 7) {
                            _autoSelectTenantAndCalculate();
                          }
                        },
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'الفترة مطلوبة';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Section 2.5: Outstanding Balance Banner (For Rent)
              if (_selectedPaymentType == PaymentType.rent)
                Obx(() {
                  final bal = _controller.currentRentBalance.value;
                  if (bal == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bal.isFullyPaid
                            ? AppColors.successLight
                            : AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: bal.isFullyPaid
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bal.isFullyPaid
                                    ? 'هذه الفترة مسددة بالكامل'
                                    : 'المبلغ المتبقي للتحصيل:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: bal.isFullyPaid
                                      ? AppColors.success
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(
                                  bal.outstandingBalance,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: bal.isFullyPaid
                                      ? AppColors.success
                                      : AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'إجمالي إيجار الشهر: ${CurrencyFormatter.format(bal.monthlyRent)} • المسدد مسبقاً: ${CurrencyFormatter.format(bal.totalPaid)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),

              // Section 3: Payment Details & Amount
              const Text(
                'تفاصيل الدفع والمبلغ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'المبلغ المدفوع (ر.س) *',
                              hintText: '2500',
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'المبلغ مطلوب';
                              }
                              final amt = int.tryParse(val.trim());
                              if (amt == null || amt <= 0) {
                                return 'أدخل مبلغاً صالحاً';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<PaymentMethod>(
                            isExpanded: true,
                            initialValue: _selectedMethod,
                            decoration: const InputDecoration(
                              labelText: 'طريقة الدفع *',
                              prefixIcon: Icon(Icons.payment),
                            ),
                            items: PaymentMethod.values.map((m) {
                              return DropdownMenuItem<PaymentMethod>(
                                value: m,
                                child: Text(m.displayName),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedMethod = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Payment Date Selector
                    _buildDateSelector(
                      label: 'تاريخ الدفع الفعلي *',
                      date: _paymentDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _paymentDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() => _paymentDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _referenceController,
                      decoration: const InputDecoration(
                        labelText: 'رقم الإيصال / السند الورقي / الحوالة',
                        hintText: 'REC-2026-001',
                        prefixIcon: Icon(Icons.tag),
                      ),
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات وتفاصيل الدفعة',
                        hintText: 'سداد دفعة الإيجار نقداً أو عبر تطبيق البنك',
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedApartmentId == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار الشقة.',
        backgroundColor: AppColors.dangerLight,
        colorText: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSaving = true);

    final amountInRiyal = int.parse(_amountController.text.trim());
    final amountInMinor = amountInRiyal * 100; // Halalas / cents

    final payment = PaymentTransaction(
      id: 0,
      apartmentId: _selectedApartmentId!,
      tenantId: _selectedPaymentType == PaymentType.rent
          ? _selectedTenantId
          : (_selectedTenantId),
      serviceId: null,
      paymentType: _selectedPaymentType,
      amount: amountInMinor,
      dueDate: null,
      paymentDate: _paymentDate,
      paidBy: _selectedPayer,
      paymentMethod: _selectedMethod,
      billingPeriod: _selectedPaymentType == PaymentType.rent
          ? _periodController.text.trim()
          : null,
      referenceNumber: _referenceController.text.trim().isEmpty
          ? null
          : _referenceController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await _controller.makePayment(payment);

    setState(() => _isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'تم تسجيل السند بنجاح',
        'تم تسجيل المقبوضات وتحديث السجل المالي والأرصدة بنجاح.',
        backgroundColor: AppColors.successLight,
        colorText: AppColors.success,
        icon: const Icon(Icons.check_circle, color: AppColors.success),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'تعذر التسجيل',
        _controller.errorMessage.value,
        backgroundColor: AppColors.dangerLight,
        colorText: AppColors.danger,
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
