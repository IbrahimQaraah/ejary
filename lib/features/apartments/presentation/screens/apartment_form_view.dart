import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../properties/domain/entities/property.dart';
import '../../domain/entities/apartment.dart';
import '../../domain/entities/apartment_specification.dart';
import '../controllers/apartment_controller.dart';

class ApartmentFormView extends StatefulWidget {
  final Apartment? apartment;
  final ApartmentSpecification? specification;
  final int? preselectedPropertyId;

  const ApartmentFormView({
    super.key,
    this.apartment,
    this.specification,
    this.preselectedPropertyId,
  });

  bool get isEdit => apartment != null;

  @override
  State<ApartmentFormView> createState() => _ApartmentFormViewState();
}

class _ApartmentFormViewState extends State<ApartmentFormView> {
  final _formKey = GlobalKey<FormState>();

  // Apartment Controllers
  late TextEditingController _numberController;
  late TextEditingController _floorController;
  late TextEditingController _areaController;
  late TextEditingController _rentController;
  late TextEditingController _descriptionController;

  // Specification Controllers
  late TextEditingController _bedroomsController;
  late TextEditingController _bathroomsController;
  late TextEditingController _livingRoomsController;
  late TextEditingController _kitchensController;
  late TextEditingController _balconiesController;
  late TextEditingController _additionalFeaturesController;

  late ApartmentStatus _selectedStatus;
  int? _selectedPropertyId;
  late bool _hasAc;
  late bool _hasParking;

  final ApartmentController _controller = Get.find();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final apt = widget.apartment;
    final spec = widget.specification;

    _selectedPropertyId = apt?.propertyId ?? widget.preselectedPropertyId;

    _numberController = TextEditingController(text: apt?.apartmentNumber ?? '');
    _floorController = TextEditingController(
      text: apt != null ? apt.floorNumber.toString() : '1',
    );
    _areaController = TextEditingController(
      text: apt != null ? apt.area.toString() : '120',
    );
    // Rent is stored in minor units (halalas/cents), so divide by 100 for display
    _rentController = TextEditingController(
      text: apt != null ? (apt.monthlyRent / 100).toStringAsFixed(0) : '2500',
    );
    _descriptionController = TextEditingController(
      text: apt?.description ?? '',
    );

    _selectedStatus = apt?.status ?? ApartmentStatus.available;

    // Specifications
    _bedroomsController = TextEditingController(
      text: spec != null ? spec.bedrooms.toString() : '3',
    );
    _bathroomsController = TextEditingController(
      text: spec != null ? spec.bathrooms.toString() : '2',
    );
    _livingRoomsController = TextEditingController(
      text: spec != null ? spec.livingRooms.toString() : '1',
    );
    _kitchensController = TextEditingController(
      text: spec != null ? spec.kitchens.toString() : '1',
    );
    _balconiesController = TextEditingController(
      text: spec != null ? spec.balconies.toString() : '0',
    );
    _additionalFeaturesController = TextEditingController(
      text: spec?.additionalFeatures ?? '',
    );
    _hasAc = spec?.hasAc ?? true;
    _hasParking = spec?.hasParking ?? true;

    // If properties map is empty, ensure properties are loaded
    if (_controller.propertiesMap.isEmpty) {
      _controller.loadAllApartments();
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _floorController.dispose();
    _areaController.dispose();
    _rentController.dispose();
    _descriptionController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _livingRoomsController.dispose();
    _kitchensController.dispose();
    _balconiesController.dispose();
    _additionalFeaturesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEdit ? 'تعديل بيانات الشقة' : 'إضافة شقة جديدة'),
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
            onPressed: _isSaving ? null : _saveApartment,
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
                    widget.isEdit ? 'حفظ التعديلات' : 'إضافة الشقة',
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
              // Section 1: Property and General Info
              const Text(
                'البيانات الأساسية للوحدة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    // Property Selection Dropdown
                    Obx(() {
                      final properties = _controller.propertiesMap.values
                          .toList();

                      // If selected property is not in list yet but preselected is present
                      if (_selectedPropertyId == null &&
                          properties.isNotEmpty) {
                        _selectedPropertyId = properties.first.id;
                      }

                      return DropdownButtonFormField<int>(
                        initialValue: _selectedPropertyId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'العقار التابع له *',
                          prefixIcon: Icon(Icons.apartment),
                        ),
                        items: properties.map((Property p) {
                          return DropdownMenuItem<int>(
                            value: p.id,
                            child: Text(
                              '${p.name} (${p.city} - ${p.district})',
                            ),
                          );
                        }).toList(),
                        onChanged: widget.isEdit
                            ? null // Property cannot be changed after creation
                            : (val) {
                                setState(() {
                                  _selectedPropertyId = val;
                                });
                              },
                        validator: (val) {
                          if (val == null) {
                            return 'يرجى اختيار العقار التابع له هذه الشقة';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 14),

                    // Apartment Number & Floor
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _numberController,
                            decoration: const InputDecoration(
                              labelText: 'رقم الشقة *',
                              hintText: 'مثال: 101 أو A2',
                              prefixIcon: Icon(Icons.tag),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'رقم الشقة مطلوب';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _floorController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'رقم الطابق *',
                              hintText: 'مثال: 1 أو 0',
                              prefixIcon: Icon(Icons.layers_outlined),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'الطابق مطلوب';
                              }
                              if (int.tryParse(val.trim()) == null) {
                                return 'أدخل رقم صحيح';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Area and Rent
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _areaController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'المساحة (م²) *',
                              hintText: '120.5',
                              prefixIcon: Icon(Icons.square_foot),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'المساحة مطلوبة';
                              }
                              final area = double.tryParse(val.trim());
                              if (area == null || area <= 0) {
                                return 'أدخل مساحة موجبة';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
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
                                return 'الإيجار مطلوب';
                              }
                              final rent = int.tryParse(val.trim());
                              if (rent == null || rent <= 0) {
                                return 'أدخل مبلغ صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Apartment Status
                    DropdownButtonFormField<ApartmentStatus>(
                      initialValue: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'حالة الوحدة *',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      items: ApartmentStatus.values.map((status) {
                        return DropdownMenuItem<ApartmentStatus>(
                          value: status,
                          child: Text(status.displayName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedStatus = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Description / Notes
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات وتفاصيل إضافية',
                        hintText: 'مثال: واجهة شمالية مطلة على الحديقة',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section 2: Specifications
              const Text(
                'المواصفات والتجهيزات الداخلية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    // Bedrooms & Bathrooms
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bedroomsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'غرف النوم *',
                              prefixIcon: Icon(Icons.bed_outlined),
                            ),
                            validator: (val) =>
                                _validateCount(val, 'غرف النوم'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _bathroomsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'دورات المياه *',
                              prefixIcon: Icon(Icons.bathtub_outlined),
                            ),
                            validator: (val) =>
                                _validateCount(val, 'دورات المياه'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Living rooms & Kitchens
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _livingRoomsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'الصالات *',
                              prefixIcon: Icon(Icons.weekend_outlined),
                            ),
                            validator: (val) => _validateCount(val, 'الصالات'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _kitchensController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'المطابخ *',
                              prefixIcon: Icon(Icons.kitchen_outlined),
                            ),
                            validator: (val) => _validateCount(val, 'المطابخ'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Balconies
                    TextFormField(
                      controller: _balconiesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'عدد الشرفات (البلكونات) *',
                        prefixIcon: Icon(Icons.deck_outlined),
                      ),
                      validator: (val) => _validateCount(val, 'الشرفات'),
                    ),
                    const SizedBox(height: 14),

                    // AC and Parking Switches
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            activeThumbColor: AppColors.primary,
                            title: const Text(
                              'تكييف راكب ومجهز',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text(
                              'مكيفات سبليت أو مركزية راكبة بالوحدة',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _hasAc,
                            onChanged: (val) => setState(() => _hasAc = val),
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            activeThumbColor: AppColors.primary,
                            title: const Text(
                              'موقف سيارة خاص ومخصص',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text(
                              'موقف سيارة محجوز ومظلل',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _hasParking,
                            onChanged: (val) =>
                                setState(() => _hasParking = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Additional Features
                    TextFormField(
                      controller: _additionalFeaturesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'مميزات إضافية',
                        hintText: 'مثال: مطبخ راكب مع الأجهزة، ستائر كهربائية',
                        prefixIcon: Icon(Icons.stars_outlined),
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

  String? _validateCount(String? val, String fieldName) {
    if (val == null || val.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    final num = int.tryParse(val.trim());
    if (num == null || num < 0) {
      return 'أدخل رقماً صحيحاً موجباً';
    }
    return null;
  }

  Future<void> _saveApartment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPropertyId == null) {
      Get.snackbar(
        'خطأ في التحقق',
        'يرجى تحديد العقار الذي تتبع له هذه الشقة.',
        backgroundColor: AppColors.dangerLight,
        colorText: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSaving = true);

    final rentInRiyal = int.parse(_rentController.text.trim());
    final rentInCents = rentInRiyal * 100; // Minor units (SAR Halalas/Cents)
    final now = DateTime.now();

    final apartment = Apartment(
      id: widget.apartment?.id ?? 0,
      propertyId: _selectedPropertyId!,
      apartmentNumber: _numberController.text.trim(),
      floorNumber: int.parse(_floorController.text.trim()),
      area: double.parse(_areaController.text.trim()),
      monthlyRent: rentInCents,
      status: _selectedStatus,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: widget.apartment?.createdAt ?? now,
      updatedAt: now,
    );

    final spec = ApartmentSpecification(
      id: widget.specification?.id ?? 0,
      apartmentId: widget.apartment?.id ?? 0,
      bedrooms: int.parse(_bedroomsController.text.trim()),
      bathrooms: int.parse(_bathroomsController.text.trim()),
      livingRooms: int.parse(_livingRoomsController.text.trim()),
      kitchens: int.parse(_kitchensController.text.trim()),
      balconies: int.parse(_balconiesController.text.trim()),
      hasAc: _hasAc,
      hasParking: _hasParking,
      additionalFeatures: _additionalFeaturesController.text.trim().isEmpty
          ? null
          : _additionalFeaturesController.text.trim(),
    );

    bool success;
    if (widget.isEdit) {
      success = await _controller.editApartment(
        apartment: apartment,
        specification: spec,
      );
    } else {
      success = await _controller.addApartment(
        apartment: apartment,
        specification: spec,
      );
    }

    setState(() => _isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'تم بنجاح',
        widget.isEdit
            ? 'تم حفظ تعديلات الشقة بنجاح.'
            : 'تمت إضافة الشقة الجديدة ومواصفاتها بنجاح.',
        backgroundColor: AppColors.successLight,
        colorText: AppColors.success,
        icon: const Icon(Icons.check_circle, color: AppColors.success),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'تعذر الحفظ',
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
