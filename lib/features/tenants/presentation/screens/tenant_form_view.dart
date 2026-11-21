import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../apartments/domain/entities/apartment.dart';
import '../../domain/entities/tenant.dart';
import '../controllers/tenant_controller.dart';

class TenantFormView extends StatefulWidget {
  final Tenant? tenant;
  final int? preselectedApartmentId;

  const TenantFormView({super.key, this.tenant, this.preselectedApartmentId});

  bool get isEdit => tenant != null;

  @override
  State<TenantFormView> createState() => _TenantFormViewState();
}

class _TenantFormViewState extends State<TenantFormView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _nationalIdController;
  late TextEditingController _addressController;
  late TextEditingController _rentController;
  late TextEditingController _depositController;
  late TextEditingController _dueDayController;
  late TextEditingController _notesController;

  int? _selectedApartmentId;
  late DateTime _contractStartDate;
  late DateTime _contractEndDate;
  late DateTime _moveInDate;

  final TenantController _controller = Get.find();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.tenant;

    _selectedApartmentId = t?.apartmentId ?? widget.preselectedApartmentId;

    _nameController = TextEditingController(text: t?.fullName ?? '');
    _phoneController = TextEditingController(text: t?.phone ?? '');
    _nationalIdController = TextEditingController(text: t?.nationalId ?? '');
    _addressController = TextEditingController(text: t?.address ?? 'الرياض');

    // Rent in minor units -> divide by 100 for display
    _rentController = TextEditingController(
      text: t != null ? (t.monthlyRent / 100).toStringAsFixed(0) : '',
    );

    _depositController = TextEditingController(
      text: t != null ? (t.depositAmount / 100).toStringAsFixed(0) : '1000',
    );

    _dueDayController = TextEditingController(
      text: t?.paymentDueDay.toString() ?? '1',
    );

    _notesController = TextEditingController(text: t?.notes ?? '');

    final now = DateTime.now();
    _contractStartDate = t?.contractStartDate ?? now;
    _contractEndDate = t?.contractEndDate ?? now.add(const Duration(days: 365));
    _moveInDate = t?.moveInDate ?? now;

    // If preselected apartment has rent and rent controller is empty, prefill rent
    if (_rentController.text.isEmpty && _selectedApartmentId != null) {
      final apt = _controller.apartmentsMap[_selectedApartmentId];
      if (apt != null) {
        _rentController.text = (apt.monthlyRent / 100).toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _dueDayController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'تعديل بيانات المستأجر' : 'تسجيل مستأجر جديد',
        ),
      ),
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
            onPressed: _isSaving ? null : _saveTenant,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.isEdit ? 'حفظ التعديلات' : 'تسجيل وتسكين المستأجر',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
              // Section 1: Apartment Assignment
              const Text(
                'الوحدة السكنية المؤجرة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                child: Obx(() {
                  final apartments = _controller.apartmentsMap.values.toList();
                  // When adding, show available apartments (or currently assigned)
                  final eligibleApartments = apartments.where((a) {
                    if (widget.isEdit) {
                      return a.id == widget.tenant!.apartmentId;
                    }
                    return a.status == ApartmentStatus.available ||
                        a.id == _selectedApartmentId;
                  }).toList();

                  if (_selectedApartmentId == null &&
                      eligibleApartments.isNotEmpty) {
                    _selectedApartmentId = eligibleApartments.first.id;
                    if (_rentController.text.isEmpty) {
                      _rentController.text =
                          (eligibleApartments.first.monthlyRent / 100)
                              .toStringAsFixed(0);
                    }
                  }

                  return DropdownButtonFormField<int>(
                    initialValue: _selectedApartmentId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'اختر الشقة / الوحدة *',
                      prefixIcon: Icon(Icons.meeting_room_outlined),
                    ),
                    items: eligibleApartments.map((Apartment a) {
                      final prop = _controller.propertiesMap[a.propertyId];
                      return DropdownMenuItem<int>(
                        value: a.id,
                        child: Text(
                          '${prop?.name ?? 'عقار'} • شقة رقم ${a.apartmentNumber} (طابق ${a.floorNumber})',
                        ),
                      );
                    }).toList(),
                    onChanged: widget.isEdit
                        ? null // Apartment cannot be transferred after contract inception
                        : (val) {
                            setState(() {
                              _selectedApartmentId = val;
                              if (val != null) {
                                final apt = _controller.apartmentsMap[val];
                                if (apt != null) {
                                  _rentController.text = (apt.monthlyRent / 100)
                                      .toStringAsFixed(0);
                                }
                              }
                            });
                          },
                    validator: (val) {
                      if (val == null) {
                        return 'يرجى اختيار الشقة المراد تأجيرها';
                      }
                      return null;
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Section 2: Personal Information
              const Text(
                'البيانات الشخصية للمستأجر',
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل / الرباعي *',
                        hintText: 'مثال: عبدالله محمد بن علي',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'الاسم الكامل مطلوب';
                        }
                        if (val.trim().length < 3) {
                          return 'أدخل الاسم الرباعي بشكل صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'رقم الجوال *',
                              hintText: '05XXXXXXXX',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'رقم الجوال مطلوب';
                              }
                              if (val.trim().length < 9) {
                                return 'رقم جوال غير صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _nationalIdController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهوية / الإقامة *',
                              hintText: '10XXXXXXXX',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'رقم الهوية مطلوب';
                              }
                              if (val.trim().length < 7) {
                                return 'رقم الهوية غير صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'العنوان الدائم / جهة العمل *',
                        hintText: 'الرياض - حي الملز',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'العنوان مطلوب';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section 3: Financial & Contract Terms
              const Text(
                'شروط العقد والالتزامات المالية',
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
                            controller: _rentController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'الإيجار الشهري (ر.س) *',
                              hintText: '2500',
                              prefixIcon: Icon(Icons.payments_outlined),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'قيمة الإيجار مطلوبة';
                              }
                              final rent = int.tryParse(val.trim());
                              if (rent == null || rent <= 0) {
                                return 'مبلغ غير صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _depositController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'مبلغ التأمين (ر.س) *',
                              hintText: '1000',
                              prefixIcon: Icon(Icons.security_outlined),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'مبلغ التأمين مطلوب';
                              }
                              final dep = int.tryParse(val.trim());
                              if (dep == null || dep < 0) {
                                return 'مبلغ غير صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Contract Dates Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateSelector(
                            label: 'بداية العقد *',
                            date: _contractStartDate,
                            onTap: () => _pickDate(
                              current: _contractStartDate,
                              onPicked: (d) =>
                                  setState(() => _contractStartDate = d),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateSelector(
                            label: 'نهاية العقد *',
                            date: _contractEndDate,
                            onTap: () => _pickDate(
                              current: _contractEndDate,
                              onPicked: (d) =>
                                  setState(() => _contractEndDate = d),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dueDayController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'يوم الاستحقاق الشهري (1-31) *',
                              hintText: '1',
                              prefixIcon: Icon(Icons.event_repeat),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'يوم الاستحقاق مطلوب';
                              }
                              final day = int.tryParse(val.trim());
                              if (day == null || day < 1 || day > 31) {
                                return 'بين 1 و 31';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateSelector(
                            label: 'تاريخ السكن الفعلي *',
                            date: _moveInDate,
                            onTap: () => _pickDate(
                              current: _moveInDate,
                              onPicked: (d) => setState(() => _moveInDate = d),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات وشروط خاصة',
                        hintText: 'مثال: يتكفل المستأجر بفاتورة الكهرباء',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
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
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate({
    required DateTime current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  Future<void> _saveTenant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedApartmentId == null) {
      Get.snackbar(
        'خطأ في التحقق',
        'يرجى تحديد الشقة المراد تسكين المستأجر بها.',
        backgroundColor: AppColors.dangerLight,
        colorText: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSaving = true);

    final rentInRiyal = int.parse(_rentController.text.trim());
    final depositInRiyal = int.parse(_depositController.text.trim());
    final now = DateTime.now();

    final tenant = Tenant(
      id: widget.tenant?.id ?? 0,
      apartmentId: _selectedApartmentId!,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      address: _addressController.text.trim(),
      monthlyRent: rentInRiyal * 100, // Halalas / cents
      depositAmount: depositInRiyal * 100,
      contractStartDate: _contractStartDate,
      contractEndDate: _contractEndDate,
      paymentDueDay: int.parse(_dueDayController.text.trim()),
      moveInDate: _moveInDate,
      moveOutDate: widget.tenant?.moveOutDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.tenant?.createdAt ?? now,
      updatedAt: now,
    );

    bool success;
    if (widget.isEdit) {
      success = await _controller.updateTenant(tenant);
    } else {
      success = await _controller.registerTenant(tenant);
    }

    setState(() => _isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'تم بنجاح',
        widget.isEdit
            ? 'تم حفظ تعديلات المستأجر بنجاح.'
            : 'تم تسجيل المستأجر وتحديث حالة الشقة إلى مشغولة بنجاح.',
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
