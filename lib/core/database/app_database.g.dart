// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, PropertyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PropertyType, String>
  propertyType = GeneratedColumn<String>(
    'property_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PropertyType>($PropertiesTable.$converterpropertyType);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numberOfFloorsMeta = const VerificationMeta(
    'numberOfFloors',
  );
  @override
  late final GeneratedColumn<int> numberOfFloors = GeneratedColumn<int>(
    'number_of_floors',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    propertyType,
    city,
    district,
    address,
    description,
    imagePath,
    numberOfFloors,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<PropertyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    } else if (isInserting) {
      context.missing(_districtMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('number_of_floors')) {
      context.handle(
        _numberOfFloorsMeta,
        numberOfFloors.isAcceptableOrUnknown(
          data['number_of_floors']!,
          _numberOfFloorsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numberOfFloorsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      propertyType: $PropertiesTable.$converterpropertyType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}property_type'],
        )!,
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      numberOfFloors: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number_of_floors'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PropertyType, String, String>
  $converterpropertyType = const EnumNameConverter<PropertyType>(
    PropertyType.values,
  );
}

class PropertyEntry extends DataClass implements Insertable<PropertyEntry> {
  final int id;
  final String name;
  final PropertyType propertyType;
  final String city;
  final String district;
  final String address;
  final String? description;
  final String? imagePath;
  final int numberOfFloors;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PropertyEntry({
    required this.id,
    required this.name,
    required this.propertyType,
    required this.city,
    required this.district,
    required this.address,
    this.description,
    this.imagePath,
    required this.numberOfFloors,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['property_type'] = Variable<String>(
        $PropertiesTable.$converterpropertyType.toSql(propertyType),
      );
    }
    map['city'] = Variable<String>(city);
    map['district'] = Variable<String>(district);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['number_of_floors'] = Variable<int>(numberOfFloors);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PropertiesCompanion toCompanion(bool nullToAbsent) {
    return PropertiesCompanion(
      id: Value(id),
      name: Value(name),
      propertyType: Value(propertyType),
      city: Value(city),
      district: Value(district),
      address: Value(address),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      numberOfFloors: Value(numberOfFloors),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PropertyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      propertyType: $PropertiesTable.$converterpropertyType.fromJson(
        serializer.fromJson<String>(json['propertyType']),
      ),
      city: serializer.fromJson<String>(json['city']),
      district: serializer.fromJson<String>(json['district']),
      address: serializer.fromJson<String>(json['address']),
      description: serializer.fromJson<String?>(json['description']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      numberOfFloors: serializer.fromJson<int>(json['numberOfFloors']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'propertyType': serializer.toJson<String>(
        $PropertiesTable.$converterpropertyType.toJson(propertyType),
      ),
      'city': serializer.toJson<String>(city),
      'district': serializer.toJson<String>(district),
      'address': serializer.toJson<String>(address),
      'description': serializer.toJson<String?>(description),
      'imagePath': serializer.toJson<String?>(imagePath),
      'numberOfFloors': serializer.toJson<int>(numberOfFloors),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PropertyEntry copyWith({
    int? id,
    String? name,
    PropertyType? propertyType,
    String? city,
    String? district,
    String? address,
    Value<String?> description = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    int? numberOfFloors,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PropertyEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    propertyType: propertyType ?? this.propertyType,
    city: city ?? this.city,
    district: district ?? this.district,
    address: address ?? this.address,
    description: description.present ? description.value : this.description,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    numberOfFloors: numberOfFloors ?? this.numberOfFloors,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PropertyEntry copyWithCompanion(PropertiesCompanion data) {
    return PropertyEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      propertyType: data.propertyType.present
          ? data.propertyType.value
          : this.propertyType,
      city: data.city.present ? data.city.value : this.city,
      district: data.district.present ? data.district.value : this.district,
      address: data.address.present ? data.address.value : this.address,
      description: data.description.present
          ? data.description.value
          : this.description,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      numberOfFloors: data.numberOfFloors.present
          ? data.numberOfFloors.value
          : this.numberOfFloors,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('propertyType: $propertyType, ')
          ..write('city: $city, ')
          ..write('district: $district, ')
          ..write('address: $address, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('numberOfFloors: $numberOfFloors, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    propertyType,
    city,
    district,
    address,
    description,
    imagePath,
    numberOfFloors,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.propertyType == this.propertyType &&
          other.city == this.city &&
          other.district == this.district &&
          other.address == this.address &&
          other.description == this.description &&
          other.imagePath == this.imagePath &&
          other.numberOfFloors == this.numberOfFloors &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PropertiesCompanion extends UpdateCompanion<PropertyEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<PropertyType> propertyType;
  final Value<String> city;
  final Value<String> district;
  final Value<String> address;
  final Value<String?> description;
  final Value<String?> imagePath;
  final Value<int> numberOfFloors;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.propertyType = const Value.absent(),
    this.city = const Value.absent(),
    this.district = const Value.absent(),
    this.address = const Value.absent(),
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.numberOfFloors = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PropertiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PropertyType propertyType,
    required String city,
    required String district,
    required String address,
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    required int numberOfFloors,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       propertyType = Value(propertyType),
       city = Value(city),
       district = Value(district),
       address = Value(address),
       numberOfFloors = Value(numberOfFloors),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PropertyEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? propertyType,
    Expression<String>? city,
    Expression<String>? district,
    Expression<String>? address,
    Expression<String>? description,
    Expression<String>? imagePath,
    Expression<int>? numberOfFloors,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (propertyType != null) 'property_type': propertyType,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (address != null) 'address': address,
      if (description != null) 'description': description,
      if (imagePath != null) 'image_path': imagePath,
      if (numberOfFloors != null) 'number_of_floors': numberOfFloors,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PropertiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<PropertyType>? propertyType,
    Value<String>? city,
    Value<String>? district,
    Value<String>? address,
    Value<String?>? description,
    Value<String?>? imagePath,
    Value<int>? numberOfFloors,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      propertyType: propertyType ?? this.propertyType,
      city: city ?? this.city,
      district: district ?? this.district,
      address: address ?? this.address,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      numberOfFloors: numberOfFloors ?? this.numberOfFloors,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (propertyType.present) {
      map['property_type'] = Variable<String>(
        $PropertiesTable.$converterpropertyType.toSql(propertyType.value),
      );
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (numberOfFloors.present) {
      map['number_of_floors'] = Variable<int>(numberOfFloors.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('propertyType: $propertyType, ')
          ..write('city: $city, ')
          ..write('district: $district, ')
          ..write('address: $address, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('numberOfFloors: $numberOfFloors, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ApartmentsTable extends Apartments
    with TableInfo<$ApartmentsTable, ApartmentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<int> propertyId = GeneratedColumn<int>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _apartmentNumberMeta = const VerificationMeta(
    'apartmentNumber',
  );
  @override
  late final GeneratedColumn<String> apartmentNumber = GeneratedColumn<String>(
    'apartment_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _floorNumberMeta = const VerificationMeta(
    'floorNumber',
  );
  @override
  late final GeneratedColumn<int> floorNumber = GeneratedColumn<int>(
    'floor_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<double> area = GeneratedColumn<double>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyRentMeta = const VerificationMeta(
    'monthlyRent',
  );
  @override
  late final GeneratedColumn<int> monthlyRent = GeneratedColumn<int>(
    'monthly_rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ApartmentStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ApartmentStatus>($ApartmentsTable.$converterstatus);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    apartmentNumber,
    floorNumber,
    area,
    monthlyRent,
    status,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apartments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApartmentEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('apartment_number')) {
      context.handle(
        _apartmentNumberMeta,
        apartmentNumber.isAcceptableOrUnknown(
          data['apartment_number']!,
          _apartmentNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentNumberMeta);
    }
    if (data.containsKey('floor_number')) {
      context.handle(
        _floorNumberMeta,
        floorNumber.isAcceptableOrUnknown(
          data['floor_number']!,
          _floorNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_floorNumberMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('monthly_rent')) {
      context.handle(
        _monthlyRentMeta,
        monthlyRent.isAcceptableOrUnknown(
          data['monthly_rent']!,
          _monthlyRentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyRentMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {propertyId, apartmentNumber},
  ];
  @override
  ApartmentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApartmentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}property_id'],
      )!,
      apartmentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apartment_number'],
      )!,
      floorNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor_number'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area'],
      )!,
      monthlyRent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_rent'],
      )!,
      status: $ApartmentsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ApartmentsTable createAlias(String alias) {
    return $ApartmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ApartmentStatus, String, String> $converterstatus =
      const EnumNameConverter<ApartmentStatus>(ApartmentStatus.values);
}

class ApartmentEntry extends DataClass implements Insertable<ApartmentEntry> {
  final int id;
  final int propertyId;
  final String apartmentNumber;
  final int floorNumber;
  final double area;
  final int monthlyRent;
  final ApartmentStatus status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ApartmentEntry({
    required this.id,
    required this.propertyId,
    required this.apartmentNumber,
    required this.floorNumber,
    required this.area,
    required this.monthlyRent,
    required this.status,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['property_id'] = Variable<int>(propertyId);
    map['apartment_number'] = Variable<String>(apartmentNumber);
    map['floor_number'] = Variable<int>(floorNumber);
    map['area'] = Variable<double>(area);
    map['monthly_rent'] = Variable<int>(monthlyRent);
    {
      map['status'] = Variable<String>(
        $ApartmentsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ApartmentsCompanion toCompanion(bool nullToAbsent) {
    return ApartmentsCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      apartmentNumber: Value(apartmentNumber),
      floorNumber: Value(floorNumber),
      area: Value(area),
      monthlyRent: Value(monthlyRent),
      status: Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ApartmentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApartmentEntry(
      id: serializer.fromJson<int>(json['id']),
      propertyId: serializer.fromJson<int>(json['propertyId']),
      apartmentNumber: serializer.fromJson<String>(json['apartmentNumber']),
      floorNumber: serializer.fromJson<int>(json['floorNumber']),
      area: serializer.fromJson<double>(json['area']),
      monthlyRent: serializer.fromJson<int>(json['monthlyRent']),
      status: $ApartmentsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'propertyId': serializer.toJson<int>(propertyId),
      'apartmentNumber': serializer.toJson<String>(apartmentNumber),
      'floorNumber': serializer.toJson<int>(floorNumber),
      'area': serializer.toJson<double>(area),
      'monthlyRent': serializer.toJson<int>(monthlyRent),
      'status': serializer.toJson<String>(
        $ApartmentsTable.$converterstatus.toJson(status),
      ),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ApartmentEntry copyWith({
    int? id,
    int? propertyId,
    String? apartmentNumber,
    int? floorNumber,
    double? area,
    int? monthlyRent,
    ApartmentStatus? status,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ApartmentEntry(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    apartmentNumber: apartmentNumber ?? this.apartmentNumber,
    floorNumber: floorNumber ?? this.floorNumber,
    area: area ?? this.area,
    monthlyRent: monthlyRent ?? this.monthlyRent,
    status: status ?? this.status,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ApartmentEntry copyWithCompanion(ApartmentsCompanion data) {
    return ApartmentEntry(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      apartmentNumber: data.apartmentNumber.present
          ? data.apartmentNumber.value
          : this.apartmentNumber,
      floorNumber: data.floorNumber.present
          ? data.floorNumber.value
          : this.floorNumber,
      area: data.area.present ? data.area.value : this.area,
      monthlyRent: data.monthlyRent.present
          ? data.monthlyRent.value
          : this.monthlyRent,
      status: data.status.present ? data.status.value : this.status,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApartmentEntry(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('apartmentNumber: $apartmentNumber, ')
          ..write('floorNumber: $floorNumber, ')
          ..write('area: $area, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propertyId,
    apartmentNumber,
    floorNumber,
    area,
    monthlyRent,
    status,
    description,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApartmentEntry &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.apartmentNumber == this.apartmentNumber &&
          other.floorNumber == this.floorNumber &&
          other.area == this.area &&
          other.monthlyRent == this.monthlyRent &&
          other.status == this.status &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ApartmentsCompanion extends UpdateCompanion<ApartmentEntry> {
  final Value<int> id;
  final Value<int> propertyId;
  final Value<String> apartmentNumber;
  final Value<int> floorNumber;
  final Value<double> area;
  final Value<int> monthlyRent;
  final Value<ApartmentStatus> status;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ApartmentsCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.apartmentNumber = const Value.absent(),
    this.floorNumber = const Value.absent(),
    this.area = const Value.absent(),
    this.monthlyRent = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ApartmentsCompanion.insert({
    this.id = const Value.absent(),
    required int propertyId,
    required String apartmentNumber,
    required int floorNumber,
    required double area,
    required int monthlyRent,
    required ApartmentStatus status,
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : propertyId = Value(propertyId),
       apartmentNumber = Value(apartmentNumber),
       floorNumber = Value(floorNumber),
       area = Value(area),
       monthlyRent = Value(monthlyRent),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ApartmentEntry> custom({
    Expression<int>? id,
    Expression<int>? propertyId,
    Expression<String>? apartmentNumber,
    Expression<int>? floorNumber,
    Expression<double>? area,
    Expression<int>? monthlyRent,
    Expression<String>? status,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (apartmentNumber != null) 'apartment_number': apartmentNumber,
      if (floorNumber != null) 'floor_number': floorNumber,
      if (area != null) 'area': area,
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ApartmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? propertyId,
    Value<String>? apartmentNumber,
    Value<int>? floorNumber,
    Value<double>? area,
    Value<int>? monthlyRent,
    Value<ApartmentStatus>? status,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ApartmentsCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      floorNumber: floorNumber ?? this.floorNumber,
      area: area ?? this.area,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<int>(propertyId.value);
    }
    if (apartmentNumber.present) {
      map['apartment_number'] = Variable<String>(apartmentNumber.value);
    }
    if (floorNumber.present) {
      map['floor_number'] = Variable<int>(floorNumber.value);
    }
    if (area.present) {
      map['area'] = Variable<double>(area.value);
    }
    if (monthlyRent.present) {
      map['monthly_rent'] = Variable<int>(monthlyRent.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ApartmentsTable.$converterstatus.toSql(status.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApartmentsCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('apartmentNumber: $apartmentNumber, ')
          ..write('floorNumber: $floorNumber, ')
          ..write('area: $area, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TenantsTable extends Tenants with TableInfo<$TenantsTable, TenantEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apartmentIdMeta = const VerificationMeta(
    'apartmentId',
  );
  @override
  late final GeneratedColumn<int> apartmentId = GeneratedColumn<int>(
    'apartment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apartments (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nationalIdMeta = const VerificationMeta(
    'nationalId',
  );
  @override
  late final GeneratedColumn<String> nationalId = GeneratedColumn<String>(
    'national_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyRentMeta = const VerificationMeta(
    'monthlyRent',
  );
  @override
  late final GeneratedColumn<int> monthlyRent = GeneratedColumn<int>(
    'monthly_rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositAmountMeta = const VerificationMeta(
    'depositAmount',
  );
  @override
  late final GeneratedColumn<int> depositAmount = GeneratedColumn<int>(
    'deposit_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _contractStartDateMeta = const VerificationMeta(
    'contractStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> contractStartDate =
      GeneratedColumn<DateTime>(
        'contract_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _contractEndDateMeta = const VerificationMeta(
    'contractEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> contractEndDate =
      GeneratedColumn<DateTime>(
        'contract_end_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _paymentDueDayMeta = const VerificationMeta(
    'paymentDueDay',
  );
  @override
  late final GeneratedColumn<int> paymentDueDay = GeneratedColumn<int>(
    'payment_due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moveInDateMeta = const VerificationMeta(
    'moveInDate',
  );
  @override
  late final GeneratedColumn<DateTime> moveInDate = GeneratedColumn<DateTime>(
    'move_in_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moveOutDateMeta = const VerificationMeta(
    'moveOutDate',
  );
  @override
  late final GeneratedColumn<DateTime> moveOutDate = GeneratedColumn<DateTime>(
    'move_out_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apartmentId,
    fullName,
    phone,
    nationalId,
    address,
    monthlyRent,
    depositAmount,
    contractStartDate,
    contractEndDate,
    paymentDueDay,
    moveInDate,
    moveOutDate,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(
    Insertable<TenantEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('apartment_id')) {
      context.handle(
        _apartmentIdMeta,
        apartmentId.isAcceptableOrUnknown(
          data['apartment_id']!,
          _apartmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('national_id')) {
      context.handle(
        _nationalIdMeta,
        nationalId.isAcceptableOrUnknown(data['national_id']!, _nationalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationalIdMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('monthly_rent')) {
      context.handle(
        _monthlyRentMeta,
        monthlyRent.isAcceptableOrUnknown(
          data['monthly_rent']!,
          _monthlyRentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyRentMeta);
    }
    if (data.containsKey('deposit_amount')) {
      context.handle(
        _depositAmountMeta,
        depositAmount.isAcceptableOrUnknown(
          data['deposit_amount']!,
          _depositAmountMeta,
        ),
      );
    }
    if (data.containsKey('contract_start_date')) {
      context.handle(
        _contractStartDateMeta,
        contractStartDate.isAcceptableOrUnknown(
          data['contract_start_date']!,
          _contractStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractStartDateMeta);
    }
    if (data.containsKey('contract_end_date')) {
      context.handle(
        _contractEndDateMeta,
        contractEndDate.isAcceptableOrUnknown(
          data['contract_end_date']!,
          _contractEndDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractEndDateMeta);
    }
    if (data.containsKey('payment_due_day')) {
      context.handle(
        _paymentDueDayMeta,
        paymentDueDay.isAcceptableOrUnknown(
          data['payment_due_day']!,
          _paymentDueDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDueDayMeta);
    }
    if (data.containsKey('move_in_date')) {
      context.handle(
        _moveInDateMeta,
        moveInDate.isAcceptableOrUnknown(
          data['move_in_date']!,
          _moveInDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moveInDateMeta);
    }
    if (data.containsKey('move_out_date')) {
      context.handle(
        _moveOutDateMeta,
        moveOutDate.isAcceptableOrUnknown(
          data['move_out_date']!,
          _moveOutDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {id, apartmentId},
  ];
  @override
  TenantEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apartment_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      nationalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}national_id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      monthlyRent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_rent'],
      )!,
      depositAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit_amount'],
      )!,
      contractStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}contract_start_date'],
      )!,
      contractEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}contract_end_date'],
      )!,
      paymentDueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_due_day'],
      )!,
      moveInDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}move_in_date'],
      )!,
      moveOutDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}move_out_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class TenantEntry extends DataClass implements Insertable<TenantEntry> {
  final int id;
  final int apartmentId;
  final String fullName;
  final String phone;
  final String nationalId;
  final String address;
  final int monthlyRent;
  final int depositAmount;
  final DateTime contractStartDate;
  final DateTime contractEndDate;
  final int paymentDueDay;
  final DateTime moveInDate;
  final DateTime? moveOutDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TenantEntry({
    required this.id,
    required this.apartmentId,
    required this.fullName,
    required this.phone,
    required this.nationalId,
    required this.address,
    required this.monthlyRent,
    required this.depositAmount,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.paymentDueDay,
    required this.moveInDate,
    this.moveOutDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['apartment_id'] = Variable<int>(apartmentId);
    map['full_name'] = Variable<String>(fullName);
    map['phone'] = Variable<String>(phone);
    map['national_id'] = Variable<String>(nationalId);
    map['address'] = Variable<String>(address);
    map['monthly_rent'] = Variable<int>(monthlyRent);
    map['deposit_amount'] = Variable<int>(depositAmount);
    map['contract_start_date'] = Variable<DateTime>(contractStartDate);
    map['contract_end_date'] = Variable<DateTime>(contractEndDate);
    map['payment_due_day'] = Variable<int>(paymentDueDay);
    map['move_in_date'] = Variable<DateTime>(moveInDate);
    if (!nullToAbsent || moveOutDate != null) {
      map['move_out_date'] = Variable<DateTime>(moveOutDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TenantsCompanion toCompanion(bool nullToAbsent) {
    return TenantsCompanion(
      id: Value(id),
      apartmentId: Value(apartmentId),
      fullName: Value(fullName),
      phone: Value(phone),
      nationalId: Value(nationalId),
      address: Value(address),
      monthlyRent: Value(monthlyRent),
      depositAmount: Value(depositAmount),
      contractStartDate: Value(contractStartDate),
      contractEndDate: Value(contractEndDate),
      paymentDueDay: Value(paymentDueDay),
      moveInDate: Value(moveInDate),
      moveOutDate: moveOutDate == null && nullToAbsent
          ? const Value.absent()
          : Value(moveOutDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TenantEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantEntry(
      id: serializer.fromJson<int>(json['id']),
      apartmentId: serializer.fromJson<int>(json['apartmentId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String>(json['phone']),
      nationalId: serializer.fromJson<String>(json['nationalId']),
      address: serializer.fromJson<String>(json['address']),
      monthlyRent: serializer.fromJson<int>(json['monthlyRent']),
      depositAmount: serializer.fromJson<int>(json['depositAmount']),
      contractStartDate: serializer.fromJson<DateTime>(
        json['contractStartDate'],
      ),
      contractEndDate: serializer.fromJson<DateTime>(json['contractEndDate']),
      paymentDueDay: serializer.fromJson<int>(json['paymentDueDay']),
      moveInDate: serializer.fromJson<DateTime>(json['moveInDate']),
      moveOutDate: serializer.fromJson<DateTime?>(json['moveOutDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apartmentId': serializer.toJson<int>(apartmentId),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String>(phone),
      'nationalId': serializer.toJson<String>(nationalId),
      'address': serializer.toJson<String>(address),
      'monthlyRent': serializer.toJson<int>(monthlyRent),
      'depositAmount': serializer.toJson<int>(depositAmount),
      'contractStartDate': serializer.toJson<DateTime>(contractStartDate),
      'contractEndDate': serializer.toJson<DateTime>(contractEndDate),
      'paymentDueDay': serializer.toJson<int>(paymentDueDay),
      'moveInDate': serializer.toJson<DateTime>(moveInDate),
      'moveOutDate': serializer.toJson<DateTime?>(moveOutDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TenantEntry copyWith({
    int? id,
    int? apartmentId,
    String? fullName,
    String? phone,
    String? nationalId,
    String? address,
    int? monthlyRent,
    int? depositAmount,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    int? paymentDueDay,
    DateTime? moveInDate,
    Value<DateTime?> moveOutDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TenantEntry(
    id: id ?? this.id,
    apartmentId: apartmentId ?? this.apartmentId,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    nationalId: nationalId ?? this.nationalId,
    address: address ?? this.address,
    monthlyRent: monthlyRent ?? this.monthlyRent,
    depositAmount: depositAmount ?? this.depositAmount,
    contractStartDate: contractStartDate ?? this.contractStartDate,
    contractEndDate: contractEndDate ?? this.contractEndDate,
    paymentDueDay: paymentDueDay ?? this.paymentDueDay,
    moveInDate: moveInDate ?? this.moveInDate,
    moveOutDate: moveOutDate.present ? moveOutDate.value : this.moveOutDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TenantEntry copyWithCompanion(TenantsCompanion data) {
    return TenantEntry(
      id: data.id.present ? data.id.value : this.id,
      apartmentId: data.apartmentId.present
          ? data.apartmentId.value
          : this.apartmentId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      nationalId: data.nationalId.present
          ? data.nationalId.value
          : this.nationalId,
      address: data.address.present ? data.address.value : this.address,
      monthlyRent: data.monthlyRent.present
          ? data.monthlyRent.value
          : this.monthlyRent,
      depositAmount: data.depositAmount.present
          ? data.depositAmount.value
          : this.depositAmount,
      contractStartDate: data.contractStartDate.present
          ? data.contractStartDate.value
          : this.contractStartDate,
      contractEndDate: data.contractEndDate.present
          ? data.contractEndDate.value
          : this.contractEndDate,
      paymentDueDay: data.paymentDueDay.present
          ? data.paymentDueDay.value
          : this.paymentDueDay,
      moveInDate: data.moveInDate.present
          ? data.moveInDate.value
          : this.moveInDate,
      moveOutDate: data.moveOutDate.present
          ? data.moveOutDate.value
          : this.moveOutDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantEntry(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('nationalId: $nationalId, ')
          ..write('address: $address, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('depositAmount: $depositAmount, ')
          ..write('contractStartDate: $contractStartDate, ')
          ..write('contractEndDate: $contractEndDate, ')
          ..write('paymentDueDay: $paymentDueDay, ')
          ..write('moveInDate: $moveInDate, ')
          ..write('moveOutDate: $moveOutDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    apartmentId,
    fullName,
    phone,
    nationalId,
    address,
    monthlyRent,
    depositAmount,
    contractStartDate,
    contractEndDate,
    paymentDueDay,
    moveInDate,
    moveOutDate,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantEntry &&
          other.id == this.id &&
          other.apartmentId == this.apartmentId &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.nationalId == this.nationalId &&
          other.address == this.address &&
          other.monthlyRent == this.monthlyRent &&
          other.depositAmount == this.depositAmount &&
          other.contractStartDate == this.contractStartDate &&
          other.contractEndDate == this.contractEndDate &&
          other.paymentDueDay == this.paymentDueDay &&
          other.moveInDate == this.moveInDate &&
          other.moveOutDate == this.moveOutDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TenantsCompanion extends UpdateCompanion<TenantEntry> {
  final Value<int> id;
  final Value<int> apartmentId;
  final Value<String> fullName;
  final Value<String> phone;
  final Value<String> nationalId;
  final Value<String> address;
  final Value<int> monthlyRent;
  final Value<int> depositAmount;
  final Value<DateTime> contractStartDate;
  final Value<DateTime> contractEndDate;
  final Value<int> paymentDueDay;
  final Value<DateTime> moveInDate;
  final Value<DateTime?> moveOutDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.apartmentId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.address = const Value.absent(),
    this.monthlyRent = const Value.absent(),
    this.depositAmount = const Value.absent(),
    this.contractStartDate = const Value.absent(),
    this.contractEndDate = const Value.absent(),
    this.paymentDueDay = const Value.absent(),
    this.moveInDate = const Value.absent(),
    this.moveOutDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TenantsCompanion.insert({
    this.id = const Value.absent(),
    required int apartmentId,
    required String fullName,
    required String phone,
    required String nationalId,
    required String address,
    required int monthlyRent,
    this.depositAmount = const Value.absent(),
    required DateTime contractStartDate,
    required DateTime contractEndDate,
    required int paymentDueDay,
    required DateTime moveInDate,
    this.moveOutDate = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : apartmentId = Value(apartmentId),
       fullName = Value(fullName),
       phone = Value(phone),
       nationalId = Value(nationalId),
       address = Value(address),
       monthlyRent = Value(monthlyRent),
       contractStartDate = Value(contractStartDate),
       contractEndDate = Value(contractEndDate),
       paymentDueDay = Value(paymentDueDay),
       moveInDate = Value(moveInDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TenantEntry> custom({
    Expression<int>? id,
    Expression<int>? apartmentId,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? nationalId,
    Expression<String>? address,
    Expression<int>? monthlyRent,
    Expression<int>? depositAmount,
    Expression<DateTime>? contractStartDate,
    Expression<DateTime>? contractEndDate,
    Expression<int>? paymentDueDay,
    Expression<DateTime>? moveInDate,
    Expression<DateTime>? moveOutDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apartmentId != null) 'apartment_id': apartmentId,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (nationalId != null) 'national_id': nationalId,
      if (address != null) 'address': address,
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (depositAmount != null) 'deposit_amount': depositAmount,
      if (contractStartDate != null) 'contract_start_date': contractStartDate,
      if (contractEndDate != null) 'contract_end_date': contractEndDate,
      if (paymentDueDay != null) 'payment_due_day': paymentDueDay,
      if (moveInDate != null) 'move_in_date': moveInDate,
      if (moveOutDate != null) 'move_out_date': moveOutDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TenantsCompanion copyWith({
    Value<int>? id,
    Value<int>? apartmentId,
    Value<String>? fullName,
    Value<String>? phone,
    Value<String>? nationalId,
    Value<String>? address,
    Value<int>? monthlyRent,
    Value<int>? depositAmount,
    Value<DateTime>? contractStartDate,
    Value<DateTime>? contractEndDate,
    Value<int>? paymentDueDay,
    Value<DateTime>? moveInDate,
    Value<DateTime?>? moveOutDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TenantsCompanion(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      address: address ?? this.address,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      depositAmount: depositAmount ?? this.depositAmount,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      paymentDueDay: paymentDueDay ?? this.paymentDueDay,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apartmentId.present) {
      map['apartment_id'] = Variable<int>(apartmentId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (nationalId.present) {
      map['national_id'] = Variable<String>(nationalId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (monthlyRent.present) {
      map['monthly_rent'] = Variable<int>(monthlyRent.value);
    }
    if (depositAmount.present) {
      map['deposit_amount'] = Variable<int>(depositAmount.value);
    }
    if (contractStartDate.present) {
      map['contract_start_date'] = Variable<DateTime>(contractStartDate.value);
    }
    if (contractEndDate.present) {
      map['contract_end_date'] = Variable<DateTime>(contractEndDate.value);
    }
    if (paymentDueDay.present) {
      map['payment_due_day'] = Variable<int>(paymentDueDay.value);
    }
    if (moveInDate.present) {
      map['move_in_date'] = Variable<DateTime>(moveInDate.value);
    }
    if (moveOutDate.present) {
      map['move_out_date'] = Variable<DateTime>(moveOutDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('nationalId: $nationalId, ')
          ..write('address: $address, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('depositAmount: $depositAmount, ')
          ..write('contractStartDate: $contractStartDate, ')
          ..write('contractEndDate: $contractEndDate, ')
          ..write('paymentDueDay: $paymentDueDay, ')
          ..write('moveInDate: $moveInDate, ')
          ..write('moveOutDate: $moveOutDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ApartmentSpecificationsTable extends ApartmentSpecifications
    with TableInfo<$ApartmentSpecificationsTable, ApartmentSpecificationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApartmentSpecificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apartmentIdMeta = const VerificationMeta(
    'apartmentId',
  );
  @override
  late final GeneratedColumn<int> apartmentId = GeneratedColumn<int>(
    'apartment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES apartments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bedroomsMeta = const VerificationMeta(
    'bedrooms',
  );
  @override
  late final GeneratedColumn<int> bedrooms = GeneratedColumn<int>(
    'bedrooms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _bathroomsMeta = const VerificationMeta(
    'bathrooms',
  );
  @override
  late final GeneratedColumn<int> bathrooms = GeneratedColumn<int>(
    'bathrooms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _livingRoomsMeta = const VerificationMeta(
    'livingRooms',
  );
  @override
  late final GeneratedColumn<int> livingRooms = GeneratedColumn<int>(
    'living_rooms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _kitchensMeta = const VerificationMeta(
    'kitchens',
  );
  @override
  late final GeneratedColumn<int> kitchens = GeneratedColumn<int>(
    'kitchens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _balconiesMeta = const VerificationMeta(
    'balconies',
  );
  @override
  late final GeneratedColumn<int> balconies = GeneratedColumn<int>(
    'balconies',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hasAcMeta = const VerificationMeta('hasAc');
  @override
  late final GeneratedColumn<bool> hasAc = GeneratedColumn<bool>(
    'has_ac',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_ac" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasParkingMeta = const VerificationMeta(
    'hasParking',
  );
  @override
  late final GeneratedColumn<bool> hasParking = GeneratedColumn<bool>(
    'has_parking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_parking" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _additionalFeaturesMeta =
      const VerificationMeta('additionalFeatures');
  @override
  late final GeneratedColumn<String> additionalFeatures =
      GeneratedColumn<String>(
        'additional_features',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apartmentId,
    bedrooms,
    bathrooms,
    livingRooms,
    kitchens,
    balconies,
    hasAc,
    hasParking,
    additionalFeatures,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apartment_specifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApartmentSpecificationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('apartment_id')) {
      context.handle(
        _apartmentIdMeta,
        apartmentId.isAcceptableOrUnknown(
          data['apartment_id']!,
          _apartmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentIdMeta);
    }
    if (data.containsKey('bedrooms')) {
      context.handle(
        _bedroomsMeta,
        bedrooms.isAcceptableOrUnknown(data['bedrooms']!, _bedroomsMeta),
      );
    }
    if (data.containsKey('bathrooms')) {
      context.handle(
        _bathroomsMeta,
        bathrooms.isAcceptableOrUnknown(data['bathrooms']!, _bathroomsMeta),
      );
    }
    if (data.containsKey('living_rooms')) {
      context.handle(
        _livingRoomsMeta,
        livingRooms.isAcceptableOrUnknown(
          data['living_rooms']!,
          _livingRoomsMeta,
        ),
      );
    }
    if (data.containsKey('kitchens')) {
      context.handle(
        _kitchensMeta,
        kitchens.isAcceptableOrUnknown(data['kitchens']!, _kitchensMeta),
      );
    }
    if (data.containsKey('balconies')) {
      context.handle(
        _balconiesMeta,
        balconies.isAcceptableOrUnknown(data['balconies']!, _balconiesMeta),
      );
    }
    if (data.containsKey('has_ac')) {
      context.handle(
        _hasAcMeta,
        hasAc.isAcceptableOrUnknown(data['has_ac']!, _hasAcMeta),
      );
    }
    if (data.containsKey('has_parking')) {
      context.handle(
        _hasParkingMeta,
        hasParking.isAcceptableOrUnknown(data['has_parking']!, _hasParkingMeta),
      );
    }
    if (data.containsKey('additional_features')) {
      context.handle(
        _additionalFeaturesMeta,
        additionalFeatures.isAcceptableOrUnknown(
          data['additional_features']!,
          _additionalFeaturesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApartmentSpecificationEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApartmentSpecificationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apartment_id'],
      )!,
      bedrooms: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bedrooms'],
      )!,
      bathrooms: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bathrooms'],
      )!,
      livingRooms: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}living_rooms'],
      )!,
      kitchens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kitchens'],
      )!,
      balconies: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balconies'],
      )!,
      hasAc: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_ac'],
      )!,
      hasParking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_parking'],
      )!,
      additionalFeatures: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}additional_features'],
      ),
    );
  }

  @override
  $ApartmentSpecificationsTable createAlias(String alias) {
    return $ApartmentSpecificationsTable(attachedDatabase, alias);
  }
}

class ApartmentSpecificationEntry extends DataClass
    implements Insertable<ApartmentSpecificationEntry> {
  final int id;
  final int apartmentId;
  final int bedrooms;
  final int bathrooms;
  final int livingRooms;
  final int kitchens;
  final int balconies;
  final bool hasAc;
  final bool hasParking;
  final String? additionalFeatures;
  const ApartmentSpecificationEntry({
    required this.id,
    required this.apartmentId,
    required this.bedrooms,
    required this.bathrooms,
    required this.livingRooms,
    required this.kitchens,
    required this.balconies,
    required this.hasAc,
    required this.hasParking,
    this.additionalFeatures,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['apartment_id'] = Variable<int>(apartmentId);
    map['bedrooms'] = Variable<int>(bedrooms);
    map['bathrooms'] = Variable<int>(bathrooms);
    map['living_rooms'] = Variable<int>(livingRooms);
    map['kitchens'] = Variable<int>(kitchens);
    map['balconies'] = Variable<int>(balconies);
    map['has_ac'] = Variable<bool>(hasAc);
    map['has_parking'] = Variable<bool>(hasParking);
    if (!nullToAbsent || additionalFeatures != null) {
      map['additional_features'] = Variable<String>(additionalFeatures);
    }
    return map;
  }

  ApartmentSpecificationsCompanion toCompanion(bool nullToAbsent) {
    return ApartmentSpecificationsCompanion(
      id: Value(id),
      apartmentId: Value(apartmentId),
      bedrooms: Value(bedrooms),
      bathrooms: Value(bathrooms),
      livingRooms: Value(livingRooms),
      kitchens: Value(kitchens),
      balconies: Value(balconies),
      hasAc: Value(hasAc),
      hasParking: Value(hasParking),
      additionalFeatures: additionalFeatures == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalFeatures),
    );
  }

  factory ApartmentSpecificationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApartmentSpecificationEntry(
      id: serializer.fromJson<int>(json['id']),
      apartmentId: serializer.fromJson<int>(json['apartmentId']),
      bedrooms: serializer.fromJson<int>(json['bedrooms']),
      bathrooms: serializer.fromJson<int>(json['bathrooms']),
      livingRooms: serializer.fromJson<int>(json['livingRooms']),
      kitchens: serializer.fromJson<int>(json['kitchens']),
      balconies: serializer.fromJson<int>(json['balconies']),
      hasAc: serializer.fromJson<bool>(json['hasAc']),
      hasParking: serializer.fromJson<bool>(json['hasParking']),
      additionalFeatures: serializer.fromJson<String?>(
        json['additionalFeatures'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apartmentId': serializer.toJson<int>(apartmentId),
      'bedrooms': serializer.toJson<int>(bedrooms),
      'bathrooms': serializer.toJson<int>(bathrooms),
      'livingRooms': serializer.toJson<int>(livingRooms),
      'kitchens': serializer.toJson<int>(kitchens),
      'balconies': serializer.toJson<int>(balconies),
      'hasAc': serializer.toJson<bool>(hasAc),
      'hasParking': serializer.toJson<bool>(hasParking),
      'additionalFeatures': serializer.toJson<String?>(additionalFeatures),
    };
  }

  ApartmentSpecificationEntry copyWith({
    int? id,
    int? apartmentId,
    int? bedrooms,
    int? bathrooms,
    int? livingRooms,
    int? kitchens,
    int? balconies,
    bool? hasAc,
    bool? hasParking,
    Value<String?> additionalFeatures = const Value.absent(),
  }) => ApartmentSpecificationEntry(
    id: id ?? this.id,
    apartmentId: apartmentId ?? this.apartmentId,
    bedrooms: bedrooms ?? this.bedrooms,
    bathrooms: bathrooms ?? this.bathrooms,
    livingRooms: livingRooms ?? this.livingRooms,
    kitchens: kitchens ?? this.kitchens,
    balconies: balconies ?? this.balconies,
    hasAc: hasAc ?? this.hasAc,
    hasParking: hasParking ?? this.hasParking,
    additionalFeatures: additionalFeatures.present
        ? additionalFeatures.value
        : this.additionalFeatures,
  );
  ApartmentSpecificationEntry copyWithCompanion(
    ApartmentSpecificationsCompanion data,
  ) {
    return ApartmentSpecificationEntry(
      id: data.id.present ? data.id.value : this.id,
      apartmentId: data.apartmentId.present
          ? data.apartmentId.value
          : this.apartmentId,
      bedrooms: data.bedrooms.present ? data.bedrooms.value : this.bedrooms,
      bathrooms: data.bathrooms.present ? data.bathrooms.value : this.bathrooms,
      livingRooms: data.livingRooms.present
          ? data.livingRooms.value
          : this.livingRooms,
      kitchens: data.kitchens.present ? data.kitchens.value : this.kitchens,
      balconies: data.balconies.present ? data.balconies.value : this.balconies,
      hasAc: data.hasAc.present ? data.hasAc.value : this.hasAc,
      hasParking: data.hasParking.present
          ? data.hasParking.value
          : this.hasParking,
      additionalFeatures: data.additionalFeatures.present
          ? data.additionalFeatures.value
          : this.additionalFeatures,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApartmentSpecificationEntry(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('bedrooms: $bedrooms, ')
          ..write('bathrooms: $bathrooms, ')
          ..write('livingRooms: $livingRooms, ')
          ..write('kitchens: $kitchens, ')
          ..write('balconies: $balconies, ')
          ..write('hasAc: $hasAc, ')
          ..write('hasParking: $hasParking, ')
          ..write('additionalFeatures: $additionalFeatures')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    apartmentId,
    bedrooms,
    bathrooms,
    livingRooms,
    kitchens,
    balconies,
    hasAc,
    hasParking,
    additionalFeatures,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApartmentSpecificationEntry &&
          other.id == this.id &&
          other.apartmentId == this.apartmentId &&
          other.bedrooms == this.bedrooms &&
          other.bathrooms == this.bathrooms &&
          other.livingRooms == this.livingRooms &&
          other.kitchens == this.kitchens &&
          other.balconies == this.balconies &&
          other.hasAc == this.hasAc &&
          other.hasParking == this.hasParking &&
          other.additionalFeatures == this.additionalFeatures);
}

class ApartmentSpecificationsCompanion
    extends UpdateCompanion<ApartmentSpecificationEntry> {
  final Value<int> id;
  final Value<int> apartmentId;
  final Value<int> bedrooms;
  final Value<int> bathrooms;
  final Value<int> livingRooms;
  final Value<int> kitchens;
  final Value<int> balconies;
  final Value<bool> hasAc;
  final Value<bool> hasParking;
  final Value<String?> additionalFeatures;
  const ApartmentSpecificationsCompanion({
    this.id = const Value.absent(),
    this.apartmentId = const Value.absent(),
    this.bedrooms = const Value.absent(),
    this.bathrooms = const Value.absent(),
    this.livingRooms = const Value.absent(),
    this.kitchens = const Value.absent(),
    this.balconies = const Value.absent(),
    this.hasAc = const Value.absent(),
    this.hasParking = const Value.absent(),
    this.additionalFeatures = const Value.absent(),
  });
  ApartmentSpecificationsCompanion.insert({
    this.id = const Value.absent(),
    required int apartmentId,
    this.bedrooms = const Value.absent(),
    this.bathrooms = const Value.absent(),
    this.livingRooms = const Value.absent(),
    this.kitchens = const Value.absent(),
    this.balconies = const Value.absent(),
    this.hasAc = const Value.absent(),
    this.hasParking = const Value.absent(),
    this.additionalFeatures = const Value.absent(),
  }) : apartmentId = Value(apartmentId);
  static Insertable<ApartmentSpecificationEntry> custom({
    Expression<int>? id,
    Expression<int>? apartmentId,
    Expression<int>? bedrooms,
    Expression<int>? bathrooms,
    Expression<int>? livingRooms,
    Expression<int>? kitchens,
    Expression<int>? balconies,
    Expression<bool>? hasAc,
    Expression<bool>? hasParking,
    Expression<String>? additionalFeatures,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apartmentId != null) 'apartment_id': apartmentId,
      if (bedrooms != null) 'bedrooms': bedrooms,
      if (bathrooms != null) 'bathrooms': bathrooms,
      if (livingRooms != null) 'living_rooms': livingRooms,
      if (kitchens != null) 'kitchens': kitchens,
      if (balconies != null) 'balconies': balconies,
      if (hasAc != null) 'has_ac': hasAc,
      if (hasParking != null) 'has_parking': hasParking,
      if (additionalFeatures != null) 'additional_features': additionalFeatures,
    });
  }

  ApartmentSpecificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? apartmentId,
    Value<int>? bedrooms,
    Value<int>? bathrooms,
    Value<int>? livingRooms,
    Value<int>? kitchens,
    Value<int>? balconies,
    Value<bool>? hasAc,
    Value<bool>? hasParking,
    Value<String?>? additionalFeatures,
  }) {
    return ApartmentSpecificationsCompanion(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      livingRooms: livingRooms ?? this.livingRooms,
      kitchens: kitchens ?? this.kitchens,
      balconies: balconies ?? this.balconies,
      hasAc: hasAc ?? this.hasAc,
      hasParking: hasParking ?? this.hasParking,
      additionalFeatures: additionalFeatures ?? this.additionalFeatures,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apartmentId.present) {
      map['apartment_id'] = Variable<int>(apartmentId.value);
    }
    if (bedrooms.present) {
      map['bedrooms'] = Variable<int>(bedrooms.value);
    }
    if (bathrooms.present) {
      map['bathrooms'] = Variable<int>(bathrooms.value);
    }
    if (livingRooms.present) {
      map['living_rooms'] = Variable<int>(livingRooms.value);
    }
    if (kitchens.present) {
      map['kitchens'] = Variable<int>(kitchens.value);
    }
    if (balconies.present) {
      map['balconies'] = Variable<int>(balconies.value);
    }
    if (hasAc.present) {
      map['has_ac'] = Variable<bool>(hasAc.value);
    }
    if (hasParking.present) {
      map['has_parking'] = Variable<bool>(hasParking.value);
    }
    if (additionalFeatures.present) {
      map['additional_features'] = Variable<String>(additionalFeatures.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApartmentSpecificationsCompanion(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('bedrooms: $bedrooms, ')
          ..write('bathrooms: $bathrooms, ')
          ..write('livingRooms: $livingRooms, ')
          ..write('kitchens: $kitchens, ')
          ..write('balconies: $balconies, ')
          ..write('hasAc: $hasAc, ')
          ..write('hasParking: $hasParking, ')
          ..write('additionalFeatures: $additionalFeatures')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services
    with TableInfo<$ServicesTable, ServiceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apartmentIdMeta = const VerificationMeta(
    'apartmentId',
  );
  @override
  late final GeneratedColumn<int> apartmentId = GeneratedColumn<int>(
    'apartment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apartments (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ServiceType, String> serviceType =
      GeneratedColumn<String>(
        'service_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ServiceType>($ServicesTable.$converterserviceType);
  static const VerificationMeta _previousReadingMeta = const VerificationMeta(
    'previousReading',
  );
  @override
  late final GeneratedColumn<double> previousReading = GeneratedColumn<double>(
    'previous_reading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentReadingMeta = const VerificationMeta(
    'currentReading',
  );
  @override
  late final GeneratedColumn<double> currentReading = GeneratedColumn<double>(
    'current_reading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consumptionMeta = const VerificationMeta(
    'consumption',
  );
  @override
  late final GeneratedColumn<double> consumption = GeneratedColumn<double>(
    'consumption',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingDateMeta = const VerificationMeta(
    'billingDate',
  );
  @override
  late final GeneratedColumn<DateTime> billingDate = GeneratedColumn<DateTime>(
    'billing_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayerResponsibility, String>
  payerResponsibility =
      GeneratedColumn<String>(
        'payer_responsibility',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PayerResponsibility>(
        $ServicesTable.$converterpayerResponsibility,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apartmentId,
    serviceType,
    previousReading,
    currentReading,
    consumption,
    unitPrice,
    totalAmount,
    billingDate,
    dueDate,
    payerResponsibility,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('apartment_id')) {
      context.handle(
        _apartmentIdMeta,
        apartmentId.isAcceptableOrUnknown(
          data['apartment_id']!,
          _apartmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentIdMeta);
    }
    if (data.containsKey('previous_reading')) {
      context.handle(
        _previousReadingMeta,
        previousReading.isAcceptableOrUnknown(
          data['previous_reading']!,
          _previousReadingMeta,
        ),
      );
    }
    if (data.containsKey('current_reading')) {
      context.handle(
        _currentReadingMeta,
        currentReading.isAcceptableOrUnknown(
          data['current_reading']!,
          _currentReadingMeta,
        ),
      );
    }
    if (data.containsKey('consumption')) {
      context.handle(
        _consumptionMeta,
        consumption.isAcceptableOrUnknown(
          data['consumption']!,
          _consumptionMeta,
        ),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('billing_date')) {
      context.handle(
        _billingDateMeta,
        billingDate.isAcceptableOrUnknown(
          data['billing_date']!,
          _billingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {id, apartmentId},
  ];
  @override
  ServiceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apartment_id'],
      )!,
      serviceType: $ServicesTable.$converterserviceType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}service_type'],
        )!,
      ),
      previousReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_reading'],
      ),
      currentReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_reading'],
      ),
      consumption: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consumption'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      billingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}billing_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      payerResponsibility: $ServicesTable.$converterpayerResponsibility.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payer_responsibility'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ServiceType, String, String> $converterserviceType =
      const EnumNameConverter<ServiceType>(ServiceType.values);
  static JsonTypeConverter2<PayerResponsibility, String, String>
  $converterpayerResponsibility = const EnumNameConverter<PayerResponsibility>(
    PayerResponsibility.values,
  );
}

class ServiceEntry extends DataClass implements Insertable<ServiceEntry> {
  final int id;
  final int apartmentId;
  final ServiceType serviceType;
  final double? previousReading;
  final double? currentReading;
  final double consumption;
  final int unitPrice;
  final int totalAmount;
  final DateTime billingDate;
  final DateTime dueDate;
  final PayerResponsibility payerResponsibility;
  final String? notes;
  final DateTime createdAt;
  const ServiceEntry({
    required this.id,
    required this.apartmentId,
    required this.serviceType,
    this.previousReading,
    this.currentReading,
    required this.consumption,
    required this.unitPrice,
    required this.totalAmount,
    required this.billingDate,
    required this.dueDate,
    required this.payerResponsibility,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['apartment_id'] = Variable<int>(apartmentId);
    {
      map['service_type'] = Variable<String>(
        $ServicesTable.$converterserviceType.toSql(serviceType),
      );
    }
    if (!nullToAbsent || previousReading != null) {
      map['previous_reading'] = Variable<double>(previousReading);
    }
    if (!nullToAbsent || currentReading != null) {
      map['current_reading'] = Variable<double>(currentReading);
    }
    map['consumption'] = Variable<double>(consumption);
    map['unit_price'] = Variable<int>(unitPrice);
    map['total_amount'] = Variable<int>(totalAmount);
    map['billing_date'] = Variable<DateTime>(billingDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    {
      map['payer_responsibility'] = Variable<String>(
        $ServicesTable.$converterpayerResponsibility.toSql(payerResponsibility),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      apartmentId: Value(apartmentId),
      serviceType: Value(serviceType),
      previousReading: previousReading == null && nullToAbsent
          ? const Value.absent()
          : Value(previousReading),
      currentReading: currentReading == null && nullToAbsent
          ? const Value.absent()
          : Value(currentReading),
      consumption: Value(consumption),
      unitPrice: Value(unitPrice),
      totalAmount: Value(totalAmount),
      billingDate: Value(billingDate),
      dueDate: Value(dueDate),
      payerResponsibility: Value(payerResponsibility),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory ServiceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceEntry(
      id: serializer.fromJson<int>(json['id']),
      apartmentId: serializer.fromJson<int>(json['apartmentId']),
      serviceType: $ServicesTable.$converterserviceType.fromJson(
        serializer.fromJson<String>(json['serviceType']),
      ),
      previousReading: serializer.fromJson<double?>(json['previousReading']),
      currentReading: serializer.fromJson<double?>(json['currentReading']),
      consumption: serializer.fromJson<double>(json['consumption']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      billingDate: serializer.fromJson<DateTime>(json['billingDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      payerResponsibility: $ServicesTable.$converterpayerResponsibility
          .fromJson(serializer.fromJson<String>(json['payerResponsibility'])),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apartmentId': serializer.toJson<int>(apartmentId),
      'serviceType': serializer.toJson<String>(
        $ServicesTable.$converterserviceType.toJson(serviceType),
      ),
      'previousReading': serializer.toJson<double?>(previousReading),
      'currentReading': serializer.toJson<double?>(currentReading),
      'consumption': serializer.toJson<double>(consumption),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'billingDate': serializer.toJson<DateTime>(billingDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'payerResponsibility': serializer.toJson<String>(
        $ServicesTable.$converterpayerResponsibility.toJson(
          payerResponsibility,
        ),
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ServiceEntry copyWith({
    int? id,
    int? apartmentId,
    ServiceType? serviceType,
    Value<double?> previousReading = const Value.absent(),
    Value<double?> currentReading = const Value.absent(),
    double? consumption,
    int? unitPrice,
    int? totalAmount,
    DateTime? billingDate,
    DateTime? dueDate,
    PayerResponsibility? payerResponsibility,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => ServiceEntry(
    id: id ?? this.id,
    apartmentId: apartmentId ?? this.apartmentId,
    serviceType: serviceType ?? this.serviceType,
    previousReading: previousReading.present
        ? previousReading.value
        : this.previousReading,
    currentReading: currentReading.present
        ? currentReading.value
        : this.currentReading,
    consumption: consumption ?? this.consumption,
    unitPrice: unitPrice ?? this.unitPrice,
    totalAmount: totalAmount ?? this.totalAmount,
    billingDate: billingDate ?? this.billingDate,
    dueDate: dueDate ?? this.dueDate,
    payerResponsibility: payerResponsibility ?? this.payerResponsibility,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  ServiceEntry copyWithCompanion(ServicesCompanion data) {
    return ServiceEntry(
      id: data.id.present ? data.id.value : this.id,
      apartmentId: data.apartmentId.present
          ? data.apartmentId.value
          : this.apartmentId,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      previousReading: data.previousReading.present
          ? data.previousReading.value
          : this.previousReading,
      currentReading: data.currentReading.present
          ? data.currentReading.value
          : this.currentReading,
      consumption: data.consumption.present
          ? data.consumption.value
          : this.consumption,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      billingDate: data.billingDate.present
          ? data.billingDate.value
          : this.billingDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      payerResponsibility: data.payerResponsibility.present
          ? data.payerResponsibility.value
          : this.payerResponsibility,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceEntry(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('serviceType: $serviceType, ')
          ..write('previousReading: $previousReading, ')
          ..write('currentReading: $currentReading, ')
          ..write('consumption: $consumption, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('billingDate: $billingDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('payerResponsibility: $payerResponsibility, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    apartmentId,
    serviceType,
    previousReading,
    currentReading,
    consumption,
    unitPrice,
    totalAmount,
    billingDate,
    dueDate,
    payerResponsibility,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceEntry &&
          other.id == this.id &&
          other.apartmentId == this.apartmentId &&
          other.serviceType == this.serviceType &&
          other.previousReading == this.previousReading &&
          other.currentReading == this.currentReading &&
          other.consumption == this.consumption &&
          other.unitPrice == this.unitPrice &&
          other.totalAmount == this.totalAmount &&
          other.billingDate == this.billingDate &&
          other.dueDate == this.dueDate &&
          other.payerResponsibility == this.payerResponsibility &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class ServicesCompanion extends UpdateCompanion<ServiceEntry> {
  final Value<int> id;
  final Value<int> apartmentId;
  final Value<ServiceType> serviceType;
  final Value<double?> previousReading;
  final Value<double?> currentReading;
  final Value<double> consumption;
  final Value<int> unitPrice;
  final Value<int> totalAmount;
  final Value<DateTime> billingDate;
  final Value<DateTime> dueDate;
  final Value<PayerResponsibility> payerResponsibility;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.apartmentId = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.previousReading = const Value.absent(),
    this.currentReading = const Value.absent(),
    this.consumption = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.billingDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.payerResponsibility = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required int apartmentId,
    required ServiceType serviceType,
    this.previousReading = const Value.absent(),
    this.currentReading = const Value.absent(),
    this.consumption = const Value.absent(),
    this.unitPrice = const Value.absent(),
    required int totalAmount,
    required DateTime billingDate,
    required DateTime dueDate,
    required PayerResponsibility payerResponsibility,
    this.notes = const Value.absent(),
    required DateTime createdAt,
  }) : apartmentId = Value(apartmentId),
       serviceType = Value(serviceType),
       totalAmount = Value(totalAmount),
       billingDate = Value(billingDate),
       dueDate = Value(dueDate),
       payerResponsibility = Value(payerResponsibility),
       createdAt = Value(createdAt);
  static Insertable<ServiceEntry> custom({
    Expression<int>? id,
    Expression<int>? apartmentId,
    Expression<String>? serviceType,
    Expression<double>? previousReading,
    Expression<double>? currentReading,
    Expression<double>? consumption,
    Expression<int>? unitPrice,
    Expression<int>? totalAmount,
    Expression<DateTime>? billingDate,
    Expression<DateTime>? dueDate,
    Expression<String>? payerResponsibility,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apartmentId != null) 'apartment_id': apartmentId,
      if (serviceType != null) 'service_type': serviceType,
      if (previousReading != null) 'previous_reading': previousReading,
      if (currentReading != null) 'current_reading': currentReading,
      if (consumption != null) 'consumption': consumption,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (billingDate != null) 'billing_date': billingDate,
      if (dueDate != null) 'due_date': dueDate,
      if (payerResponsibility != null)
        'payer_responsibility': payerResponsibility,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<int>? apartmentId,
    Value<ServiceType>? serviceType,
    Value<double?>? previousReading,
    Value<double?>? currentReading,
    Value<double>? consumption,
    Value<int>? unitPrice,
    Value<int>? totalAmount,
    Value<DateTime>? billingDate,
    Value<DateTime>? dueDate,
    Value<PayerResponsibility>? payerResponsibility,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      serviceType: serviceType ?? this.serviceType,
      previousReading: previousReading ?? this.previousReading,
      currentReading: currentReading ?? this.currentReading,
      consumption: consumption ?? this.consumption,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      billingDate: billingDate ?? this.billingDate,
      dueDate: dueDate ?? this.dueDate,
      payerResponsibility: payerResponsibility ?? this.payerResponsibility,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apartmentId.present) {
      map['apartment_id'] = Variable<int>(apartmentId.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(
        $ServicesTable.$converterserviceType.toSql(serviceType.value),
      );
    }
    if (previousReading.present) {
      map['previous_reading'] = Variable<double>(previousReading.value);
    }
    if (currentReading.present) {
      map['current_reading'] = Variable<double>(currentReading.value);
    }
    if (consumption.present) {
      map['consumption'] = Variable<double>(consumption.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (billingDate.present) {
      map['billing_date'] = Variable<DateTime>(billingDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (payerResponsibility.present) {
      map['payer_responsibility'] = Variable<String>(
        $ServicesTable.$converterpayerResponsibility.toSql(
          payerResponsibility.value,
        ),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('serviceType: $serviceType, ')
          ..write('previousReading: $previousReading, ')
          ..write('currentReading: $currentReading, ')
          ..write('consumption: $consumption, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('billingDate: $billingDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('payerResponsibility: $payerResponsibility, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apartmentIdMeta = const VerificationMeta(
    'apartmentId',
  );
  @override
  late final GeneratedColumn<int> apartmentId = GeneratedColumn<int>(
    'apartment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apartments (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
    'tenant_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tenants (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentType, String> paymentType =
      GeneratedColumn<String>(
        'payment_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentType>($PaymentsTable.$converterpaymentType);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayerResponsibility, String>
  paidBy = GeneratedColumn<String>(
    'paid_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PayerResponsibility>($PaymentsTable.$converterpaidBy);
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod, String>
  paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PaymentMethod>($PaymentsTable.$converterpaymentMethod);
  static const VerificationMeta _billingPeriodMeta = const VerificationMeta(
    'billingPeriod',
  );
  @override
  late final GeneratedColumn<String> billingPeriod = GeneratedColumn<String>(
    'billing_period',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceNumberMeta = const VerificationMeta(
    'referenceNumber',
  );
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
    'reference_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apartmentId,
    tenantId,
    serviceId,
    paymentType,
    amount,
    dueDate,
    paymentDate,
    paidBy,
    paymentMethod,
    billingPeriod,
    referenceNumber,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('apartment_id')) {
      context.handle(
        _apartmentIdMeta,
        apartmentId.isAcceptableOrUnknown(
          data['apartment_id']!,
          _apartmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('billing_period')) {
      context.handle(
        _billingPeriodMeta,
        billingPeriod.isAcceptableOrUnknown(
          data['billing_period']!,
          _billingPeriodMeta,
        ),
      );
    }
    if (data.containsKey('reference_number')) {
      context.handle(
        _referenceNumberMeta,
        referenceNumber.isAcceptableOrUnknown(
          data['reference_number']!,
          _referenceNumberMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apartment_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenant_id'],
      ),
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      ),
      paymentType: $PaymentsTable.$converterpaymentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_type'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      paidBy: $PaymentsTable.$converterpaidBy.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}paid_by'],
        )!,
      ),
      paymentMethod: $PaymentsTable.$converterpaymentMethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_method'],
        )!,
      ),
      billingPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_period'],
      ),
      referenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_number'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentType, String, String> $converterpaymentType =
      const EnumNameConverter<PaymentType>(PaymentType.values);
  static JsonTypeConverter2<PayerResponsibility, String, String>
  $converterpaidBy = const EnumNameConverter<PayerResponsibility>(
    PayerResponsibility.values,
  );
  static JsonTypeConverter2<PaymentMethod, String, String>
  $converterpaymentMethod = const EnumNameConverter<PaymentMethod>(
    PaymentMethod.values,
  );
}

class PaymentEntry extends DataClass implements Insertable<PaymentEntry> {
  final int id;
  final int apartmentId;
  final int? tenantId;
  final int? serviceId;
  final PaymentType paymentType;
  final int amount;
  final DateTime? dueDate;
  final DateTime paymentDate;
  final PayerResponsibility paidBy;
  final PaymentMethod paymentMethod;
  final String? billingPeriod;
  final String? referenceNumber;
  final String? notes;
  final DateTime createdAt;
  const PaymentEntry({
    required this.id,
    required this.apartmentId,
    this.tenantId,
    this.serviceId,
    required this.paymentType,
    required this.amount,
    this.dueDate,
    required this.paymentDate,
    required this.paidBy,
    required this.paymentMethod,
    this.billingPeriod,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['apartment_id'] = Variable<int>(apartmentId);
    if (!nullToAbsent || tenantId != null) {
      map['tenant_id'] = Variable<int>(tenantId);
    }
    if (!nullToAbsent || serviceId != null) {
      map['service_id'] = Variable<int>(serviceId);
    }
    {
      map['payment_type'] = Variable<String>(
        $PaymentsTable.$converterpaymentType.toSql(paymentType),
      );
    }
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['payment_date'] = Variable<DateTime>(paymentDate);
    {
      map['paid_by'] = Variable<String>(
        $PaymentsTable.$converterpaidBy.toSql(paidBy),
      );
    }
    {
      map['payment_method'] = Variable<String>(
        $PaymentsTable.$converterpaymentMethod.toSql(paymentMethod),
      );
    }
    if (!nullToAbsent || billingPeriod != null) {
      map['billing_period'] = Variable<String>(billingPeriod);
    }
    if (!nullToAbsent || referenceNumber != null) {
      map['reference_number'] = Variable<String>(referenceNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      apartmentId: Value(apartmentId),
      tenantId: tenantId == null && nullToAbsent
          ? const Value.absent()
          : Value(tenantId),
      serviceId: serviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceId),
      paymentType: Value(paymentType),
      amount: Value(amount),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      paymentDate: Value(paymentDate),
      paidBy: Value(paidBy),
      paymentMethod: Value(paymentMethod),
      billingPeriod: billingPeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(billingPeriod),
      referenceNumber: referenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNumber),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentEntry(
      id: serializer.fromJson<int>(json['id']),
      apartmentId: serializer.fromJson<int>(json['apartmentId']),
      tenantId: serializer.fromJson<int?>(json['tenantId']),
      serviceId: serializer.fromJson<int?>(json['serviceId']),
      paymentType: $PaymentsTable.$converterpaymentType.fromJson(
        serializer.fromJson<String>(json['paymentType']),
      ),
      amount: serializer.fromJson<int>(json['amount']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      paidBy: $PaymentsTable.$converterpaidBy.fromJson(
        serializer.fromJson<String>(json['paidBy']),
      ),
      paymentMethod: $PaymentsTable.$converterpaymentMethod.fromJson(
        serializer.fromJson<String>(json['paymentMethod']),
      ),
      billingPeriod: serializer.fromJson<String?>(json['billingPeriod']),
      referenceNumber: serializer.fromJson<String?>(json['referenceNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apartmentId': serializer.toJson<int>(apartmentId),
      'tenantId': serializer.toJson<int?>(tenantId),
      'serviceId': serializer.toJson<int?>(serviceId),
      'paymentType': serializer.toJson<String>(
        $PaymentsTable.$converterpaymentType.toJson(paymentType),
      ),
      'amount': serializer.toJson<int>(amount),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'paidBy': serializer.toJson<String>(
        $PaymentsTable.$converterpaidBy.toJson(paidBy),
      ),
      'paymentMethod': serializer.toJson<String>(
        $PaymentsTable.$converterpaymentMethod.toJson(paymentMethod),
      ),
      'billingPeriod': serializer.toJson<String?>(billingPeriod),
      'referenceNumber': serializer.toJson<String?>(referenceNumber),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentEntry copyWith({
    int? id,
    int? apartmentId,
    Value<int?> tenantId = const Value.absent(),
    Value<int?> serviceId = const Value.absent(),
    PaymentType? paymentType,
    int? amount,
    Value<DateTime?> dueDate = const Value.absent(),
    DateTime? paymentDate,
    PayerResponsibility? paidBy,
    PaymentMethod? paymentMethod,
    Value<String?> billingPeriod = const Value.absent(),
    Value<String?> referenceNumber = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => PaymentEntry(
    id: id ?? this.id,
    apartmentId: apartmentId ?? this.apartmentId,
    tenantId: tenantId.present ? tenantId.value : this.tenantId,
    serviceId: serviceId.present ? serviceId.value : this.serviceId,
    paymentType: paymentType ?? this.paymentType,
    amount: amount ?? this.amount,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    paymentDate: paymentDate ?? this.paymentDate,
    paidBy: paidBy ?? this.paidBy,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    billingPeriod: billingPeriod.present
        ? billingPeriod.value
        : this.billingPeriod,
    referenceNumber: referenceNumber.present
        ? referenceNumber.value
        : this.referenceNumber,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentEntry copyWithCompanion(PaymentsCompanion data) {
    return PaymentEntry(
      id: data.id.present ? data.id.value : this.id,
      apartmentId: data.apartmentId.present
          ? data.apartmentId.value
          : this.apartmentId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      amount: data.amount.present ? data.amount.value : this.amount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      paidBy: data.paidBy.present ? data.paidBy.value : this.paidBy,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      billingPeriod: data.billingPeriod.present
          ? data.billingPeriod.value
          : this.billingPeriod,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentEntry(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('tenantId: $tenantId, ')
          ..write('serviceId: $serviceId, ')
          ..write('paymentType: $paymentType, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('paidBy: $paidBy, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('billingPeriod: $billingPeriod, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    apartmentId,
    tenantId,
    serviceId,
    paymentType,
    amount,
    dueDate,
    paymentDate,
    paidBy,
    paymentMethod,
    billingPeriod,
    referenceNumber,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentEntry &&
          other.id == this.id &&
          other.apartmentId == this.apartmentId &&
          other.tenantId == this.tenantId &&
          other.serviceId == this.serviceId &&
          other.paymentType == this.paymentType &&
          other.amount == this.amount &&
          other.dueDate == this.dueDate &&
          other.paymentDate == this.paymentDate &&
          other.paidBy == this.paidBy &&
          other.paymentMethod == this.paymentMethod &&
          other.billingPeriod == this.billingPeriod &&
          other.referenceNumber == this.referenceNumber &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<PaymentEntry> {
  final Value<int> id;
  final Value<int> apartmentId;
  final Value<int?> tenantId;
  final Value<int?> serviceId;
  final Value<PaymentType> paymentType;
  final Value<int> amount;
  final Value<DateTime?> dueDate;
  final Value<DateTime> paymentDate;
  final Value<PayerResponsibility> paidBy;
  final Value<PaymentMethod> paymentMethod;
  final Value<String?> billingPeriod;
  final Value<String?> referenceNumber;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.apartmentId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.amount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.paidBy = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.billingPeriod = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int apartmentId,
    this.tenantId = const Value.absent(),
    this.serviceId = const Value.absent(),
    required PaymentType paymentType,
    required int amount,
    this.dueDate = const Value.absent(),
    required DateTime paymentDate,
    required PayerResponsibility paidBy,
    required PaymentMethod paymentMethod,
    this.billingPeriod = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  }) : apartmentId = Value(apartmentId),
       paymentType = Value(paymentType),
       amount = Value(amount),
       paymentDate = Value(paymentDate),
       paidBy = Value(paidBy),
       paymentMethod = Value(paymentMethod),
       createdAt = Value(createdAt);
  static Insertable<PaymentEntry> custom({
    Expression<int>? id,
    Expression<int>? apartmentId,
    Expression<int>? tenantId,
    Expression<int>? serviceId,
    Expression<String>? paymentType,
    Expression<int>? amount,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? paymentDate,
    Expression<String>? paidBy,
    Expression<String>? paymentMethod,
    Expression<String>? billingPeriod,
    Expression<String>? referenceNumber,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apartmentId != null) 'apartment_id': apartmentId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (serviceId != null) 'service_id': serviceId,
      if (paymentType != null) 'payment_type': paymentType,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'due_date': dueDate,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (paidBy != null) 'paid_by': paidBy,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (billingPeriod != null) 'billing_period': billingPeriod,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? apartmentId,
    Value<int?>? tenantId,
    Value<int?>? serviceId,
    Value<PaymentType>? paymentType,
    Value<int>? amount,
    Value<DateTime?>? dueDate,
    Value<DateTime>? paymentDate,
    Value<PayerResponsibility>? paidBy,
    Value<PaymentMethod>? paymentMethod,
    Value<String?>? billingPeriod,
    Value<String?>? referenceNumber,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      tenantId: tenantId ?? this.tenantId,
      serviceId: serviceId ?? this.serviceId,
      paymentType: paymentType ?? this.paymentType,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paymentDate: paymentDate ?? this.paymentDate,
      paidBy: paidBy ?? this.paidBy,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apartmentId.present) {
      map['apartment_id'] = Variable<int>(apartmentId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(
        $PaymentsTable.$converterpaymentType.toSql(paymentType.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (paidBy.present) {
      map['paid_by'] = Variable<String>(
        $PaymentsTable.$converterpaidBy.toSql(paidBy.value),
      );
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(
        $PaymentsTable.$converterpaymentMethod.toSql(paymentMethod.value),
      );
    }
    if (billingPeriod.present) {
      map['billing_period'] = Variable<String>(billingPeriod.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('tenantId: $tenantId, ')
          ..write('serviceId: $serviceId, ')
          ..write('paymentType: $paymentType, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('paidBy: $paidBy, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('billingPeriod: $billingPeriod, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $ApartmentsTable apartments = $ApartmentsTable(this);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $ApartmentSpecificationsTable apartmentSpecifications =
      $ApartmentSpecificationsTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    properties,
    apartments,
    tenants,
    apartmentSpecifications,
    services,
    payments,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'apartments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('apartment_specifications', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$PropertiesTableCreateCompanionBuilder = PropertiesCompanion Function({
  Value<int> id,
  required String name,
  required PropertyType propertyType,
  required String city,
  required String district,
  required String address,
  Value<String?> description,
  Value<String?> imagePath,
  required int numberOfFloors,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$PropertiesTableUpdateCompanionBuilder = PropertiesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<PropertyType> propertyType,
  Value<String> city,
  Value<String> district,
  Value<String> address,
  Value<String?> description,
  Value<String?> imagePath,
  Value<int> numberOfFloors,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$PropertiesTableReferences
    extends BaseReferences<_$AppDatabase, $PropertiesTable, PropertyEntry> {
  $$PropertiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ApartmentsTable, List<ApartmentEntry>>
  _apartmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.apartments,
    aliasName: 'properties__id__apartments__property_id',
  );

  $$ApartmentsTableProcessedTableManager get apartmentsRefs {
    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_apartmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertiesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PropertyType, PropertyType, String>
  get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numberOfFloors => $composableBuilder(
    column: $table.numberOfFloors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> apartmentsRefs(
    Expression<bool> Function($$ApartmentsTableFilterComposer f) f,
  ) {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numberOfFloors => $composableBuilder(
    column: $table.numberOfFloors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PropertyType, String> get propertyType =>
      $composableBuilder(
        column: $table.propertyType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get numberOfFloors => $composableBuilder(
    column: $table.numberOfFloors,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> apartmentsRefs<T extends Object>(
    Expression<T> Function($$ApartmentsTableAnnotationComposer a) f,
  ) {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTable,
          PropertyEntry,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (PropertyEntry, $$PropertiesTableReferences),
          PropertyEntry,
          PrefetchHooks Function({bool apartmentsRefs})
        > {
  $$PropertiesTableTableManager(_$AppDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<PropertyType> propertyType = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> district = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> numberOfFloors = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                name: name,
                propertyType: propertyType,
                city: city,
                district: district,
                address: address,
                description: description,
                imagePath: imagePath,
                numberOfFloors: numberOfFloors,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required PropertyType propertyType,
                required String city,
                required String district,
                required String address,
                Value<String?> description = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required int numberOfFloors,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PropertiesCompanion.insert(
                id: id,
                name: name,
                propertyType: propertyType,
                city: city,
                district: district,
                address: address,
                description: description,
                imagePath: imagePath,
                numberOfFloors: numberOfFloors,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PropertiesTable, PropertyEntry>(table),
                  $$PropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({apartmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (apartmentsRefs) db.apartments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (apartmentsRefs)
                    await $_getPrefetchedDataByColumns<
                      PropertyEntry,
                      $PropertiesTable,
                      ApartmentEntry,
                      $ApartmentsTable
                    >(
                      currentTable: table,
                      referencedTable: $$PropertiesTableReferences
                          ._apartmentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PropertiesTableReferences(
                            db,
                            table,
                            p0,
                          ).apartmentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'property_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTable,
      PropertyEntry,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (PropertyEntry, $$PropertiesTableReferences),
      PropertyEntry,
      PrefetchHooks Function({bool apartmentsRefs})
    >;
typedef $$ApartmentsTableCreateCompanionBuilder = ApartmentsCompanion Function({
  Value<int> id,
  required int propertyId,
  required String apartmentNumber,
  required int floorNumber,
  required double area,
  required int monthlyRent,
  required ApartmentStatus status,
  Value<String?> description,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$ApartmentsTableUpdateCompanionBuilder = ApartmentsCompanion Function({
  Value<int> id,
  Value<int> propertyId,
  Value<String> apartmentNumber,
  Value<int> floorNumber,
  Value<double> area,
  Value<int> monthlyRent,
  Value<ApartmentStatus> status,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ApartmentsTableReferences
    extends BaseReferences<_$AppDatabase, $ApartmentsTable, ApartmentEntry> {
  $$ApartmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropertiesTable _propertyIdTable(_$AppDatabase db) =>
      db.properties.createAlias('apartments__property_id__properties__id');

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<int>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TenantsTable, List<TenantEntry>>
  _tenantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tenants,
    aliasName: 'apartments__id__tenants__apartment_id',
  );

  $$TenantsTableProcessedTableManager get tenantsRefs {
    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.apartmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tenantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ApartmentSpecificationsTable,
    List<ApartmentSpecificationEntry>
  >
  _apartmentSpecificationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.apartmentSpecifications,
        aliasName: 'apartments__id__apartment_specifications__apartment_id',
      );

  $$ApartmentSpecificationsTableProcessedTableManager
  get apartmentSpecificationsRefs {
    final manager = $$ApartmentSpecificationsTableTableManager(
      $_db,
      $_db.apartmentSpecifications,
    ).filter((f) => f.apartmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _apartmentSpecificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ServicesTable, List<ServiceEntry>>
  _servicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.services,
    aliasName: 'apartments__id__services__apartment_id',
  );

  $$ServicesTableProcessedTableManager get servicesRefs {
    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.apartmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_servicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<PaymentEntry>>
  _paymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'apartments__id__payments__apartment_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.apartmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ApartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ApartmentsTable> {
  $$ApartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apartmentNumber => $composableBuilder(
    column: $table.apartmentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get floorNumber => $composableBuilder(
    column: $table.floorNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ApartmentStatus, ApartmentStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tenantsRefs(
    Expression<bool> Function($$TenantsTableFilterComposer f) f,
  ) {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> apartmentSpecificationsRefs(
    Expression<bool> Function($$ApartmentSpecificationsTableFilterComposer f) f,
  ) {
    final $$ApartmentSpecificationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.apartmentSpecifications,
          getReferencedColumn: (t) => t.apartmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ApartmentSpecificationsTableFilterComposer(
                $db: $db,
                $table: $db.apartmentSpecifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> servicesRefs(
    Expression<bool> Function($$ServicesTableFilterComposer f) f,
  ) {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ApartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApartmentsTable> {
  $$ApartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apartmentNumber => $composableBuilder(
    column: $table.apartmentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floorNumber => $composableBuilder(
    column: $table.floorNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApartmentsTable> {
  $$ApartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get apartmentNumber => $composableBuilder(
    column: $table.apartmentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get floorNumber => $composableBuilder(
    column: $table.floorNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ApartmentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tenantsRefs<T extends Object>(
    Expression<T> Function($$TenantsTableAnnotationComposer a) f,
  ) {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> apartmentSpecificationsRefs<T extends Object>(
    Expression<T> Function($$ApartmentSpecificationsTableAnnotationComposer a)
    f,
  ) {
    final $$ApartmentSpecificationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.apartmentSpecifications,
          getReferencedColumn: (t) => t.apartmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ApartmentSpecificationsTableAnnotationComposer(
                $db: $db,
                $table: $db.apartmentSpecifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> servicesRefs<T extends Object>(
    Expression<T> Function($$ServicesTableAnnotationComposer a) f,
  ) {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ApartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApartmentsTable,
          ApartmentEntry,
          $$ApartmentsTableFilterComposer,
          $$ApartmentsTableOrderingComposer,
          $$ApartmentsTableAnnotationComposer,
          $$ApartmentsTableCreateCompanionBuilder,
          $$ApartmentsTableUpdateCompanionBuilder,
          (ApartmentEntry, $$ApartmentsTableReferences),
          ApartmentEntry,
          PrefetchHooks Function({
            bool propertyId,
            bool tenantsRefs,
            bool apartmentSpecificationsRefs,
            bool servicesRefs,
            bool paymentsRefs,
          })
        > {
  $$ApartmentsTableTableManager(_$AppDatabase db, $ApartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> propertyId = const Value.absent(),
                Value<String> apartmentNumber = const Value.absent(),
                Value<int> floorNumber = const Value.absent(),
                Value<double> area = const Value.absent(),
                Value<int> monthlyRent = const Value.absent(),
                Value<ApartmentStatus> status = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ApartmentsCompanion(
                id: id,
                propertyId: propertyId,
                apartmentNumber: apartmentNumber,
                floorNumber: floorNumber,
                area: area,
                monthlyRent: monthlyRent,
                status: status,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int propertyId,
                required String apartmentNumber,
                required int floorNumber,
                required double area,
                required int monthlyRent,
                required ApartmentStatus status,
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ApartmentsCompanion.insert(
                id: id,
                propertyId: propertyId,
                apartmentNumber: apartmentNumber,
                floorNumber: floorNumber,
                area: area,
                monthlyRent: monthlyRent,
                status: status,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ApartmentsTable, ApartmentEntry>(table),
                  $$ApartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                propertyId = false,
                tenantsRefs = false,
                apartmentSpecificationsRefs = false,
                servicesRefs = false,
                paymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tenantsRefs) db.tenants,
                    if (apartmentSpecificationsRefs) db.apartmentSpecifications,
                    if (servicesRefs) db.services,
                    if (paymentsRefs) db.payments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (propertyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.propertyId,
                            referencedTable: $$ApartmentsTableReferences
                                ._propertyIdTable(db),
                            referencedColumn: $$ApartmentsTableReferences
                                ._propertyIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tenantsRefs)
                        await $_getPrefetchedDataByColumns<
                          ApartmentEntry,
                          $ApartmentsTable,
                          TenantEntry,
                          $TenantsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ApartmentsTableReferences
                              ._tenantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).tenantsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'apartment_id',
                          typedResults: items,
                        ),
                      if (apartmentSpecificationsRefs)
                        await $_getPrefetchedDataByColumns<
                          ApartmentEntry,
                          $ApartmentsTable,
                          ApartmentSpecificationEntry,
                          $ApartmentSpecificationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ApartmentsTableReferences
                              ._apartmentSpecificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).apartmentSpecificationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'apartment_id',
                          typedResults: items,
                        ),
                      if (servicesRefs)
                        await $_getPrefetchedDataByColumns<
                          ApartmentEntry,
                          $ApartmentsTable,
                          ServiceEntry,
                          $ServicesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ApartmentsTableReferences
                              ._servicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).servicesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'apartment_id',
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ApartmentEntry,
                          $ApartmentsTable,
                          PaymentEntry,
                          $PaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ApartmentsTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'apartment_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ApartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApartmentsTable,
      ApartmentEntry,
      $$ApartmentsTableFilterComposer,
      $$ApartmentsTableOrderingComposer,
      $$ApartmentsTableAnnotationComposer,
      $$ApartmentsTableCreateCompanionBuilder,
      $$ApartmentsTableUpdateCompanionBuilder,
      (ApartmentEntry, $$ApartmentsTableReferences),
      ApartmentEntry,
      PrefetchHooks Function({
        bool propertyId,
        bool tenantsRefs,
        bool apartmentSpecificationsRefs,
        bool servicesRefs,
        bool paymentsRefs,
      })
    >;
typedef $$TenantsTableCreateCompanionBuilder = TenantsCompanion Function({
  Value<int> id,
  required int apartmentId,
  required String fullName,
  required String phone,
  required String nationalId,
  required String address,
  required int monthlyRent,
  Value<int> depositAmount,
  required DateTime contractStartDate,
  required DateTime contractEndDate,
  required int paymentDueDay,
  required DateTime moveInDate,
  Value<DateTime?> moveOutDate,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$TenantsTableUpdateCompanionBuilder = TenantsCompanion Function({
  Value<int> id,
  Value<int> apartmentId,
  Value<String> fullName,
  Value<String> phone,
  Value<String> nationalId,
  Value<String> address,
  Value<int> monthlyRent,
  Value<int> depositAmount,
  Value<DateTime> contractStartDate,
  Value<DateTime> contractEndDate,
  Value<int> paymentDueDay,
  Value<DateTime> moveInDate,
  Value<DateTime?> moveOutDate,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TenantsTableReferences
    extends BaseReferences<_$AppDatabase, $TenantsTable, TenantEntry> {
  $$TenantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApartmentsTable _apartmentIdTable(_$AppDatabase db) =>
      db.apartments.createAlias('tenants__apartment_id__apartments__id');

  $$ApartmentsTableProcessedTableManager get apartmentId {
    final $_column = $_itemColumn<int>('apartment_id')!;

    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_apartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<PaymentEntry>>
  _paymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'tenants__id__payments__tenant_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.tenantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TenantsTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get contractStartDate => $composableBuilder(
    column: $table.contractStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get contractEndDate => $composableBuilder(
    column: $table.contractEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get moveOutDate => $composableBuilder(
    column: $table.moveOutDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApartmentsTableFilterComposer get apartmentId {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contractStartDate => $composableBuilder(
    column: $table.contractStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contractEndDate => $composableBuilder(
    column: $table.contractEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get moveOutDate => $composableBuilder(
    column: $table.moveOutDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApartmentsTableOrderingComposer get apartmentId {
    final $$ApartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TenantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get contractStartDate => $composableBuilder(
    column: $table.contractStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get contractEndDate => $composableBuilder(
    column: $table.contractEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get moveOutDate => $composableBuilder(
    column: $table.moveOutDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ApartmentsTableAnnotationComposer get apartmentId {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantsTable,
          TenantEntry,
          $$TenantsTableFilterComposer,
          $$TenantsTableOrderingComposer,
          $$TenantsTableAnnotationComposer,
          $$TenantsTableCreateCompanionBuilder,
          $$TenantsTableUpdateCompanionBuilder,
          (TenantEntry, $$TenantsTableReferences),
          TenantEntry,
          PrefetchHooks Function({bool apartmentId, bool paymentsRefs})
        > {
  $$TenantsTableTableManager(_$AppDatabase db, $TenantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> apartmentId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> nationalId = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> monthlyRent = const Value.absent(),
                Value<int> depositAmount = const Value.absent(),
                Value<DateTime> contractStartDate = const Value.absent(),
                Value<DateTime> contractEndDate = const Value.absent(),
                Value<int> paymentDueDay = const Value.absent(),
                Value<DateTime> moveInDate = const Value.absent(),
                Value<DateTime?> moveOutDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TenantsCompanion(
                id: id,
                apartmentId: apartmentId,
                fullName: fullName,
                phone: phone,
                nationalId: nationalId,
                address: address,
                monthlyRent: monthlyRent,
                depositAmount: depositAmount,
                contractStartDate: contractStartDate,
                contractEndDate: contractEndDate,
                paymentDueDay: paymentDueDay,
                moveInDate: moveInDate,
                moveOutDate: moveOutDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int apartmentId,
                required String fullName,
                required String phone,
                required String nationalId,
                required String address,
                required int monthlyRent,
                Value<int> depositAmount = const Value.absent(),
                required DateTime contractStartDate,
                required DateTime contractEndDate,
                required int paymentDueDay,
                required DateTime moveInDate,
                Value<DateTime?> moveOutDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TenantsCompanion.insert(
                id: id,
                apartmentId: apartmentId,
                fullName: fullName,
                phone: phone,
                nationalId: nationalId,
                address: address,
                monthlyRent: monthlyRent,
                depositAmount: depositAmount,
                contractStartDate: contractStartDate,
                contractEndDate: contractEndDate,
                paymentDueDay: paymentDueDay,
                moveInDate: moveInDate,
                moveOutDate: moveOutDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TenantsTable, TenantEntry>(table),
                  $$TenantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({apartmentId = false, paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paymentsRefs) db.payments],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (apartmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.apartmentId,
                        referencedTable: $$TenantsTableReferences
                            ._apartmentIdTable(db),
                        referencedColumn: $$TenantsTableReferences
                            ._apartmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentsRefs)
                    await $_getPrefetchedDataByColumns<
                      TenantEntry,
                      $TenantsTable,
                      PaymentEntry,
                      $PaymentsTable
                    >(
                      currentTable: table,
                      referencedTable: $$TenantsTableReferences
                          ._paymentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TenantsTableReferences(db, table, p0).paymentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'tenant_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TenantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantsTable,
      TenantEntry,
      $$TenantsTableFilterComposer,
      $$TenantsTableOrderingComposer,
      $$TenantsTableAnnotationComposer,
      $$TenantsTableCreateCompanionBuilder,
      $$TenantsTableUpdateCompanionBuilder,
      (TenantEntry, $$TenantsTableReferences),
      TenantEntry,
      PrefetchHooks Function({bool apartmentId, bool paymentsRefs})
    >;
typedef $$ApartmentSpecificationsTableCreateCompanionBuilder =
    ApartmentSpecificationsCompanion Function({
      Value<int> id,
      required int apartmentId,
      Value<int> bedrooms,
      Value<int> bathrooms,
      Value<int> livingRooms,
      Value<int> kitchens,
      Value<int> balconies,
      Value<bool> hasAc,
      Value<bool> hasParking,
      Value<String?> additionalFeatures,
    });
typedef $$ApartmentSpecificationsTableUpdateCompanionBuilder =
    ApartmentSpecificationsCompanion Function({
      Value<int> id,
      Value<int> apartmentId,
      Value<int> bedrooms,
      Value<int> bathrooms,
      Value<int> livingRooms,
      Value<int> kitchens,
      Value<int> balconies,
      Value<bool> hasAc,
      Value<bool> hasParking,
      Value<String?> additionalFeatures,
    });

final class $$ApartmentSpecificationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ApartmentSpecificationsTable,
          ApartmentSpecificationEntry
        > {
  $$ApartmentSpecificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ApartmentsTable _apartmentIdTable(_$AppDatabase db) => db.apartments
      .createAlias('apartment_specifications__apartment_id__apartments__id');

  $$ApartmentsTableProcessedTableManager get apartmentId {
    final $_column = $_itemColumn<int>('apartment_id')!;

    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_apartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ApartmentSpecificationsTableFilterComposer
    extends Composer<_$AppDatabase, $ApartmentSpecificationsTable> {
  $$ApartmentSpecificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedrooms => $composableBuilder(
    column: $table.bedrooms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bathrooms => $composableBuilder(
    column: $table.bathrooms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get livingRooms => $composableBuilder(
    column: $table.livingRooms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kitchens => $composableBuilder(
    column: $table.kitchens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balconies => $composableBuilder(
    column: $table.balconies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAc => $composableBuilder(
    column: $table.hasAc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasParking => $composableBuilder(
    column: $table.hasParking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get additionalFeatures => $composableBuilder(
    column: $table.additionalFeatures,
    builder: (column) => ColumnFilters(column),
  );

  $$ApartmentsTableFilterComposer get apartmentId {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApartmentSpecificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApartmentSpecificationsTable> {
  $$ApartmentSpecificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedrooms => $composableBuilder(
    column: $table.bedrooms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bathrooms => $composableBuilder(
    column: $table.bathrooms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get livingRooms => $composableBuilder(
    column: $table.livingRooms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kitchens => $composableBuilder(
    column: $table.kitchens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balconies => $composableBuilder(
    column: $table.balconies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAc => $composableBuilder(
    column: $table.hasAc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasParking => $composableBuilder(
    column: $table.hasParking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get additionalFeatures => $composableBuilder(
    column: $table.additionalFeatures,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApartmentsTableOrderingComposer get apartmentId {
    final $$ApartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApartmentSpecificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApartmentSpecificationsTable> {
  $$ApartmentSpecificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bedrooms =>
      $composableBuilder(column: $table.bedrooms, builder: (column) => column);

  GeneratedColumn<int> get bathrooms =>
      $composableBuilder(column: $table.bathrooms, builder: (column) => column);

  GeneratedColumn<int> get livingRooms => $composableBuilder(
    column: $table.livingRooms,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kitchens =>
      $composableBuilder(column: $table.kitchens, builder: (column) => column);

  GeneratedColumn<int> get balconies =>
      $composableBuilder(column: $table.balconies, builder: (column) => column);

  GeneratedColumn<bool> get hasAc =>
      $composableBuilder(column: $table.hasAc, builder: (column) => column);

  GeneratedColumn<bool> get hasParking => $composableBuilder(
    column: $table.hasParking,
    builder: (column) => column,
  );

  GeneratedColumn<String> get additionalFeatures => $composableBuilder(
    column: $table.additionalFeatures,
    builder: (column) => column,
  );

  $$ApartmentsTableAnnotationComposer get apartmentId {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApartmentSpecificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApartmentSpecificationsTable,
          ApartmentSpecificationEntry,
          $$ApartmentSpecificationsTableFilterComposer,
          $$ApartmentSpecificationsTableOrderingComposer,
          $$ApartmentSpecificationsTableAnnotationComposer,
          $$ApartmentSpecificationsTableCreateCompanionBuilder,
          $$ApartmentSpecificationsTableUpdateCompanionBuilder,
          (
            ApartmentSpecificationEntry,
            $$ApartmentSpecificationsTableReferences,
          ),
          ApartmentSpecificationEntry,
          PrefetchHooks Function({bool apartmentId})
        > {
  $$ApartmentSpecificationsTableTableManager(
    _$AppDatabase db,
    $ApartmentSpecificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApartmentSpecificationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ApartmentSpecificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ApartmentSpecificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> apartmentId = const Value.absent(),
                Value<int> bedrooms = const Value.absent(),
                Value<int> bathrooms = const Value.absent(),
                Value<int> livingRooms = const Value.absent(),
                Value<int> kitchens = const Value.absent(),
                Value<int> balconies = const Value.absent(),
                Value<bool> hasAc = const Value.absent(),
                Value<bool> hasParking = const Value.absent(),
                Value<String?> additionalFeatures = const Value.absent(),
              }) => ApartmentSpecificationsCompanion(
                id: id,
                apartmentId: apartmentId,
                bedrooms: bedrooms,
                bathrooms: bathrooms,
                livingRooms: livingRooms,
                kitchens: kitchens,
                balconies: balconies,
                hasAc: hasAc,
                hasParking: hasParking,
                additionalFeatures: additionalFeatures,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int apartmentId,
                Value<int> bedrooms = const Value.absent(),
                Value<int> bathrooms = const Value.absent(),
                Value<int> livingRooms = const Value.absent(),
                Value<int> kitchens = const Value.absent(),
                Value<int> balconies = const Value.absent(),
                Value<bool> hasAc = const Value.absent(),
                Value<bool> hasParking = const Value.absent(),
                Value<String?> additionalFeatures = const Value.absent(),
              }) => ApartmentSpecificationsCompanion.insert(
                id: id,
                apartmentId: apartmentId,
                bedrooms: bedrooms,
                bathrooms: bathrooms,
                livingRooms: livingRooms,
                kitchens: kitchens,
                balconies: balconies,
                hasAc: hasAc,
                hasParking: hasParking,
                additionalFeatures: additionalFeatures,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ApartmentSpecificationsTable,
                    ApartmentSpecificationEntry
                  >(table),
                  $$ApartmentSpecificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({apartmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (apartmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.apartmentId,
                        referencedTable:
                            $$ApartmentSpecificationsTableReferences
                                ._apartmentIdTable(db),
                        referencedColumn:
                            $$ApartmentSpecificationsTableReferences
                                ._apartmentIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ApartmentSpecificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApartmentSpecificationsTable,
      ApartmentSpecificationEntry,
      $$ApartmentSpecificationsTableFilterComposer,
      $$ApartmentSpecificationsTableOrderingComposer,
      $$ApartmentSpecificationsTableAnnotationComposer,
      $$ApartmentSpecificationsTableCreateCompanionBuilder,
      $$ApartmentSpecificationsTableUpdateCompanionBuilder,
      (ApartmentSpecificationEntry, $$ApartmentSpecificationsTableReferences),
      ApartmentSpecificationEntry,
      PrefetchHooks Function({bool apartmentId})
    >;
typedef $$ServicesTableCreateCompanionBuilder = ServicesCompanion Function({
  Value<int> id,
  required int apartmentId,
  required ServiceType serviceType,
  Value<double?> previousReading,
  Value<double?> currentReading,
  Value<double> consumption,
  Value<int> unitPrice,
  required int totalAmount,
  required DateTime billingDate,
  required DateTime dueDate,
  required PayerResponsibility payerResponsibility,
  Value<String?> notes,
  required DateTime createdAt,
});
typedef $$ServicesTableUpdateCompanionBuilder = ServicesCompanion Function({
  Value<int> id,
  Value<int> apartmentId,
  Value<ServiceType> serviceType,
  Value<double?> previousReading,
  Value<double?> currentReading,
  Value<double> consumption,
  Value<int> unitPrice,
  Value<int> totalAmount,
  Value<DateTime> billingDate,
  Value<DateTime> dueDate,
  Value<PayerResponsibility> payerResponsibility,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$ServicesTableReferences
    extends BaseReferences<_$AppDatabase, $ServicesTable, ServiceEntry> {
  $$ServicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApartmentsTable _apartmentIdTable(_$AppDatabase db) =>
      db.apartments.createAlias('services__apartment_id__apartments__id');

  $$ApartmentsTableProcessedTableManager get apartmentId {
    final $_column = $_itemColumn<int>('apartment_id')!;

    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_apartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<PaymentEntry>>
  _paymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'services__id__payments__service_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServiceType, ServiceType, String>
  get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get previousReading => $composableBuilder(
    column: $table.previousReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentReading => $composableBuilder(
    column: $table.currentReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consumption => $composableBuilder(
    column: $table.consumption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get billingDate => $composableBuilder(
    column: $table.billingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PayerResponsibility,
    PayerResponsibility,
    String
  >
  get payerResponsibility => $composableBuilder(
    column: $table.payerResponsibility,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApartmentsTableFilterComposer get apartmentId {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousReading => $composableBuilder(
    column: $table.previousReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentReading => $composableBuilder(
    column: $table.currentReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consumption => $composableBuilder(
    column: $table.consumption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get billingDate => $composableBuilder(
    column: $table.billingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payerResponsibility => $composableBuilder(
    column: $table.payerResponsibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApartmentsTableOrderingComposer get apartmentId {
    final $$ApartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServiceType, String> get serviceType =>
      $composableBuilder(
        column: $table.serviceType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get previousReading => $composableBuilder(
    column: $table.previousReading,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentReading => $composableBuilder(
    column: $table.currentReading,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consumption => $composableBuilder(
    column: $table.consumption,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get billingDate => $composableBuilder(
    column: $table.billingDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PayerResponsibility, String>
  get payerResponsibility => $composableBuilder(
    column: $table.payerResponsibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ApartmentsTableAnnotationComposer get apartmentId {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          ServiceEntry,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (ServiceEntry, $$ServicesTableReferences),
          ServiceEntry,
          PrefetchHooks Function({bool apartmentId, bool paymentsRefs})
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> apartmentId = const Value.absent(),
                Value<ServiceType> serviceType = const Value.absent(),
                Value<double?> previousReading = const Value.absent(),
                Value<double?> currentReading = const Value.absent(),
                Value<double> consumption = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<DateTime> billingDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<PayerResponsibility> payerResponsibility =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                apartmentId: apartmentId,
                serviceType: serviceType,
                previousReading: previousReading,
                currentReading: currentReading,
                consumption: consumption,
                unitPrice: unitPrice,
                totalAmount: totalAmount,
                billingDate: billingDate,
                dueDate: dueDate,
                payerResponsibility: payerResponsibility,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int apartmentId,
                required ServiceType serviceType,
                Value<double?> previousReading = const Value.absent(),
                Value<double?> currentReading = const Value.absent(),
                Value<double> consumption = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                required int totalAmount,
                required DateTime billingDate,
                required DateTime dueDate,
                required PayerResponsibility payerResponsibility,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
              }) => ServicesCompanion.insert(
                id: id,
                apartmentId: apartmentId,
                serviceType: serviceType,
                previousReading: previousReading,
                currentReading: currentReading,
                consumption: consumption,
                unitPrice: unitPrice,
                totalAmount: totalAmount,
                billingDate: billingDate,
                dueDate: dueDate,
                payerResponsibility: payerResponsibility,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServicesTable, ServiceEntry>(table),
                  $$ServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({apartmentId = false, paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paymentsRefs) db.payments],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (apartmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.apartmentId,
                        referencedTable: $$ServicesTableReferences
                            ._apartmentIdTable(db),
                        referencedColumn: $$ServicesTableReferences
                            ._apartmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentsRefs)
                    await $_getPrefetchedDataByColumns<
                      ServiceEntry,
                      $ServicesTable,
                      PaymentEntry,
                      $PaymentsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ServicesTableReferences
                          ._paymentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ServicesTableReferences(db, table, p0).paymentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'service_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      ServiceEntry,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (ServiceEntry, $$ServicesTableReferences),
      ServiceEntry,
      PrefetchHooks Function({bool apartmentId, bool paymentsRefs})
    >;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int apartmentId,
  Value<int?> tenantId,
  Value<int?> serviceId,
  required PaymentType paymentType,
  required int amount,
  Value<DateTime?> dueDate,
  required DateTime paymentDate,
  required PayerResponsibility paidBy,
  required PaymentMethod paymentMethod,
  Value<String?> billingPeriod,
  Value<String?> referenceNumber,
  Value<String?> notes,
  required DateTime createdAt,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> apartmentId,
  Value<int?> tenantId,
  Value<int?> serviceId,
  Value<PaymentType> paymentType,
  Value<int> amount,
  Value<DateTime?> dueDate,
  Value<DateTime> paymentDate,
  Value<PayerResponsibility> paidBy,
  Value<PaymentMethod> paymentMethod,
  Value<String?> billingPeriod,
  Value<String?> referenceNumber,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, PaymentEntry> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApartmentsTable _apartmentIdTable(_$AppDatabase db) =>
      db.apartments.createAlias('payments__apartment_id__apartments__id');

  $$ApartmentsTableProcessedTableManager get apartmentId {
    final $_column = $_itemColumn<int>('apartment_id')!;

    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_apartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TenantsTable _tenantIdTable(_$AppDatabase db) =>
      db.tenants.createAlias('payments__tenant_id__tenants__id');

  $$TenantsTableProcessedTableManager? get tenantId {
    final $_column = $_itemColumn<int>('tenant_id');
    if ($_column == null) return null;
    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tenantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServicesTable _serviceIdTable(_$AppDatabase db) =>
      db.services.createAlias('payments__service_id__services__id');

  $$ServicesTableProcessedTableManager? get serviceId {
    final $_column = $_itemColumn<int>('service_id');
    if ($_column == null) return null;
    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentType, PaymentType, String>
  get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PayerResponsibility,
    PayerResponsibility,
    String
  >
  get paidBy => $composableBuilder(
    column: $table.paidBy,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMethod, PaymentMethod, String>
  get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get billingPeriod => $composableBuilder(
    column: $table.billingPeriod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApartmentsTableFilterComposer get apartmentId {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableFilterComposer get tenantId {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableFilterComposer get serviceId {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidBy => $composableBuilder(
    column: $table.paidBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingPeriod => $composableBuilder(
    column: $table.billingPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApartmentsTableOrderingComposer get apartmentId {
    final $$ApartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableOrderingComposer get tenantId {
    final $$TenantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableOrderingComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableOrderingComposer get serviceId {
    final $$ServicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableOrderingComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentType, String> get paymentType =>
      $composableBuilder(
        column: $table.paymentType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PayerResponsibility, String> get paidBy =>
      $composableBuilder(column: $table.paidBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMethod, String> get paymentMethod =>
      $composableBuilder(
        column: $table.paymentMethod,
        builder: (column) => column,
      );

  GeneratedColumn<String> get billingPeriod => $composableBuilder(
    column: $table.billingPeriod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ApartmentsTableAnnotationComposer get apartmentId {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableAnnotationComposer get tenantId {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableAnnotationComposer get serviceId {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          PaymentEntry,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (PaymentEntry, $$PaymentsTableReferences),
          PaymentEntry,
          PrefetchHooks Function({
            bool apartmentId,
            bool tenantId,
            bool serviceId,
          })
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> apartmentId = const Value.absent(),
                Value<int?> tenantId = const Value.absent(),
                Value<int?> serviceId = const Value.absent(),
                Value<PaymentType> paymentType = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<PayerResponsibility> paidBy = const Value.absent(),
                Value<PaymentMethod> paymentMethod = const Value.absent(),
                Value<String?> billingPeriod = const Value.absent(),
                Value<String?> referenceNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                apartmentId: apartmentId,
                tenantId: tenantId,
                serviceId: serviceId,
                paymentType: paymentType,
                amount: amount,
                dueDate: dueDate,
                paymentDate: paymentDate,
                paidBy: paidBy,
                paymentMethod: paymentMethod,
                billingPeriod: billingPeriod,
                referenceNumber: referenceNumber,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int apartmentId,
                Value<int?> tenantId = const Value.absent(),
                Value<int?> serviceId = const Value.absent(),
                required PaymentType paymentType,
                required int amount,
                Value<DateTime?> dueDate = const Value.absent(),
                required DateTime paymentDate,
                required PayerResponsibility paidBy,
                required PaymentMethod paymentMethod,
                Value<String?> billingPeriod = const Value.absent(),
                Value<String?> referenceNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
              }) => PaymentsCompanion.insert(
                id: id,
                apartmentId: apartmentId,
                tenantId: tenantId,
                serviceId: serviceId,
                paymentType: paymentType,
                amount: amount,
                dueDate: dueDate,
                paymentDate: paymentDate,
                paidBy: paidBy,
                paymentMethod: paymentMethod,
                billingPeriod: billingPeriod,
                referenceNumber: referenceNumber,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentsTable, PaymentEntry>(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({apartmentId = false, tenantId = false, serviceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (apartmentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.apartmentId,
                            referencedTable: $$PaymentsTableReferences
                                ._apartmentIdTable(db),
                            referencedColumn: $$PaymentsTableReferences
                                ._apartmentIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (tenantId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tenantId,
                            referencedTable: $$PaymentsTableReferences
                                ._tenantIdTable(db),
                            referencedColumn: $$PaymentsTableReferences
                                ._tenantIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (serviceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.serviceId,
                            referencedTable: $$PaymentsTableReferences
                                ._serviceIdTable(db),
                            referencedColumn: $$PaymentsTableReferences
                                ._serviceIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      PaymentEntry,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (PaymentEntry, $$PaymentsTableReferences),
      PaymentEntry,
      PrefetchHooks Function({bool apartmentId, bool tenantId, bool serviceId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$ApartmentsTableTableManager get apartments =>
      $$ApartmentsTableTableManager(_db, _db.apartments);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db, _db.tenants);
  $$ApartmentSpecificationsTableTableManager get apartmentSpecifications =>
      $$ApartmentSpecificationsTableTableManager(
        _db,
        _db.apartmentSpecifications,
      );
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
}
