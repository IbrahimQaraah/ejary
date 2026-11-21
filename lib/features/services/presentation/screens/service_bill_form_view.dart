import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/payer_responsibility.dart';
import '../../../../core/enums/service_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../../domain/entities/service.dart';
import '../controllers/service_bill_controller.dart';

class ServiceBillFormView extends StatefulWidget {
  final int? preselectedApartmentId;

  const ServiceBillFormView({super.key, this.preselectedApartmentId});

  @override
  State<ServiceBillFormView> createState() => _ServiceBillFormViewState();
}

class _ServiceBillFormViewState extends State<ServiceBillFormView> {
  final _formKey = GlobalKey<FormState>();

  late ServiceType _selectedType;
  int? _selectedApartmentId;
  late PayerResponsibility _selectedPayer;
  late DateTime _billingDate;
  late DateTime _dueDate;

  late TextEditingController _totalAmountController;
  late TextEditingController _prevReadingController;
  late TextEditingController _currReadingController;
  late TextEditingController _consumptionController;
  late TextEditingController _notesController;

  final ServiceBillController _controller = Get.find();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedType = ServiceType.electricity;
    _selectedApartmentId = widget.preselectedApartmentId;
    _selectedPayer = PayerResponsibility.tenant;
    final now = DateTime.now();
    _billingDate = now;
    _dueDate = now.add(const Duration(days: 15));

    _totalAmountController = TextEditingController();
    _prevReadingController = TextEditingController();
    _currReadingController = TextEditingController();
    _consumptionController = TextEditingController(text: '0');
    _notesController = TextEditingController();

    if (_selectedApartmentId == null && _controller.apartmentsMap.isNotEmpty) {
      _selectedApartmentId = _controller.apartmentsMap.values.first.id;
    }
  }

  void _calculateConsumption() {
    final prev = double.tryParse(_prevReadingController.text.trim());
    final curr = double.tryParse(_currReadingController.text.trim());
    if (prev != null && curr != null && curr >= prev) {
      final consumption = curr - prev;
      _consumptionController.text = consumption.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _prevReadingController.dispose();
    _currReadingController.dispose();
    _consumptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('إصدار فاتورة خدمة ومرافق جديدة')),
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
            onPressed: _isSaving ? null : _saveBill,
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
                    'إصدار وحفظ الفاتورة',
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
              // Section 1: Type and Unit
              const Text(
                'بيانات الفاتورة والوحدة',
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
                    DropdownButtonFormField<ServiceType>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'نوع الخدمة / المرفق *',
                        prefixIcon: Icon(Icons.bolt),
                      ),
                      items: ServiceType.values.map((t) {
                        return DropdownMenuItem<ServiceType>(
                          value: t,
                          child: Text(t.displayName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Apartment Dropdown
                    Obx(() {
                      final apartments = _controller.apartmentsMap.values
                          .toList();
                      return DropdownButtonFormField<int>(
                        initialValue: _selectedApartmentId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'الشقة / الوحدة التابعة *',
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
                        onChanged: (val) =>
                            setState(() => _selectedApartmentId = val),
                        validator: (val) =>
                            val == null ? 'يرجى اختيار الشقة' : null,
                      );
                    }),
                    const SizedBox(height: 14),

                    // Payer Responsibility
                    DropdownButtonFormField<PayerResponsibility>(
                      initialValue: _selectedPayer,
                      decoration: const InputDecoration(
                        labelText: 'المسؤول عن السداد *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: PayerResponsibility.values.map((p) {
                        return DropdownMenuItem<PayerResponsibility>(
                          value: p,
                          child: Text(p.displayName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPayer = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Amounts and Readings
              const Text(
                'القيمة المالية وقراءات العداد',
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
                    TextFormField(
                      controller: _totalAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'المبلغ الإجمالي للفاتورة (ر.س) *',
                        hintText: '350',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'قيمة الفاتورة مطلوبة';
                        }
                        final amt = int.tryParse(val.trim());
                        if (amt == null || amt <= 0) {
                          return 'أدخل مبلغاً صالحاً';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prevReadingController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'القراءة السابقة',
                              hintText: '1240.0',
                              prefixIcon: Icon(Icons.speed),
                            ),
                            onChanged: (_) => _calculateConsumption(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _currReadingController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'القراءة الحالية',
                              hintText: '1450.0',
                              prefixIcon: Icon(Icons.speed_outlined),
                            ),
                            onChanged: (_) => _calculateConsumption(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _consumptionController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'كمية الاستهلاك المحسوبة',
                        hintText: '210.0',
                        prefixIcon: Icon(Icons.analytics_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: Dates and Notes
              const Text(
                'التواريخ والملاحظات',
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
                          child: _buildDateSelector(
                            label: 'تاريخ الفاتورة *',
                            date: _billingDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _billingDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null) {
                                setState(() => _billingDate = picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateSelector(
                            label: 'تاريخ الاستحقاق *',
                            date: _dueDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _dueDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null) {
                                setState(() => _dueDate = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات ورقم حساب العداد',
                        hintText: 'رقم حساب سداد: 10023456789',
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
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBill() async {
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

    final amountInRiyal = int.parse(_totalAmountController.text.trim());
    final amountInMinor = amountInRiyal * 100;

    final prev = double.tryParse(_prevReadingController.text.trim());
    final curr = double.tryParse(_currReadingController.text.trim());
    final consumption =
        double.tryParse(_consumptionController.text.trim()) ?? 0.0;

    final bill = ServiceBill(
      id: 0,
      apartmentId: _selectedApartmentId!,
      serviceType: _selectedType,
      previousReading: prev,
      currentReading: curr,
      consumption: consumption,
      unitPrice: 0,
      totalAmount: amountInMinor,
      billingDate: _billingDate,
      dueDate: _dueDate,
      payerResponsibility: _selectedPayer,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await _controller.addServiceBill(bill);

    setState(() => _isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'تم بنجاح',
        'تم إصدار فاتورة الخدمة بنجاح.',
        backgroundColor: AppColors.successLight,
        colorText: AppColors.success,
        icon: const Icon(Icons.check_circle, color: AppColors.success),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'تعذر الإصدار',
        _controller.errorMessage.value,
        backgroundColor: AppColors.dangerLight,
        colorText: AppColors.danger,
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
