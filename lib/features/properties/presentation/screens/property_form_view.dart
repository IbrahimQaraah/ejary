import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/property_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/property.dart';
import '../controllers/property_controller.dart';

class PropertyFormView extends StatefulWidget {
  final Property? property;

  const PropertyFormView({super.key, this.property});

  bool get isEdit => property != null;

  @override
  State<PropertyFormView> createState() => _PropertyFormViewState();
}

class _PropertyFormViewState extends State<PropertyFormView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _imagePathController;
  late TextEditingController _floorsController;
  late PropertyType _selectedType;

  final PropertyController _controller = Get.find();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _nameController = TextEditingController(text: p?.name ?? '');
    _cityController = TextEditingController(text: p?.city ?? 'الرياض');
    _districtController = TextEditingController(text: p?.district ?? 'العليا');
    _addressController = TextEditingController(
      text: p?.address ?? 'طريق الملك فهد',
    );
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _imagePathController = TextEditingController(text: p?.imagePath ?? '');
    _floorsController = TextEditingController(
      text: p?.numberOfFloors.toString() ?? '4',
    );
    _selectedType = p?.propertyType ?? PropertyType.residential;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();
    _floorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEdit ? 'تعديل بيانات العقار' : 'إضافة عقار جديد'),
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
            onPressed: _isSaving ? null : _saveProperty,
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
                    widget.isEdit ? 'حفظ التعديلات' : 'إضافة العقار',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Basic Information Card
              const Text(
                'المعلومات الأساسية',
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
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم العقار / المجمع *',
                        hintText: 'مثال: برج النخيل السكني',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم العقار';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Property Type Dropdown
                    DropdownButtonFormField<PropertyType>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'نوع العقار *',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: PropertyType.values.map((type) {
                        return DropdownMenuItem<PropertyType>(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }).toList(),
                      onChanged: (type) {
                        if (type != null) {
                          setState(() {
                            _selectedType = type;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Number of floors
                    TextFormField(
                      controller: _floorsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'عدد الطوابق *',
                        hintText: 'مثال: 5',
                        prefixIcon: Icon(Icons.layers_outlined),
                      ),
                      validator: (value) {
                        final val = int.tryParse(value ?? '');
                        if (val == null || val < 1) {
                          return 'يجب أن يكون عدد الطوابق 1 على الأقل';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Location Information Card
              const Text(
                'الموقع والعنوان',
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'المدينة *',
                              hintText: 'الرياض',
                              prefixIcon: Icon(Icons.location_city_outlined),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'مطلوب'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _districtController,
                            decoration: const InputDecoration(
                              labelText: 'الحي *',
                              hintText: 'الملز',
                              prefixIcon: Icon(Icons.map_outlined),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'مطلوب'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'العنوان التفصيلي *',
                        hintText: 'الشارع ورقم المبنى',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'يرجى إدخال العنوان'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Media & Additional Details Card
              const Text(
                'الوسائط والوصف الإضافي',
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
                    TextFormField(
                      controller: _imagePathController,
                      decoration: const InputDecoration(
                        labelText: 'رابط / مسار صورة العقار',
                        hintText:
                            'https://example.com/property.jpg أو مسار محلي',
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'الوصف وملاحظات العقار',
                        hintText: 'مواصفات إضافية، مميزات الموقع، أو الخدمات القريبة...',
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final name = _nameController.text.trim();
    final city = _cityController.text.trim();
    final district = _districtController.text.trim();
    final address = _addressController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();
    final imagePath = _imagePathController.text.trim().isEmpty
        ? null
        : _imagePathController.text.trim();
    final floors = int.parse(_floorsController.text.trim());

    bool success;
    if (widget.isEdit) {
      final updated = Property(
        id: widget.property!.id,
        name: name,
        propertyType: _selectedType,
        city: city,
        district: district,
        address: address,
        description: description,
        imagePath: imagePath,
        numberOfFloors: floors,
        createdAt: widget.property!.createdAt,
        updatedAt: DateTime.now(),
      );
      success = await _controller.editProperty(updated);
    } else {
      final newProp = Property(
        id: 0,
        name: name,
        propertyType: _selectedType,
        city: city,
        district: district,
        address: address,
        description: description,
        imagePath: imagePath,
        numberOfFloors: floors,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      success = await _controller.addProperty(newProp);
    }

    setState(() {
      _isSaving = false;
    });

    if (success) {
      Get.back();
      Get.snackbar(
        widget.isEdit ? 'تم التعديل' : 'تمت الإضافة',
        widget.isEdit
            ? 'تم تحديث بيانات العقار بنجاح.'
            : 'تمت إضافة العقار الجديد بنجاح.',
        backgroundColor: AppColors.successLight,
        colorText: AppColors.success,
        icon: const Icon(Icons.check_circle, color: AppColors.success),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'خطأ',
        _controller.errorMessage.value.isNotEmpty
            ? _controller.errorMessage.value
            : 'فشلت عملية الحفظ، يرجى المحاولة مرة أخرى.',
        backgroundColor: AppColors.dangerLight,
        colorText: AppColors.danger,
        icon: const Icon(Icons.error_outline, color: AppColors.danger),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
