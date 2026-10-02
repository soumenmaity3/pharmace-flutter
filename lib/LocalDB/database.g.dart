// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MedicineTableTable extends MedicineTable
    with TableInfo<$MedicineTableTable, MedicineTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medNameMeta = const VerificationMeta(
    'medName',
  );
  @override
  late final GeneratedColumn<String> medName = GeneratedColumn<String>(
    'med_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genericNameMeta = const VerificationMeta(
    'genericName',
  );
  @override
  late final GeneratedColumn<String> genericName = GeneratedColumn<String>(
    'generic_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageFormMeta = const VerificationMeta(
    'dosageForm',
  );
  @override
  late final GeneratedColumn<String> dosageForm = GeneratedColumn<String>(
    'dosage_form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleMeta = const VerificationMeta(
    'schedule',
  );
  @override
  late final GeneratedColumn<String> schedule = GeneratedColumn<String>(
    'schedule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NONE'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batchNoMeta = const VerificationMeta(
    'batchNo',
  );
  @override
  late final GeneratedColumn<String> batchNo = GeneratedColumn<String>(
    'batch_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avLooseMeta = const VerificationMeta(
    'avLoose',
  );
  @override
  late final GeneratedColumn<bool> avLoose = GeneratedColumn<bool>(
    'av_loose',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("av_loose" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _looseQuantityMeta = const VerificationMeta(
    'looseQuantity',
  );
  @override
  late final GeneratedColumn<int> looseQuantity = GeneratedColumn<int>(
    'loose_quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalLooseInStripMeta = const VerificationMeta(
    'totalLooseInStrip',
  );
  @override
  late final GeneratedColumn<int> totalLooseInStrip = GeneratedColumn<int>(
    'total_loose_in_strip',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minStockLevelMeta = const VerificationMeta(
    'minStockLevel',
  );
  @override
  late final GeneratedColumn<int> minStockLevel = GeneratedColumn<int>(
    'min_stock_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxStockLevelMeta = const VerificationMeta(
    'maxStockLevel',
  );
  @override
  late final GeneratedColumn<int> maxStockLevel = GeneratedColumn<int>(
    'max_stock_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _stockStatusMeta = const VerificationMeta(
    'stockStatus',
  );
  @override
  late final GeneratedColumn<String> stockStatus = GeneratedColumn<String>(
    'stock_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inStock'),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _mrpMeta = const VerificationMeta('mrp');
  @override
  late final GeneratedColumn<double> mrp = GeneratedColumn<double>(
    'mrp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _manufactureDateMeta = const VerificationMeta(
    'manufactureDate',
  );
  @override
  late final GeneratedColumn<String> manufactureDate = GeneratedColumn<String>(
    'manufacture_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<String> expiryDate = GeneratedColumn<String>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierMeta = const VerificationMeta(
    'supplier',
  );
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
    'supplier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addDateMeta = const VerificationMeta(
    'addDate',
  );
  @override
  late final GeneratedColumn<String> addDate = GeneratedColumn<String>(
    'add_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updateDateMeta = const VerificationMeta(
    'updateDate',
  );
  @override
  late final GeneratedColumn<String> updateDate = GeneratedColumn<String>(
    'update_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
    'shop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedByMeta = const VerificationMeta(
    'addedBy',
  );
  @override
  late final GeneratedColumn<String> addedBy = GeneratedColumn<String>(
    'added_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medName,
    genericName,
    brand,
    category,
    strength,
    dosageForm,
    schedule,
    imageUrl,
    batchNo,
    quantity,
    avLoose,
    looseQuantity,
    totalLooseInStrip,
    minStockLevel,
    maxStockLevel,
    stockStatus,
    purchasePrice,
    sellingPrice,
    mrp,
    manufactureDate,
    expiryDate,
    supplier,
    addDate,
    updateDate,
    shopId,
    addedBy,
    updatedBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicineTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('med_name')) {
      context.handle(
        _medNameMeta,
        medName.isAcceptableOrUnknown(data['med_name']!, _medNameMeta),
      );
    } else if (isInserting) {
      context.missing(_medNameMeta);
    }
    if (data.containsKey('generic_name')) {
      context.handle(
        _genericNameMeta,
        genericName.isAcceptableOrUnknown(
          data['generic_name']!,
          _genericNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_genericNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    } else if (isInserting) {
      context.missing(_strengthMeta);
    }
    if (data.containsKey('dosage_form')) {
      context.handle(
        _dosageFormMeta,
        dosageForm.isAcceptableOrUnknown(data['dosage_form']!, _dosageFormMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageFormMeta);
    }
    if (data.containsKey('schedule')) {
      context.handle(
        _scheduleMeta,
        schedule.isAcceptableOrUnknown(data['schedule']!, _scheduleMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('batch_no')) {
      context.handle(
        _batchNoMeta,
        batchNo.isAcceptableOrUnknown(data['batch_no']!, _batchNoMeta),
      );
    } else if (isInserting) {
      context.missing(_batchNoMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('av_loose')) {
      context.handle(
        _avLooseMeta,
        avLoose.isAcceptableOrUnknown(data['av_loose']!, _avLooseMeta),
      );
    }
    if (data.containsKey('loose_quantity')) {
      context.handle(
        _looseQuantityMeta,
        looseQuantity.isAcceptableOrUnknown(
          data['loose_quantity']!,
          _looseQuantityMeta,
        ),
      );
    }
    if (data.containsKey('total_loose_in_strip')) {
      context.handle(
        _totalLooseInStripMeta,
        totalLooseInStrip.isAcceptableOrUnknown(
          data['total_loose_in_strip']!,
          _totalLooseInStripMeta,
        ),
      );
    }
    if (data.containsKey('min_stock_level')) {
      context.handle(
        _minStockLevelMeta,
        minStockLevel.isAcceptableOrUnknown(
          data['min_stock_level']!,
          _minStockLevelMeta,
        ),
      );
    }
    if (data.containsKey('max_stock_level')) {
      context.handle(
        _maxStockLevelMeta,
        maxStockLevel.isAcceptableOrUnknown(
          data['max_stock_level']!,
          _maxStockLevelMeta,
        ),
      );
    }
    if (data.containsKey('stock_status')) {
      context.handle(
        _stockStatusMeta,
        stockStatus.isAcceptableOrUnknown(
          data['stock_status']!,
          _stockStatusMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    if (data.containsKey('mrp')) {
      context.handle(
        _mrpMeta,
        mrp.isAcceptableOrUnknown(data['mrp']!, _mrpMeta),
      );
    }
    if (data.containsKey('manufacture_date')) {
      context.handle(
        _manufactureDateMeta,
        manufactureDate.isAcceptableOrUnknown(
          data['manufacture_date']!,
          _manufactureDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manufactureDateMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('supplier')) {
      context.handle(
        _supplierMeta,
        supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta),
      );
    }
    if (data.containsKey('add_date')) {
      context.handle(
        _addDateMeta,
        addDate.isAcceptableOrUnknown(data['add_date']!, _addDateMeta),
      );
    }
    if (data.containsKey('update_date')) {
      context.handle(
        _updateDateMeta,
        updateDate.isAcceptableOrUnknown(data['update_date']!, _updateDateMeta),
      );
    }
    if (data.containsKey('shop_id')) {
      context.handle(
        _shopIdMeta,
        shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta),
      );
    }
    if (data.containsKey('added_by')) {
      context.handle(
        _addedByMeta,
        addedBy.isAcceptableOrUnknown(data['added_by']!, _addedByMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}med_name'],
      )!,
      genericName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generic_name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      )!,
      dosageForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage_form'],
      )!,
      schedule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      batchNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_no'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      avLoose: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}av_loose'],
      )!,
      looseQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loose_quantity'],
      ),
      totalLooseInStrip: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_loose_in_strip'],
      ),
      minStockLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_stock_level'],
      )!,
      maxStockLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_stock_level'],
      )!,
      stockStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stock_status'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}selling_price'],
      )!,
      mrp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mrp'],
      )!,
      manufactureDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacture_date'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_date'],
      )!,
      supplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier'],
      ),
      addDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}add_date'],
      ),
      updateDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}update_date'],
      ),
      shopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_id'],
      ),
      addedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_by'],
      ),
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
    );
  }

  @override
  $MedicineTableTable createAlias(String alias) {
    return $MedicineTableTable(attachedDatabase, alias);
  }
}

class MedicineTableData extends DataClass
    implements Insertable<MedicineTableData> {
  final String id;
  final String medName;
  final String genericName;
  final String brand;
  final String category;
  final String strength;
  final String dosageForm;
  final String schedule;
  final String? imageUrl;
  final String batchNo;
  final int quantity;
  final bool avLoose;
  final int? looseQuantity;
  final int? totalLooseInStrip;
  final int minStockLevel;
  final int maxStockLevel;
  final String stockStatus;
  final double purchasePrice;
  final double sellingPrice;
  final double mrp;
  final String manufactureDate;
  final String expiryDate;
  final String? supplier;
  final String? addDate;
  final String? updateDate;
  final String? shopId;
  final String? addedBy;
  final String? updatedBy;
  const MedicineTableData({
    required this.id,
    required this.medName,
    required this.genericName,
    required this.brand,
    required this.category,
    required this.strength,
    required this.dosageForm,
    required this.schedule,
    this.imageUrl,
    required this.batchNo,
    required this.quantity,
    required this.avLoose,
    this.looseQuantity,
    this.totalLooseInStrip,
    required this.minStockLevel,
    required this.maxStockLevel,
    required this.stockStatus,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.mrp,
    required this.manufactureDate,
    required this.expiryDate,
    this.supplier,
    this.addDate,
    this.updateDate,
    this.shopId,
    this.addedBy,
    this.updatedBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['med_name'] = Variable<String>(medName);
    map['generic_name'] = Variable<String>(genericName);
    map['brand'] = Variable<String>(brand);
    map['category'] = Variable<String>(category);
    map['strength'] = Variable<String>(strength);
    map['dosage_form'] = Variable<String>(dosageForm);
    map['schedule'] = Variable<String>(schedule);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['batch_no'] = Variable<String>(batchNo);
    map['quantity'] = Variable<int>(quantity);
    map['av_loose'] = Variable<bool>(avLoose);
    if (!nullToAbsent || looseQuantity != null) {
      map['loose_quantity'] = Variable<int>(looseQuantity);
    }
    if (!nullToAbsent || totalLooseInStrip != null) {
      map['total_loose_in_strip'] = Variable<int>(totalLooseInStrip);
    }
    map['min_stock_level'] = Variable<int>(minStockLevel);
    map['max_stock_level'] = Variable<int>(maxStockLevel);
    map['stock_status'] = Variable<String>(stockStatus);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['mrp'] = Variable<double>(mrp);
    map['manufacture_date'] = Variable<String>(manufactureDate);
    map['expiry_date'] = Variable<String>(expiryDate);
    if (!nullToAbsent || supplier != null) {
      map['supplier'] = Variable<String>(supplier);
    }
    if (!nullToAbsent || addDate != null) {
      map['add_date'] = Variable<String>(addDate);
    }
    if (!nullToAbsent || updateDate != null) {
      map['update_date'] = Variable<String>(updateDate);
    }
    if (!nullToAbsent || shopId != null) {
      map['shop_id'] = Variable<String>(shopId);
    }
    if (!nullToAbsent || addedBy != null) {
      map['added_by'] = Variable<String>(addedBy);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    return map;
  }

  MedicineTableCompanion toCompanion(bool nullToAbsent) {
    return MedicineTableCompanion(
      id: Value(id),
      medName: Value(medName),
      genericName: Value(genericName),
      brand: Value(brand),
      category: Value(category),
      strength: Value(strength),
      dosageForm: Value(dosageForm),
      schedule: Value(schedule),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      batchNo: Value(batchNo),
      quantity: Value(quantity),
      avLoose: Value(avLoose),
      looseQuantity: looseQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(looseQuantity),
      totalLooseInStrip: totalLooseInStrip == null && nullToAbsent
          ? const Value.absent()
          : Value(totalLooseInStrip),
      minStockLevel: Value(minStockLevel),
      maxStockLevel: Value(maxStockLevel),
      stockStatus: Value(stockStatus),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      mrp: Value(mrp),
      manufactureDate: Value(manufactureDate),
      expiryDate: Value(expiryDate),
      supplier: supplier == null && nullToAbsent
          ? const Value.absent()
          : Value(supplier),
      addDate: addDate == null && nullToAbsent
          ? const Value.absent()
          : Value(addDate),
      updateDate: updateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(updateDate),
      shopId: shopId == null && nullToAbsent
          ? const Value.absent()
          : Value(shopId),
      addedBy: addedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(addedBy),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
    );
  }

  factory MedicineTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineTableData(
      id: serializer.fromJson<String>(json['id']),
      medName: serializer.fromJson<String>(json['medName']),
      genericName: serializer.fromJson<String>(json['genericName']),
      brand: serializer.fromJson<String>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      strength: serializer.fromJson<String>(json['strength']),
      dosageForm: serializer.fromJson<String>(json['dosageForm']),
      schedule: serializer.fromJson<String>(json['schedule']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      batchNo: serializer.fromJson<String>(json['batchNo']),
      quantity: serializer.fromJson<int>(json['quantity']),
      avLoose: serializer.fromJson<bool>(json['avLoose']),
      looseQuantity: serializer.fromJson<int?>(json['looseQuantity']),
      totalLooseInStrip: serializer.fromJson<int?>(json['totalLooseInStrip']),
      minStockLevel: serializer.fromJson<int>(json['minStockLevel']),
      maxStockLevel: serializer.fromJson<int>(json['maxStockLevel']),
      stockStatus: serializer.fromJson<String>(json['stockStatus']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      mrp: serializer.fromJson<double>(json['mrp']),
      manufactureDate: serializer.fromJson<String>(json['manufactureDate']),
      expiryDate: serializer.fromJson<String>(json['expiryDate']),
      supplier: serializer.fromJson<String?>(json['supplier']),
      addDate: serializer.fromJson<String?>(json['addDate']),
      updateDate: serializer.fromJson<String?>(json['updateDate']),
      shopId: serializer.fromJson<String?>(json['shopId']),
      addedBy: serializer.fromJson<String?>(json['addedBy']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medName': serializer.toJson<String>(medName),
      'genericName': serializer.toJson<String>(genericName),
      'brand': serializer.toJson<String>(brand),
      'category': serializer.toJson<String>(category),
      'strength': serializer.toJson<String>(strength),
      'dosageForm': serializer.toJson<String>(dosageForm),
      'schedule': serializer.toJson<String>(schedule),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'batchNo': serializer.toJson<String>(batchNo),
      'quantity': serializer.toJson<int>(quantity),
      'avLoose': serializer.toJson<bool>(avLoose),
      'looseQuantity': serializer.toJson<int?>(looseQuantity),
      'totalLooseInStrip': serializer.toJson<int?>(totalLooseInStrip),
      'minStockLevel': serializer.toJson<int>(minStockLevel),
      'maxStockLevel': serializer.toJson<int>(maxStockLevel),
      'stockStatus': serializer.toJson<String>(stockStatus),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'mrp': serializer.toJson<double>(mrp),
      'manufactureDate': serializer.toJson<String>(manufactureDate),
      'expiryDate': serializer.toJson<String>(expiryDate),
      'supplier': serializer.toJson<String?>(supplier),
      'addDate': serializer.toJson<String?>(addDate),
      'updateDate': serializer.toJson<String?>(updateDate),
      'shopId': serializer.toJson<String?>(shopId),
      'addedBy': serializer.toJson<String?>(addedBy),
      'updatedBy': serializer.toJson<String?>(updatedBy),
    };
  }

  MedicineTableData copyWith({
    String? id,
    String? medName,
    String? genericName,
    String? brand,
    String? category,
    String? strength,
    String? dosageForm,
    String? schedule,
    Value<String?> imageUrl = const Value.absent(),
    String? batchNo,
    int? quantity,
    bool? avLoose,
    Value<int?> looseQuantity = const Value.absent(),
    Value<int?> totalLooseInStrip = const Value.absent(),
    int? minStockLevel,
    int? maxStockLevel,
    String? stockStatus,
    double? purchasePrice,
    double? sellingPrice,
    double? mrp,
    String? manufactureDate,
    String? expiryDate,
    Value<String?> supplier = const Value.absent(),
    Value<String?> addDate = const Value.absent(),
    Value<String?> updateDate = const Value.absent(),
    Value<String?> shopId = const Value.absent(),
    Value<String?> addedBy = const Value.absent(),
    Value<String?> updatedBy = const Value.absent(),
  }) => MedicineTableData(
    id: id ?? this.id,
    medName: medName ?? this.medName,
    genericName: genericName ?? this.genericName,
    brand: brand ?? this.brand,
    category: category ?? this.category,
    strength: strength ?? this.strength,
    dosageForm: dosageForm ?? this.dosageForm,
    schedule: schedule ?? this.schedule,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    batchNo: batchNo ?? this.batchNo,
    quantity: quantity ?? this.quantity,
    avLoose: avLoose ?? this.avLoose,
    looseQuantity: looseQuantity.present
        ? looseQuantity.value
        : this.looseQuantity,
    totalLooseInStrip: totalLooseInStrip.present
        ? totalLooseInStrip.value
        : this.totalLooseInStrip,
    minStockLevel: minStockLevel ?? this.minStockLevel,
    maxStockLevel: maxStockLevel ?? this.maxStockLevel,
    stockStatus: stockStatus ?? this.stockStatus,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    mrp: mrp ?? this.mrp,
    manufactureDate: manufactureDate ?? this.manufactureDate,
    expiryDate: expiryDate ?? this.expiryDate,
    supplier: supplier.present ? supplier.value : this.supplier,
    addDate: addDate.present ? addDate.value : this.addDate,
    updateDate: updateDate.present ? updateDate.value : this.updateDate,
    shopId: shopId.present ? shopId.value : this.shopId,
    addedBy: addedBy.present ? addedBy.value : this.addedBy,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
  );
  MedicineTableData copyWithCompanion(MedicineTableCompanion data) {
    return MedicineTableData(
      id: data.id.present ? data.id.value : this.id,
      medName: data.medName.present ? data.medName.value : this.medName,
      genericName: data.genericName.present
          ? data.genericName.value
          : this.genericName,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      strength: data.strength.present ? data.strength.value : this.strength,
      dosageForm: data.dosageForm.present
          ? data.dosageForm.value
          : this.dosageForm,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      batchNo: data.batchNo.present ? data.batchNo.value : this.batchNo,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      avLoose: data.avLoose.present ? data.avLoose.value : this.avLoose,
      looseQuantity: data.looseQuantity.present
          ? data.looseQuantity.value
          : this.looseQuantity,
      totalLooseInStrip: data.totalLooseInStrip.present
          ? data.totalLooseInStrip.value
          : this.totalLooseInStrip,
      minStockLevel: data.minStockLevel.present
          ? data.minStockLevel.value
          : this.minStockLevel,
      maxStockLevel: data.maxStockLevel.present
          ? data.maxStockLevel.value
          : this.maxStockLevel,
      stockStatus: data.stockStatus.present
          ? data.stockStatus.value
          : this.stockStatus,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      mrp: data.mrp.present ? data.mrp.value : this.mrp,
      manufactureDate: data.manufactureDate.present
          ? data.manufactureDate.value
          : this.manufactureDate,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      addDate: data.addDate.present ? data.addDate.value : this.addDate,
      updateDate: data.updateDate.present
          ? data.updateDate.value
          : this.updateDate,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      addedBy: data.addedBy.present ? data.addedBy.value : this.addedBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineTableData(')
          ..write('id: $id, ')
          ..write('medName: $medName, ')
          ..write('genericName: $genericName, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('schedule: $schedule, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('batchNo: $batchNo, ')
          ..write('quantity: $quantity, ')
          ..write('avLoose: $avLoose, ')
          ..write('looseQuantity: $looseQuantity, ')
          ..write('totalLooseInStrip: $totalLooseInStrip, ')
          ..write('minStockLevel: $minStockLevel, ')
          ..write('maxStockLevel: $maxStockLevel, ')
          ..write('stockStatus: $stockStatus, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('mrp: $mrp, ')
          ..write('manufactureDate: $manufactureDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('supplier: $supplier, ')
          ..write('addDate: $addDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('shopId: $shopId, ')
          ..write('addedBy: $addedBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    medName,
    genericName,
    brand,
    category,
    strength,
    dosageForm,
    schedule,
    imageUrl,
    batchNo,
    quantity,
    avLoose,
    looseQuantity,
    totalLooseInStrip,
    minStockLevel,
    maxStockLevel,
    stockStatus,
    purchasePrice,
    sellingPrice,
    mrp,
    manufactureDate,
    expiryDate,
    supplier,
    addDate,
    updateDate,
    shopId,
    addedBy,
    updatedBy,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineTableData &&
          other.id == this.id &&
          other.medName == this.medName &&
          other.genericName == this.genericName &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.strength == this.strength &&
          other.dosageForm == this.dosageForm &&
          other.schedule == this.schedule &&
          other.imageUrl == this.imageUrl &&
          other.batchNo == this.batchNo &&
          other.quantity == this.quantity &&
          other.avLoose == this.avLoose &&
          other.looseQuantity == this.looseQuantity &&
          other.totalLooseInStrip == this.totalLooseInStrip &&
          other.minStockLevel == this.minStockLevel &&
          other.maxStockLevel == this.maxStockLevel &&
          other.stockStatus == this.stockStatus &&
          other.purchasePrice == this.purchasePrice &&
          other.sellingPrice == this.sellingPrice &&
          other.mrp == this.mrp &&
          other.manufactureDate == this.manufactureDate &&
          other.expiryDate == this.expiryDate &&
          other.supplier == this.supplier &&
          other.addDate == this.addDate &&
          other.updateDate == this.updateDate &&
          other.shopId == this.shopId &&
          other.addedBy == this.addedBy &&
          other.updatedBy == this.updatedBy);
}

class MedicineTableCompanion extends UpdateCompanion<MedicineTableData> {
  final Value<String> id;
  final Value<String> medName;
  final Value<String> genericName;
  final Value<String> brand;
  final Value<String> category;
  final Value<String> strength;
  final Value<String> dosageForm;
  final Value<String> schedule;
  final Value<String?> imageUrl;
  final Value<String> batchNo;
  final Value<int> quantity;
  final Value<bool> avLoose;
  final Value<int?> looseQuantity;
  final Value<int?> totalLooseInStrip;
  final Value<int> minStockLevel;
  final Value<int> maxStockLevel;
  final Value<String> stockStatus;
  final Value<double> purchasePrice;
  final Value<double> sellingPrice;
  final Value<double> mrp;
  final Value<String> manufactureDate;
  final Value<String> expiryDate;
  final Value<String?> supplier;
  final Value<String?> addDate;
  final Value<String?> updateDate;
  final Value<String?> shopId;
  final Value<String?> addedBy;
  final Value<String?> updatedBy;
  final Value<int> rowid;
  const MedicineTableCompanion({
    this.id = const Value.absent(),
    this.medName = const Value.absent(),
    this.genericName = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.schedule = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.batchNo = const Value.absent(),
    this.quantity = const Value.absent(),
    this.avLoose = const Value.absent(),
    this.looseQuantity = const Value.absent(),
    this.totalLooseInStrip = const Value.absent(),
    this.minStockLevel = const Value.absent(),
    this.maxStockLevel = const Value.absent(),
    this.stockStatus = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.mrp = const Value.absent(),
    this.manufactureDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.supplier = const Value.absent(),
    this.addDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.shopId = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicineTableCompanion.insert({
    required String id,
    required String medName,
    required String genericName,
    required String brand,
    required String category,
    required String strength,
    required String dosageForm,
    this.schedule = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required String batchNo,
    this.quantity = const Value.absent(),
    this.avLoose = const Value.absent(),
    this.looseQuantity = const Value.absent(),
    this.totalLooseInStrip = const Value.absent(),
    this.minStockLevel = const Value.absent(),
    this.maxStockLevel = const Value.absent(),
    this.stockStatus = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.mrp = const Value.absent(),
    required String manufactureDate,
    required String expiryDate,
    this.supplier = const Value.absent(),
    this.addDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.shopId = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medName = Value(medName),
       genericName = Value(genericName),
       brand = Value(brand),
       category = Value(category),
       strength = Value(strength),
       dosageForm = Value(dosageForm),
       batchNo = Value(batchNo),
       manufactureDate = Value(manufactureDate),
       expiryDate = Value(expiryDate);
  static Insertable<MedicineTableData> custom({
    Expression<String>? id,
    Expression<String>? medName,
    Expression<String>? genericName,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<String>? strength,
    Expression<String>? dosageForm,
    Expression<String>? schedule,
    Expression<String>? imageUrl,
    Expression<String>? batchNo,
    Expression<int>? quantity,
    Expression<bool>? avLoose,
    Expression<int>? looseQuantity,
    Expression<int>? totalLooseInStrip,
    Expression<int>? minStockLevel,
    Expression<int>? maxStockLevel,
    Expression<String>? stockStatus,
    Expression<double>? purchasePrice,
    Expression<double>? sellingPrice,
    Expression<double>? mrp,
    Expression<String>? manufactureDate,
    Expression<String>? expiryDate,
    Expression<String>? supplier,
    Expression<String>? addDate,
    Expression<String>? updateDate,
    Expression<String>? shopId,
    Expression<String>? addedBy,
    Expression<String>? updatedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medName != null) 'med_name': medName,
      if (genericName != null) 'generic_name': genericName,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (strength != null) 'strength': strength,
      if (dosageForm != null) 'dosage_form': dosageForm,
      if (schedule != null) 'schedule': schedule,
      if (imageUrl != null) 'image_url': imageUrl,
      if (batchNo != null) 'batch_no': batchNo,
      if (quantity != null) 'quantity': quantity,
      if (avLoose != null) 'av_loose': avLoose,
      if (looseQuantity != null) 'loose_quantity': looseQuantity,
      if (totalLooseInStrip != null) 'total_loose_in_strip': totalLooseInStrip,
      if (minStockLevel != null) 'min_stock_level': minStockLevel,
      if (maxStockLevel != null) 'max_stock_level': maxStockLevel,
      if (stockStatus != null) 'stock_status': stockStatus,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (mrp != null) 'mrp': mrp,
      if (manufactureDate != null) 'manufacture_date': manufactureDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (supplier != null) 'supplier': supplier,
      if (addDate != null) 'add_date': addDate,
      if (updateDate != null) 'update_date': updateDate,
      if (shopId != null) 'shop_id': shopId,
      if (addedBy != null) 'added_by': addedBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicineTableCompanion copyWith({
    Value<String>? id,
    Value<String>? medName,
    Value<String>? genericName,
    Value<String>? brand,
    Value<String>? category,
    Value<String>? strength,
    Value<String>? dosageForm,
    Value<String>? schedule,
    Value<String?>? imageUrl,
    Value<String>? batchNo,
    Value<int>? quantity,
    Value<bool>? avLoose,
    Value<int?>? looseQuantity,
    Value<int?>? totalLooseInStrip,
    Value<int>? minStockLevel,
    Value<int>? maxStockLevel,
    Value<String>? stockStatus,
    Value<double>? purchasePrice,
    Value<double>? sellingPrice,
    Value<double>? mrp,
    Value<String>? manufactureDate,
    Value<String>? expiryDate,
    Value<String?>? supplier,
    Value<String?>? addDate,
    Value<String?>? updateDate,
    Value<String?>? shopId,
    Value<String?>? addedBy,
    Value<String?>? updatedBy,
    Value<int>? rowid,
  }) {
    return MedicineTableCompanion(
      id: id ?? this.id,
      medName: medName ?? this.medName,
      genericName: genericName ?? this.genericName,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      strength: strength ?? this.strength,
      dosageForm: dosageForm ?? this.dosageForm,
      schedule: schedule ?? this.schedule,
      imageUrl: imageUrl ?? this.imageUrl,
      batchNo: batchNo ?? this.batchNo,
      quantity: quantity ?? this.quantity,
      avLoose: avLoose ?? this.avLoose,
      looseQuantity: looseQuantity ?? this.looseQuantity,
      totalLooseInStrip: totalLooseInStrip ?? this.totalLooseInStrip,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      maxStockLevel: maxStockLevel ?? this.maxStockLevel,
      stockStatus: stockStatus ?? this.stockStatus,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate ?? this.expiryDate,
      supplier: supplier ?? this.supplier,
      addDate: addDate ?? this.addDate,
      updateDate: updateDate ?? this.updateDate,
      shopId: shopId ?? this.shopId,
      addedBy: addedBy ?? this.addedBy,
      updatedBy: updatedBy ?? this.updatedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medName.present) {
      map['med_name'] = Variable<String>(medName.value);
    }
    if (genericName.present) {
      map['generic_name'] = Variable<String>(genericName.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (dosageForm.present) {
      map['dosage_form'] = Variable<String>(dosageForm.value);
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(schedule.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (batchNo.present) {
      map['batch_no'] = Variable<String>(batchNo.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (avLoose.present) {
      map['av_loose'] = Variable<bool>(avLoose.value);
    }
    if (looseQuantity.present) {
      map['loose_quantity'] = Variable<int>(looseQuantity.value);
    }
    if (totalLooseInStrip.present) {
      map['total_loose_in_strip'] = Variable<int>(totalLooseInStrip.value);
    }
    if (minStockLevel.present) {
      map['min_stock_level'] = Variable<int>(minStockLevel.value);
    }
    if (maxStockLevel.present) {
      map['max_stock_level'] = Variable<int>(maxStockLevel.value);
    }
    if (stockStatus.present) {
      map['stock_status'] = Variable<String>(stockStatus.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (mrp.present) {
      map['mrp'] = Variable<double>(mrp.value);
    }
    if (manufactureDate.present) {
      map['manufacture_date'] = Variable<String>(manufactureDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (addDate.present) {
      map['add_date'] = Variable<String>(addDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<String>(updateDate.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (addedBy.present) {
      map['added_by'] = Variable<String>(addedBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineTableCompanion(')
          ..write('id: $id, ')
          ..write('medName: $medName, ')
          ..write('genericName: $genericName, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('schedule: $schedule, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('batchNo: $batchNo, ')
          ..write('quantity: $quantity, ')
          ..write('avLoose: $avLoose, ')
          ..write('looseQuantity: $looseQuantity, ')
          ..write('totalLooseInStrip: $totalLooseInStrip, ')
          ..write('minStockLevel: $minStockLevel, ')
          ..write('maxStockLevel: $maxStockLevel, ')
          ..write('stockStatus: $stockStatus, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('mrp: $mrp, ')
          ..write('manufactureDate: $manufactureDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('supplier: $supplier, ')
          ..write('addDate: $addDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('shopId: $shopId, ')
          ..write('addedBy: $addedBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillTableTable extends BillTable
    with TableInfo<$BillTableTable, BillTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _invNoMeta = const VerificationMeta('invNo');
  @override
  late final GeneratedColumn<String> invNo = GeneratedColumn<String>(
    'inv_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerTypeMeta = const VerificationMeta(
    'customerType',
  );
  @override
  late final GeneratedColumn<int> customerType = GeneratedColumn<int>(
    'customer_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    invNo,
    customerType,
    customerName,
    date,
    value,
    paymentType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('inv_no')) {
      context.handle(
        _invNoMeta,
        invNo.isAcceptableOrUnknown(data['inv_no']!, _invNoMeta),
      );
    } else if (isInserting) {
      context.missing(_invNoMeta);
    }
    if (data.containsKey('customer_type')) {
      context.handle(
        _customerTypeMeta,
        customerType.isAcceptableOrUnknown(
          data['customer_type']!,
          _customerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerTypeMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {invNo};
  @override
  BillTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillTableData(
      invNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inv_no'],
      )!,
      customerType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_type'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
    );
  }

  @override
  $BillTableTable createAlias(String alias) {
    return $BillTableTable(attachedDatabase, alias);
  }
}

class BillTableData extends DataClass implements Insertable<BillTableData> {
  final String invNo;
  final int customerType;
  final String customerName;
  final String date;
  final double value;
  final String paymentType;
  const BillTableData({
    required this.invNo,
    required this.customerType,
    required this.customerName,
    required this.date,
    required this.value,
    required this.paymentType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['inv_no'] = Variable<String>(invNo);
    map['customer_type'] = Variable<int>(customerType);
    map['customer_name'] = Variable<String>(customerName);
    map['date'] = Variable<String>(date);
    map['value'] = Variable<double>(value);
    map['payment_type'] = Variable<String>(paymentType);
    return map;
  }

  BillTableCompanion toCompanion(bool nullToAbsent) {
    return BillTableCompanion(
      invNo: Value(invNo),
      customerType: Value(customerType),
      customerName: Value(customerName),
      date: Value(date),
      value: Value(value),
      paymentType: Value(paymentType),
    );
  }

  factory BillTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillTableData(
      invNo: serializer.fromJson<String>(json['invNo']),
      customerType: serializer.fromJson<int>(json['customerType']),
      customerName: serializer.fromJson<String>(json['customerName']),
      date: serializer.fromJson<String>(json['date']),
      value: serializer.fromJson<double>(json['value']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'invNo': serializer.toJson<String>(invNo),
      'customerType': serializer.toJson<int>(customerType),
      'customerName': serializer.toJson<String>(customerName),
      'date': serializer.toJson<String>(date),
      'value': serializer.toJson<double>(value),
      'paymentType': serializer.toJson<String>(paymentType),
    };
  }

  BillTableData copyWith({
    String? invNo,
    int? customerType,
    String? customerName,
    String? date,
    double? value,
    String? paymentType,
  }) => BillTableData(
    invNo: invNo ?? this.invNo,
    customerType: customerType ?? this.customerType,
    customerName: customerName ?? this.customerName,
    date: date ?? this.date,
    value: value ?? this.value,
    paymentType: paymentType ?? this.paymentType,
  );
  BillTableData copyWithCompanion(BillTableCompanion data) {
    return BillTableData(
      invNo: data.invNo.present ? data.invNo.value : this.invNo,
      customerType: data.customerType.present
          ? data.customerType.value
          : this.customerType,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      date: data.date.present ? data.date.value : this.date,
      value: data.value.present ? data.value.value : this.value,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillTableData(')
          ..write('invNo: $invNo, ')
          ..write('customerType: $customerType, ')
          ..write('customerName: $customerName, ')
          ..write('date: $date, ')
          ..write('value: $value, ')
          ..write('paymentType: $paymentType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(invNo, customerType, customerName, date, value, paymentType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillTableData &&
          other.invNo == this.invNo &&
          other.customerType == this.customerType &&
          other.customerName == this.customerName &&
          other.date == this.date &&
          other.value == this.value &&
          other.paymentType == this.paymentType);
}

class BillTableCompanion extends UpdateCompanion<BillTableData> {
  final Value<String> invNo;
  final Value<int> customerType;
  final Value<String> customerName;
  final Value<String> date;
  final Value<double> value;
  final Value<String> paymentType;
  final Value<int> rowid;
  const BillTableCompanion({
    this.invNo = const Value.absent(),
    this.customerType = const Value.absent(),
    this.customerName = const Value.absent(),
    this.date = const Value.absent(),
    this.value = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillTableCompanion.insert({
    required String invNo,
    required int customerType,
    required String customerName,
    required String date,
    required double value,
    required String paymentType,
    this.rowid = const Value.absent(),
  }) : invNo = Value(invNo),
       customerType = Value(customerType),
       customerName = Value(customerName),
       date = Value(date),
       value = Value(value),
       paymentType = Value(paymentType);
  static Insertable<BillTableData> custom({
    Expression<String>? invNo,
    Expression<int>? customerType,
    Expression<String>? customerName,
    Expression<String>? date,
    Expression<double>? value,
    Expression<String>? paymentType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (invNo != null) 'inv_no': invNo,
      if (customerType != null) 'customer_type': customerType,
      if (customerName != null) 'customer_name': customerName,
      if (date != null) 'date': date,
      if (value != null) 'value': value,
      if (paymentType != null) 'payment_type': paymentType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillTableCompanion copyWith({
    Value<String>? invNo,
    Value<int>? customerType,
    Value<String>? customerName,
    Value<String>? date,
    Value<double>? value,
    Value<String>? paymentType,
    Value<int>? rowid,
  }) {
    return BillTableCompanion(
      invNo: invNo ?? this.invNo,
      customerType: customerType ?? this.customerType,
      customerName: customerName ?? this.customerName,
      date: date ?? this.date,
      value: value ?? this.value,
      paymentType: paymentType ?? this.paymentType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (invNo.present) {
      map['inv_no'] = Variable<String>(invNo.value);
    }
    if (customerType.present) {
      map['customer_type'] = Variable<int>(customerType.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillTableCompanion(')
          ..write('invNo: $invNo, ')
          ..write('customerType: $customerType, ')
          ..write('customerName: $customerName, ')
          ..write('date: $date, ')
          ..write('value: $value, ')
          ..write('paymentType: $paymentType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillMedicineTableTable extends BillMedicineTable
    with TableInfo<$BillMedicineTableTable, BillMedicineTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillMedicineTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _invNoMeta = const VerificationMeta('invNo');
  @override
  late final GeneratedColumn<String> invNo = GeneratedColumn<String>(
    'inv_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bill_table (inv_no) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicineNameMeta = const VerificationMeta(
    'medicineName',
  );
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
    'medicine_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stripMeta = const VerificationMeta('strip');
  @override
  late final GeneratedColumn<int> strip = GeneratedColumn<int>(
    'strip',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _looseMeta = const VerificationMeta('loose');
  @override
  late final GeneratedColumn<int> loose = GeneratedColumn<int>(
    'loose',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _looseQtyMeta = const VerificationMeta(
    'looseQty',
  );
  @override
  late final GeneratedColumn<int> looseQty = GeneratedColumn<int>(
    'loose_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLooseAvailableMeta = const VerificationMeta(
    'isLooseAvailable',
  );
  @override
  late final GeneratedColumn<bool> isLooseAvailable = GeneratedColumn<bool>(
    'is_loose_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_loose_available" IN (0, 1))',
    ),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagPriceMeta = const VerificationMeta(
    'tagPrice',
  );
  @override
  late final GeneratedColumn<double> tagPrice = GeneratedColumn<double>(
    'tag_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invNo,
    medicineId,
    medicineName,
    strip,
    loose,
    looseQty,
    isLooseAvailable,
    price,
    tagPrice,
    totalPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_medicine_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillMedicineTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inv_no')) {
      context.handle(
        _invNoMeta,
        invNo.isAcceptableOrUnknown(data['inv_no']!, _invNoMeta),
      );
    } else if (isInserting) {
      context.missing(_invNoMeta);
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
        _medicineNameMeta,
        medicineName.isAcceptableOrUnknown(
          data['medicine_name']!,
          _medicineNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('strip')) {
      context.handle(
        _stripMeta,
        strip.isAcceptableOrUnknown(data['strip']!, _stripMeta),
      );
    } else if (isInserting) {
      context.missing(_stripMeta);
    }
    if (data.containsKey('loose')) {
      context.handle(
        _looseMeta,
        loose.isAcceptableOrUnknown(data['loose']!, _looseMeta),
      );
    }
    if (data.containsKey('loose_qty')) {
      context.handle(
        _looseQtyMeta,
        looseQty.isAcceptableOrUnknown(data['loose_qty']!, _looseQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_looseQtyMeta);
    }
    if (data.containsKey('is_loose_available')) {
      context.handle(
        _isLooseAvailableMeta,
        isLooseAvailable.isAcceptableOrUnknown(
          data['is_loose_available']!,
          _isLooseAvailableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isLooseAvailableMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('tag_price')) {
      context.handle(
        _tagPriceMeta,
        tagPrice.isAcceptableOrUnknown(data['tag_price']!, _tagPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_tagPriceMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillMedicineTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillMedicineTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inv_no'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_id'],
      )!,
      medicineName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_name'],
      )!,
      strip: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strip'],
      )!,
      loose: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loose'],
      ),
      looseQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loose_qty'],
      )!,
      isLooseAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_loose_available'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      tagPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tag_price'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
    );
  }

  @override
  $BillMedicineTableTable createAlias(String alias) {
    return $BillMedicineTableTable(attachedDatabase, alias);
  }
}

class BillMedicineTableData extends DataClass
    implements Insertable<BillMedicineTableData> {
  final int id;
  final String invNo;
  final String medicineId;
  final String medicineName;
  final int strip;
  final int? loose;
  final int looseQty;
  final bool isLooseAvailable;
  final double price;
  final double tagPrice;
  final double totalPrice;
  const BillMedicineTableData({
    required this.id,
    required this.invNo,
    required this.medicineId,
    required this.medicineName,
    required this.strip,
    this.loose,
    required this.looseQty,
    required this.isLooseAvailable,
    required this.price,
    required this.tagPrice,
    required this.totalPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['inv_no'] = Variable<String>(invNo);
    map['medicine_id'] = Variable<String>(medicineId);
    map['medicine_name'] = Variable<String>(medicineName);
    map['strip'] = Variable<int>(strip);
    if (!nullToAbsent || loose != null) {
      map['loose'] = Variable<int>(loose);
    }
    map['loose_qty'] = Variable<int>(looseQty);
    map['is_loose_available'] = Variable<bool>(isLooseAvailable);
    map['price'] = Variable<double>(price);
    map['tag_price'] = Variable<double>(tagPrice);
    map['total_price'] = Variable<double>(totalPrice);
    return map;
  }

  BillMedicineTableCompanion toCompanion(bool nullToAbsent) {
    return BillMedicineTableCompanion(
      id: Value(id),
      invNo: Value(invNo),
      medicineId: Value(medicineId),
      medicineName: Value(medicineName),
      strip: Value(strip),
      loose: loose == null && nullToAbsent
          ? const Value.absent()
          : Value(loose),
      looseQty: Value(looseQty),
      isLooseAvailable: Value(isLooseAvailable),
      price: Value(price),
      tagPrice: Value(tagPrice),
      totalPrice: Value(totalPrice),
    );
  }

  factory BillMedicineTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillMedicineTableData(
      id: serializer.fromJson<int>(json['id']),
      invNo: serializer.fromJson<String>(json['invNo']),
      medicineId: serializer.fromJson<String>(json['medicineId']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      strip: serializer.fromJson<int>(json['strip']),
      loose: serializer.fromJson<int?>(json['loose']),
      looseQty: serializer.fromJson<int>(json['looseQty']),
      isLooseAvailable: serializer.fromJson<bool>(json['isLooseAvailable']),
      price: serializer.fromJson<double>(json['price']),
      tagPrice: serializer.fromJson<double>(json['tagPrice']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invNo': serializer.toJson<String>(invNo),
      'medicineId': serializer.toJson<String>(medicineId),
      'medicineName': serializer.toJson<String>(medicineName),
      'strip': serializer.toJson<int>(strip),
      'loose': serializer.toJson<int?>(loose),
      'looseQty': serializer.toJson<int>(looseQty),
      'isLooseAvailable': serializer.toJson<bool>(isLooseAvailable),
      'price': serializer.toJson<double>(price),
      'tagPrice': serializer.toJson<double>(tagPrice),
      'totalPrice': serializer.toJson<double>(totalPrice),
    };
  }

  BillMedicineTableData copyWith({
    int? id,
    String? invNo,
    String? medicineId,
    String? medicineName,
    int? strip,
    Value<int?> loose = const Value.absent(),
    int? looseQty,
    bool? isLooseAvailable,
    double? price,
    double? tagPrice,
    double? totalPrice,
  }) => BillMedicineTableData(
    id: id ?? this.id,
    invNo: invNo ?? this.invNo,
    medicineId: medicineId ?? this.medicineId,
    medicineName: medicineName ?? this.medicineName,
    strip: strip ?? this.strip,
    loose: loose.present ? loose.value : this.loose,
    looseQty: looseQty ?? this.looseQty,
    isLooseAvailable: isLooseAvailable ?? this.isLooseAvailable,
    price: price ?? this.price,
    tagPrice: tagPrice ?? this.tagPrice,
    totalPrice: totalPrice ?? this.totalPrice,
  );
  BillMedicineTableData copyWithCompanion(BillMedicineTableCompanion data) {
    return BillMedicineTableData(
      id: data.id.present ? data.id.value : this.id,
      invNo: data.invNo.present ? data.invNo.value : this.invNo,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      strip: data.strip.present ? data.strip.value : this.strip,
      loose: data.loose.present ? data.loose.value : this.loose,
      looseQty: data.looseQty.present ? data.looseQty.value : this.looseQty,
      isLooseAvailable: data.isLooseAvailable.present
          ? data.isLooseAvailable.value
          : this.isLooseAvailable,
      price: data.price.present ? data.price.value : this.price,
      tagPrice: data.tagPrice.present ? data.tagPrice.value : this.tagPrice,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillMedicineTableData(')
          ..write('id: $id, ')
          ..write('invNo: $invNo, ')
          ..write('medicineId: $medicineId, ')
          ..write('medicineName: $medicineName, ')
          ..write('strip: $strip, ')
          ..write('loose: $loose, ')
          ..write('looseQty: $looseQty, ')
          ..write('isLooseAvailable: $isLooseAvailable, ')
          ..write('price: $price, ')
          ..write('tagPrice: $tagPrice, ')
          ..write('totalPrice: $totalPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invNo,
    medicineId,
    medicineName,
    strip,
    loose,
    looseQty,
    isLooseAvailable,
    price,
    tagPrice,
    totalPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillMedicineTableData &&
          other.id == this.id &&
          other.invNo == this.invNo &&
          other.medicineId == this.medicineId &&
          other.medicineName == this.medicineName &&
          other.strip == this.strip &&
          other.loose == this.loose &&
          other.looseQty == this.looseQty &&
          other.isLooseAvailable == this.isLooseAvailable &&
          other.price == this.price &&
          other.tagPrice == this.tagPrice &&
          other.totalPrice == this.totalPrice);
}

class BillMedicineTableCompanion
    extends UpdateCompanion<BillMedicineTableData> {
  final Value<int> id;
  final Value<String> invNo;
  final Value<String> medicineId;
  final Value<String> medicineName;
  final Value<int> strip;
  final Value<int?> loose;
  final Value<int> looseQty;
  final Value<bool> isLooseAvailable;
  final Value<double> price;
  final Value<double> tagPrice;
  final Value<double> totalPrice;
  const BillMedicineTableCompanion({
    this.id = const Value.absent(),
    this.invNo = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.strip = const Value.absent(),
    this.loose = const Value.absent(),
    this.looseQty = const Value.absent(),
    this.isLooseAvailable = const Value.absent(),
    this.price = const Value.absent(),
    this.tagPrice = const Value.absent(),
    this.totalPrice = const Value.absent(),
  });
  BillMedicineTableCompanion.insert({
    this.id = const Value.absent(),
    required String invNo,
    required String medicineId,
    required String medicineName,
    required int strip,
    this.loose = const Value.absent(),
    required int looseQty,
    required bool isLooseAvailable,
    required double price,
    required double tagPrice,
    required double totalPrice,
  }) : invNo = Value(invNo),
       medicineId = Value(medicineId),
       medicineName = Value(medicineName),
       strip = Value(strip),
       looseQty = Value(looseQty),
       isLooseAvailable = Value(isLooseAvailable),
       price = Value(price),
       tagPrice = Value(tagPrice),
       totalPrice = Value(totalPrice);
  static Insertable<BillMedicineTableData> custom({
    Expression<int>? id,
    Expression<String>? invNo,
    Expression<String>? medicineId,
    Expression<String>? medicineName,
    Expression<int>? strip,
    Expression<int>? loose,
    Expression<int>? looseQty,
    Expression<bool>? isLooseAvailable,
    Expression<double>? price,
    Expression<double>? tagPrice,
    Expression<double>? totalPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invNo != null) 'inv_no': invNo,
      if (medicineId != null) 'medicine_id': medicineId,
      if (medicineName != null) 'medicine_name': medicineName,
      if (strip != null) 'strip': strip,
      if (loose != null) 'loose': loose,
      if (looseQty != null) 'loose_qty': looseQty,
      if (isLooseAvailable != null) 'is_loose_available': isLooseAvailable,
      if (price != null) 'price': price,
      if (tagPrice != null) 'tag_price': tagPrice,
      if (totalPrice != null) 'total_price': totalPrice,
    });
  }

  BillMedicineTableCompanion copyWith({
    Value<int>? id,
    Value<String>? invNo,
    Value<String>? medicineId,
    Value<String>? medicineName,
    Value<int>? strip,
    Value<int?>? loose,
    Value<int>? looseQty,
    Value<bool>? isLooseAvailable,
    Value<double>? price,
    Value<double>? tagPrice,
    Value<double>? totalPrice,
  }) {
    return BillMedicineTableCompanion(
      id: id ?? this.id,
      invNo: invNo ?? this.invNo,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      strip: strip ?? this.strip,
      loose: loose ?? this.loose,
      looseQty: looseQty ?? this.looseQty,
      isLooseAvailable: isLooseAvailable ?? this.isLooseAvailable,
      price: price ?? this.price,
      tagPrice: tagPrice ?? this.tagPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invNo.present) {
      map['inv_no'] = Variable<String>(invNo.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (strip.present) {
      map['strip'] = Variable<int>(strip.value);
    }
    if (loose.present) {
      map['loose'] = Variable<int>(loose.value);
    }
    if (looseQty.present) {
      map['loose_qty'] = Variable<int>(looseQty.value);
    }
    if (isLooseAvailable.present) {
      map['is_loose_available'] = Variable<bool>(isLooseAvailable.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (tagPrice.present) {
      map['tag_price'] = Variable<double>(tagPrice.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillMedicineTableCompanion(')
          ..write('id: $id, ')
          ..write('invNo: $invNo, ')
          ..write('medicineId: $medicineId, ')
          ..write('medicineName: $medicineName, ')
          ..write('strip: $strip, ')
          ..write('loose: $loose, ')
          ..write('looseQty: $looseQty, ')
          ..write('isLooseAvailable: $isLooseAvailable, ')
          ..write('price: $price, ')
          ..write('tagPrice: $tagPrice, ')
          ..write('totalPrice: $totalPrice')
          ..write(')'))
        .toString();
  }
}

class $OwnerAuthTableTable extends OwnerAuthTable
    with TableInfo<$OwnerAuthTableTable, OwnerAuthTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnerAuthTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isShopHaveMeta = const VerificationMeta(
    'isShopHave',
  );
  @override
  late final GeneratedColumn<bool> isShopHave = GeneratedColumn<bool>(
    'is_shop_have',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_shop_have" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedShopIdMeta = const VerificationMeta(
    'selectedShopId',
  );
  @override
  late final GeneratedColumn<String> selectedShopId = GeneratedColumn<String>(
    'selected_shop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    role,
    isShopHave,
    createdAt,
    selectedShopId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owner_auth_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnerAuthTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('is_shop_have')) {
      context.handle(
        _isShopHaveMeta,
        isShopHave.isAcceptableOrUnknown(
          data['is_shop_have']!,
          _isShopHaveMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('selected_shop_id')) {
      context.handle(
        _selectedShopIdMeta,
        selectedShopId.isAcceptableOrUnknown(
          data['selected_shop_id']!,
          _selectedShopIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OwnerAuthTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnerAuthTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isShopHave: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_shop_have'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      selectedShopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_shop_id'],
      ),
    );
  }

  @override
  $OwnerAuthTableTable createAlias(String alias) {
    return $OwnerAuthTableTable(attachedDatabase, alias);
  }
}

class OwnerAuthTableData extends DataClass
    implements Insertable<OwnerAuthTableData> {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isShopHave;
  final String? createdAt;
  final String? selectedShopId;
  const OwnerAuthTableData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isShopHave,
    this.createdAt,
    this.selectedShopId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['is_shop_have'] = Variable<bool>(isShopHave);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || selectedShopId != null) {
      map['selected_shop_id'] = Variable<String>(selectedShopId);
    }
    return map;
  }

  OwnerAuthTableCompanion toCompanion(bool nullToAbsent) {
    return OwnerAuthTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      role: Value(role),
      isShopHave: Value(isShopHave),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      selectedShopId: selectedShopId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedShopId),
    );
  }

  factory OwnerAuthTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnerAuthTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      isShopHave: serializer.fromJson<bool>(json['isShopHave']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      selectedShopId: serializer.fromJson<String?>(json['selectedShopId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'isShopHave': serializer.toJson<bool>(isShopHave),
      'createdAt': serializer.toJson<String?>(createdAt),
      'selectedShopId': serializer.toJson<String?>(selectedShopId),
    };
  }

  OwnerAuthTableData copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isShopHave,
    Value<String?> createdAt = const Value.absent(),
    Value<String?> selectedShopId = const Value.absent(),
  }) => OwnerAuthTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    isShopHave: isShopHave ?? this.isShopHave,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    selectedShopId: selectedShopId.present
        ? selectedShopId.value
        : this.selectedShopId,
  );
  OwnerAuthTableData copyWithCompanion(OwnerAuthTableCompanion data) {
    return OwnerAuthTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      isShopHave: data.isShopHave.present
          ? data.isShopHave.value
          : this.isShopHave,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      selectedShopId: data.selectedShopId.present
          ? data.selectedShopId.value
          : this.selectedShopId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnerAuthTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('isShopHave: $isShopHave, ')
          ..write('createdAt: $createdAt, ')
          ..write('selectedShopId: $selectedShopId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, role, isShopHave, createdAt, selectedShopId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnerAuthTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role &&
          other.isShopHave == this.isShopHave &&
          other.createdAt == this.createdAt &&
          other.selectedShopId == this.selectedShopId);
}

class OwnerAuthTableCompanion extends UpdateCompanion<OwnerAuthTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> role;
  final Value<bool> isShopHave;
  final Value<String?> createdAt;
  final Value<String?> selectedShopId;
  final Value<int> rowid;
  const OwnerAuthTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.isShopHave = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.selectedShopId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnerAuthTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String role,
    this.isShopHave = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.selectedShopId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       role = Value(role);
  static Insertable<OwnerAuthTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
    Expression<bool>? isShopHave,
    Expression<String>? createdAt,
    Expression<String>? selectedShopId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (isShopHave != null) 'is_shop_have': isShopHave,
      if (createdAt != null) 'created_at': createdAt,
      if (selectedShopId != null) 'selected_shop_id': selectedShopId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnerAuthTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? role,
    Value<bool>? isShopHave,
    Value<String?>? createdAt,
    Value<String?>? selectedShopId,
    Value<int>? rowid,
  }) {
    return OwnerAuthTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isShopHave: isShopHave ?? this.isShopHave,
      createdAt: createdAt ?? this.createdAt,
      selectedShopId: selectedShopId ?? this.selectedShopId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isShopHave.present) {
      map['is_shop_have'] = Variable<bool>(isShopHave.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (selectedShopId.present) {
      map['selected_shop_id'] = Variable<String>(selectedShopId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnerAuthTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('isShopHave: $isShopHave, ')
          ..write('createdAt: $createdAt, ')
          ..write('selectedShopId: $selectedShopId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopTableTable extends ShopTable
    with TableInfo<$ShopTableTable, ShopTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopNameMeta = const VerificationMeta(
    'shopName',
  );
  @override
  late final GeneratedColumn<String> shopName = GeneratedColumn<String>(
    'shop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopEmailMeta = const VerificationMeta(
    'shopEmail',
  );
  @override
  late final GeneratedColumn<String> shopEmail = GeneratedColumn<String>(
    'shop_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopCodeMeta = const VerificationMeta(
    'shopCode',
  );
  @override
  late final GeneratedColumn<String> shopCode = GeneratedColumn<String>(
    'shop_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
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
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseNumberMeta = const VerificationMeta(
    'licenseNumber',
  );
  @override
  late final GeneratedColumn<String> licenseNumber = GeneratedColumn<String>(
    'license_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstNumberMeta = const VerificationMeta(
    'gstNumber',
  );
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
    'gst_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verifyStatusMeta = const VerificationMeta(
    'verifyStatus',
  );
  @override
  late final GeneratedColumn<String> verifyStatus = GeneratedColumn<String>(
    'verify_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pending'),
  );
  static const VerificationMeta _isOwnerEmployeeMeta = const VerificationMeta(
    'isOwnerEmployee',
  );
  @override
  late final GeneratedColumn<bool> isOwnerEmployee = GeneratedColumn<bool>(
    'is_owner_employee',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_owner_employee" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOpenMeta = const VerificationMeta('isOpen');
  @override
  late final GeneratedColumn<bool> isOpen = GeneratedColumn<bool>(
    'is_open',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_open" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shopName,
    shopEmail,
    shopCode,
    phone,
    address,
    city,
    state,
    pincode,
    licenseNumber,
    gstNumber,
    verifyStatus,
    isOwnerEmployee,
    logoUrl,
    isOpen,
    ownerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shop_name')) {
      context.handle(
        _shopNameMeta,
        shopName.isAcceptableOrUnknown(data['shop_name']!, _shopNameMeta),
      );
    } else if (isInserting) {
      context.missing(_shopNameMeta);
    }
    if (data.containsKey('shop_email')) {
      context.handle(
        _shopEmailMeta,
        shopEmail.isAcceptableOrUnknown(data['shop_email']!, _shopEmailMeta),
      );
    } else if (isInserting) {
      context.missing(_shopEmailMeta);
    }
    if (data.containsKey('shop_code')) {
      context.handle(
        _shopCodeMeta,
        shopCode.isAcceptableOrUnknown(data['shop_code']!, _shopCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_shopCodeMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    } else if (isInserting) {
      context.missing(_pincodeMeta);
    }
    if (data.containsKey('license_number')) {
      context.handle(
        _licenseNumberMeta,
        licenseNumber.isAcceptableOrUnknown(
          data['license_number']!,
          _licenseNumberMeta,
        ),
      );
    }
    if (data.containsKey('gst_number')) {
      context.handle(
        _gstNumberMeta,
        gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta),
      );
    }
    if (data.containsKey('verify_status')) {
      context.handle(
        _verifyStatusMeta,
        verifyStatus.isAcceptableOrUnknown(
          data['verify_status']!,
          _verifyStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_owner_employee')) {
      context.handle(
        _isOwnerEmployeeMeta,
        isOwnerEmployee.isAcceptableOrUnknown(
          data['is_owner_employee']!,
          _isOwnerEmployeeMeta,
        ),
      );
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('is_open')) {
      context.handle(
        _isOpenMeta,
        isOpen.isAcceptableOrUnknown(data['is_open']!, _isOpenMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shopName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_name'],
      )!,
      shopEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_email'],
      )!,
      shopCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_code'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      )!,
      licenseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_number'],
      ),
      gstNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_number'],
      ),
      verifyStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verify_status'],
      )!,
      isOwnerEmployee: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_owner_employee'],
      )!,
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      isOpen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_open'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
    );
  }

  @override
  $ShopTableTable createAlias(String alias) {
    return $ShopTableTable(attachedDatabase, alias);
  }
}

class ShopTableData extends DataClass implements Insertable<ShopTableData> {
  final String id;
  final String shopName;
  final String shopEmail;
  final String shopCode;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? licenseNumber;
  final String? gstNumber;
  final String verifyStatus;
  final bool isOwnerEmployee;
  final String? logoUrl;
  final bool? isOpen;
  final String? ownerId;
  const ShopTableData({
    required this.id,
    required this.shopName,
    required this.shopEmail,
    required this.shopCode,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.licenseNumber,
    this.gstNumber,
    required this.verifyStatus,
    required this.isOwnerEmployee,
    this.logoUrl,
    this.isOpen,
    this.ownerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_name'] = Variable<String>(shopName);
    map['shop_email'] = Variable<String>(shopEmail);
    map['shop_code'] = Variable<String>(shopCode);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['city'] = Variable<String>(city);
    map['state'] = Variable<String>(state);
    map['pincode'] = Variable<String>(pincode);
    if (!nullToAbsent || licenseNumber != null) {
      map['license_number'] = Variable<String>(licenseNumber);
    }
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    map['verify_status'] = Variable<String>(verifyStatus);
    map['is_owner_employee'] = Variable<bool>(isOwnerEmployee);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || isOpen != null) {
      map['is_open'] = Variable<bool>(isOpen);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    return map;
  }

  ShopTableCompanion toCompanion(bool nullToAbsent) {
    return ShopTableCompanion(
      id: Value(id),
      shopName: Value(shopName),
      shopEmail: Value(shopEmail),
      shopCode: Value(shopCode),
      phone: Value(phone),
      address: Value(address),
      city: Value(city),
      state: Value(state),
      pincode: Value(pincode),
      licenseNumber: licenseNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseNumber),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      verifyStatus: Value(verifyStatus),
      isOwnerEmployee: Value(isOwnerEmployee),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      isOpen: isOpen == null && nullToAbsent
          ? const Value.absent()
          : Value(isOpen),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
    );
  }

  factory ShopTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopTableData(
      id: serializer.fromJson<String>(json['id']),
      shopName: serializer.fromJson<String>(json['shopName']),
      shopEmail: serializer.fromJson<String>(json['shopEmail']),
      shopCode: serializer.fromJson<String>(json['shopCode']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      city: serializer.fromJson<String>(json['city']),
      state: serializer.fromJson<String>(json['state']),
      pincode: serializer.fromJson<String>(json['pincode']),
      licenseNumber: serializer.fromJson<String?>(json['licenseNumber']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      verifyStatus: serializer.fromJson<String>(json['verifyStatus']),
      isOwnerEmployee: serializer.fromJson<bool>(json['isOwnerEmployee']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      isOpen: serializer.fromJson<bool?>(json['isOpen']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopName': serializer.toJson<String>(shopName),
      'shopEmail': serializer.toJson<String>(shopEmail),
      'shopCode': serializer.toJson<String>(shopCode),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'city': serializer.toJson<String>(city),
      'state': serializer.toJson<String>(state),
      'pincode': serializer.toJson<String>(pincode),
      'licenseNumber': serializer.toJson<String?>(licenseNumber),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'verifyStatus': serializer.toJson<String>(verifyStatus),
      'isOwnerEmployee': serializer.toJson<bool>(isOwnerEmployee),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'isOpen': serializer.toJson<bool?>(isOpen),
      'ownerId': serializer.toJson<String?>(ownerId),
    };
  }

  ShopTableData copyWith({
    String? id,
    String? shopName,
    String? shopEmail,
    String? shopCode,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? pincode,
    Value<String?> licenseNumber = const Value.absent(),
    Value<String?> gstNumber = const Value.absent(),
    String? verifyStatus,
    bool? isOwnerEmployee,
    Value<String?> logoUrl = const Value.absent(),
    Value<bool?> isOpen = const Value.absent(),
    Value<String?> ownerId = const Value.absent(),
  }) => ShopTableData(
    id: id ?? this.id,
    shopName: shopName ?? this.shopName,
    shopEmail: shopEmail ?? this.shopEmail,
    shopCode: shopCode ?? this.shopCode,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    city: city ?? this.city,
    state: state ?? this.state,
    pincode: pincode ?? this.pincode,
    licenseNumber: licenseNumber.present
        ? licenseNumber.value
        : this.licenseNumber,
    gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
    verifyStatus: verifyStatus ?? this.verifyStatus,
    isOwnerEmployee: isOwnerEmployee ?? this.isOwnerEmployee,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    isOpen: isOpen.present ? isOpen.value : this.isOpen,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
  );
  ShopTableData copyWithCompanion(ShopTableCompanion data) {
    return ShopTableData(
      id: data.id.present ? data.id.value : this.id,
      shopName: data.shopName.present ? data.shopName.value : this.shopName,
      shopEmail: data.shopEmail.present ? data.shopEmail.value : this.shopEmail,
      shopCode: data.shopCode.present ? data.shopCode.value : this.shopCode,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      licenseNumber: data.licenseNumber.present
          ? data.licenseNumber.value
          : this.licenseNumber,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      verifyStatus: data.verifyStatus.present
          ? data.verifyStatus.value
          : this.verifyStatus,
      isOwnerEmployee: data.isOwnerEmployee.present
          ? data.isOwnerEmployee.value
          : this.isOwnerEmployee,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      isOpen: data.isOpen.present ? data.isOpen.value : this.isOpen,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopTableData(')
          ..write('id: $id, ')
          ..write('shopName: $shopName, ')
          ..write('shopEmail: $shopEmail, ')
          ..write('shopCode: $shopCode, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pincode: $pincode, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('verifyStatus: $verifyStatus, ')
          ..write('isOwnerEmployee: $isOwnerEmployee, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('isOpen: $isOpen, ')
          ..write('ownerId: $ownerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shopName,
    shopEmail,
    shopCode,
    phone,
    address,
    city,
    state,
    pincode,
    licenseNumber,
    gstNumber,
    verifyStatus,
    isOwnerEmployee,
    logoUrl,
    isOpen,
    ownerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopTableData &&
          other.id == this.id &&
          other.shopName == this.shopName &&
          other.shopEmail == this.shopEmail &&
          other.shopCode == this.shopCode &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.city == this.city &&
          other.state == this.state &&
          other.pincode == this.pincode &&
          other.licenseNumber == this.licenseNumber &&
          other.gstNumber == this.gstNumber &&
          other.verifyStatus == this.verifyStatus &&
          other.isOwnerEmployee == this.isOwnerEmployee &&
          other.logoUrl == this.logoUrl &&
          other.isOpen == this.isOpen &&
          other.ownerId == this.ownerId);
}

class ShopTableCompanion extends UpdateCompanion<ShopTableData> {
  final Value<String> id;
  final Value<String> shopName;
  final Value<String> shopEmail;
  final Value<String> shopCode;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> city;
  final Value<String> state;
  final Value<String> pincode;
  final Value<String?> licenseNumber;
  final Value<String?> gstNumber;
  final Value<String> verifyStatus;
  final Value<bool> isOwnerEmployee;
  final Value<String?> logoUrl;
  final Value<bool?> isOpen;
  final Value<String?> ownerId;
  final Value<int> rowid;
  const ShopTableCompanion({
    this.id = const Value.absent(),
    this.shopName = const Value.absent(),
    this.shopEmail = const Value.absent(),
    this.shopCode = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.pincode = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.verifyStatus = const Value.absent(),
    this.isOwnerEmployee = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopTableCompanion.insert({
    required String id,
    required String shopName,
    required String shopEmail,
    required String shopCode,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    this.licenseNumber = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.verifyStatus = const Value.absent(),
    this.isOwnerEmployee = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shopName = Value(shopName),
       shopEmail = Value(shopEmail),
       shopCode = Value(shopCode),
       phone = Value(phone),
       address = Value(address),
       city = Value(city),
       state = Value(state),
       pincode = Value(pincode);
  static Insertable<ShopTableData> custom({
    Expression<String>? id,
    Expression<String>? shopName,
    Expression<String>? shopEmail,
    Expression<String>? shopCode,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? pincode,
    Expression<String>? licenseNumber,
    Expression<String>? gstNumber,
    Expression<String>? verifyStatus,
    Expression<bool>? isOwnerEmployee,
    Expression<String>? logoUrl,
    Expression<bool>? isOpen,
    Expression<String>? ownerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopName != null) 'shop_name': shopName,
      if (shopEmail != null) 'shop_email': shopEmail,
      if (shopCode != null) 'shop_code': shopCode,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (verifyStatus != null) 'verify_status': verifyStatus,
      if (isOwnerEmployee != null) 'is_owner_employee': isOwnerEmployee,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (isOpen != null) 'is_open': isOpen,
      if (ownerId != null) 'owner_id': ownerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopTableCompanion copyWith({
    Value<String>? id,
    Value<String>? shopName,
    Value<String>? shopEmail,
    Value<String>? shopCode,
    Value<String>? phone,
    Value<String>? address,
    Value<String>? city,
    Value<String>? state,
    Value<String>? pincode,
    Value<String?>? licenseNumber,
    Value<String?>? gstNumber,
    Value<String>? verifyStatus,
    Value<bool>? isOwnerEmployee,
    Value<String?>? logoUrl,
    Value<bool?>? isOpen,
    Value<String?>? ownerId,
    Value<int>? rowid,
  }) {
    return ShopTableCompanion(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      shopEmail: shopEmail ?? this.shopEmail,
      shopCode: shopCode ?? this.shopCode,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      gstNumber: gstNumber ?? this.gstNumber,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      isOwnerEmployee: isOwnerEmployee ?? this.isOwnerEmployee,
      logoUrl: logoUrl ?? this.logoUrl,
      isOpen: isOpen ?? this.isOpen,
      ownerId: ownerId ?? this.ownerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopName.present) {
      map['shop_name'] = Variable<String>(shopName.value);
    }
    if (shopEmail.present) {
      map['shop_email'] = Variable<String>(shopEmail.value);
    }
    if (shopCode.present) {
      map['shop_code'] = Variable<String>(shopCode.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (licenseNumber.present) {
      map['license_number'] = Variable<String>(licenseNumber.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (verifyStatus.present) {
      map['verify_status'] = Variable<String>(verifyStatus.value);
    }
    if (isOwnerEmployee.present) {
      map['is_owner_employee'] = Variable<bool>(isOwnerEmployee.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (isOpen.present) {
      map['is_open'] = Variable<bool>(isOpen.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopTableCompanion(')
          ..write('id: $id, ')
          ..write('shopName: $shopName, ')
          ..write('shopEmail: $shopEmail, ')
          ..write('shopCode: $shopCode, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pincode: $pincode, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('verifyStatus: $verifyStatus, ')
          ..write('isOwnerEmployee: $isOwnerEmployee, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('isOpen: $isOpen, ')
          ..write('ownerId: $ownerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeTableTable extends EmployeeTable
    with TableInfo<$EmployeeTableTable, EmployeeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Manager'),
  );
  static const VerificationMeta _isFromOwnerMeta = const VerificationMeta(
    'isFromOwner',
  );
  @override
  late final GeneratedColumn<bool> isFromOwner = GeneratedColumn<bool>(
    'is_from_owner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_from_owner" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
    'shop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    role,
    isFromOwner,
    shopId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('is_from_owner')) {
      context.handle(
        _isFromOwnerMeta,
        isFromOwner.isAcceptableOrUnknown(
          data['is_from_owner']!,
          _isFromOwnerMeta,
        ),
      );
    }
    if (data.containsKey('shop_id')) {
      context.handle(
        _shopIdMeta,
        shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta),
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
  EmployeeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isFromOwner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_from_owner'],
      )!,
      shopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EmployeeTableTable createAlias(String alias) {
    return $EmployeeTableTable(attachedDatabase, alias);
  }
}

class EmployeeTableData extends DataClass
    implements Insertable<EmployeeTableData> {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isFromOwner;
  final String? shopId;
  final String createdAt;
  const EmployeeTableData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isFromOwner,
    this.shopId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['is_from_owner'] = Variable<bool>(isFromOwner);
    if (!nullToAbsent || shopId != null) {
      map['shop_id'] = Variable<String>(shopId);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  EmployeeTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeeTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      role: Value(role),
      isFromOwner: Value(isFromOwner),
      shopId: shopId == null && nullToAbsent
          ? const Value.absent()
          : Value(shopId),
      createdAt: Value(createdAt),
    );
  }

  factory EmployeeTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      isFromOwner: serializer.fromJson<bool>(json['isFromOwner']),
      shopId: serializer.fromJson<String?>(json['shopId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'isFromOwner': serializer.toJson<bool>(isFromOwner),
      'shopId': serializer.toJson<String?>(shopId),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  EmployeeTableData copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isFromOwner,
    Value<String?> shopId = const Value.absent(),
    String? createdAt,
  }) => EmployeeTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    isFromOwner: isFromOwner ?? this.isFromOwner,
    shopId: shopId.present ? shopId.value : this.shopId,
    createdAt: createdAt ?? this.createdAt,
  );
  EmployeeTableData copyWithCompanion(EmployeeTableCompanion data) {
    return EmployeeTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      isFromOwner: data.isFromOwner.present
          ? data.isFromOwner.value
          : this.isFromOwner,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('isFromOwner: $isFromOwner, ')
          ..write('shopId: $shopId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, role, isFromOwner, shopId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role &&
          other.isFromOwner == this.isFromOwner &&
          other.shopId == this.shopId &&
          other.createdAt == this.createdAt);
}

class EmployeeTableCompanion extends UpdateCompanion<EmployeeTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> role;
  final Value<bool> isFromOwner;
  final Value<String?> shopId;
  final Value<String> createdAt;
  final Value<int> rowid;
  const EmployeeTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.isFromOwner = const Value.absent(),
    this.shopId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    this.role = const Value.absent(),
    this.isFromOwner = const Value.absent(),
    this.shopId = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       createdAt = Value(createdAt);
  static Insertable<EmployeeTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
    Expression<bool>? isFromOwner,
    Expression<String>? shopId,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (isFromOwner != null) 'is_from_owner': isFromOwner,
      if (shopId != null) 'shop_id': shopId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? role,
    Value<bool>? isFromOwner,
    Value<String?>? shopId,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return EmployeeTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isFromOwner: isFromOwner ?? this.isFromOwner,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isFromOwner.present) {
      map['is_from_owner'] = Variable<bool>(isFromOwner.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('isFromOwner: $isFromOwner, ')
          ..write('shopId: $shopId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicineTableTable medicineTable = $MedicineTableTable(this);
  late final $BillTableTable billTable = $BillTableTable(this);
  late final $BillMedicineTableTable billMedicineTable =
      $BillMedicineTableTable(this);
  late final $OwnerAuthTableTable ownerAuthTable = $OwnerAuthTableTable(this);
  late final $ShopTableTable shopTable = $ShopTableTable(this);
  late final $EmployeeTableTable employeeTable = $EmployeeTableTable(this);
  late final InventoryMedicineDao inventoryMedicineDao = InventoryMedicineDao(
    this as AppDatabase,
  );
  late final BillDao billDao = BillDao(this as AppDatabase);
  late final OwnerAuthDao ownerAuthDao = OwnerAuthDao(this as AppDatabase);
  late final ShopDao shopDao = ShopDao(this as AppDatabase);
  late final EmployeeDao employeeDao = EmployeeDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    medicineTable,
    billTable,
    billMedicineTable,
    ownerAuthTable,
    shopTable,
    employeeTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bill_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bill_medicine_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MedicineTableTableCreateCompanionBuilder =
    MedicineTableCompanion Function({
      required String id,
      required String medName,
      required String genericName,
      required String brand,
      required String category,
      required String strength,
      required String dosageForm,
      Value<String> schedule,
      Value<String?> imageUrl,
      required String batchNo,
      Value<int> quantity,
      Value<bool> avLoose,
      Value<int?> looseQuantity,
      Value<int?> totalLooseInStrip,
      Value<int> minStockLevel,
      Value<int> maxStockLevel,
      Value<String> stockStatus,
      Value<double> purchasePrice,
      Value<double> sellingPrice,
      Value<double> mrp,
      required String manufactureDate,
      required String expiryDate,
      Value<String?> supplier,
      Value<String?> addDate,
      Value<String?> updateDate,
      Value<String?> shopId,
      Value<String?> addedBy,
      Value<String?> updatedBy,
      Value<int> rowid,
    });
typedef $$MedicineTableTableUpdateCompanionBuilder =
    MedicineTableCompanion Function({
      Value<String> id,
      Value<String> medName,
      Value<String> genericName,
      Value<String> brand,
      Value<String> category,
      Value<String> strength,
      Value<String> dosageForm,
      Value<String> schedule,
      Value<String?> imageUrl,
      Value<String> batchNo,
      Value<int> quantity,
      Value<bool> avLoose,
      Value<int?> looseQuantity,
      Value<int?> totalLooseInStrip,
      Value<int> minStockLevel,
      Value<int> maxStockLevel,
      Value<String> stockStatus,
      Value<double> purchasePrice,
      Value<double> sellingPrice,
      Value<double> mrp,
      Value<String> manufactureDate,
      Value<String> expiryDate,
      Value<String?> supplier,
      Value<String?> addDate,
      Value<String?> updateDate,
      Value<String?> shopId,
      Value<String?> addedBy,
      Value<String?> updatedBy,
      Value<int> rowid,
    });

class $$MedicineTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineTableTable> {
  $$MedicineTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medName => $composableBuilder(
    column: $table.medName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get avLoose => $composableBuilder(
    column: $table.avLoose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get looseQuantity => $composableBuilder(
    column: $table.looseQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLooseInStrip => $composableBuilder(
    column: $table.totalLooseInStrip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minStockLevel => $composableBuilder(
    column: $table.minStockLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxStockLevel => $composableBuilder(
    column: $table.maxStockLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stockStatus => $composableBuilder(
    column: $table.stockStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufactureDate => $composableBuilder(
    column: $table.manufactureDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addDate => $composableBuilder(
    column: $table.addDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updateDate => $composableBuilder(
    column: $table.updateDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedBy => $composableBuilder(
    column: $table.addedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicineTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineTableTable> {
  $$MedicineTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medName => $composableBuilder(
    column: $table.medName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get avLoose => $composableBuilder(
    column: $table.avLoose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get looseQuantity => $composableBuilder(
    column: $table.looseQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLooseInStrip => $composableBuilder(
    column: $table.totalLooseInStrip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minStockLevel => $composableBuilder(
    column: $table.minStockLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxStockLevel => $composableBuilder(
    column: $table.maxStockLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stockStatus => $composableBuilder(
    column: $table.stockStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufactureDate => $composableBuilder(
    column: $table.manufactureDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addDate => $composableBuilder(
    column: $table.addDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updateDate => $composableBuilder(
    column: $table.updateDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedBy => $composableBuilder(
    column: $table.addedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicineTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineTableTable> {
  $$MedicineTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medName =>
      $composableBuilder(column: $table.medName, builder: (column) => column);

  GeneratedColumn<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get batchNo =>
      $composableBuilder(column: $table.batchNo, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get avLoose =>
      $composableBuilder(column: $table.avLoose, builder: (column) => column);

  GeneratedColumn<int> get looseQuantity => $composableBuilder(
    column: $table.looseQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalLooseInStrip => $composableBuilder(
    column: $table.totalLooseInStrip,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minStockLevel => $composableBuilder(
    column: $table.minStockLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxStockLevel => $composableBuilder(
    column: $table.maxStockLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stockStatus => $composableBuilder(
    column: $table.stockStatus,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mrp =>
      $composableBuilder(column: $table.mrp, builder: (column) => column);

  GeneratedColumn<String> get manufactureDate => $composableBuilder(
    column: $table.manufactureDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<String> get addDate =>
      $composableBuilder(column: $table.addDate, builder: (column) => column);

  GeneratedColumn<String> get updateDate => $composableBuilder(
    column: $table.updateDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get addedBy =>
      $composableBuilder(column: $table.addedBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);
}

class $$MedicineTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicineTableTable,
          MedicineTableData,
          $$MedicineTableTableFilterComposer,
          $$MedicineTableTableOrderingComposer,
          $$MedicineTableTableAnnotationComposer,
          $$MedicineTableTableCreateCompanionBuilder,
          $$MedicineTableTableUpdateCompanionBuilder,
          (
            MedicineTableData,
            BaseReferences<
              _$AppDatabase,
              $MedicineTableTable,
              MedicineTableData
            >,
          ),
          MedicineTableData,
          PrefetchHooks Function()
        > {
  $$MedicineTableTableTableManager(_$AppDatabase db, $MedicineTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medName = const Value.absent(),
                Value<String> genericName = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> strength = const Value.absent(),
                Value<String> dosageForm = const Value.absent(),
                Value<String> schedule = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> batchNo = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> avLoose = const Value.absent(),
                Value<int?> looseQuantity = const Value.absent(),
                Value<int?> totalLooseInStrip = const Value.absent(),
                Value<int> minStockLevel = const Value.absent(),
                Value<int> maxStockLevel = const Value.absent(),
                Value<String> stockStatus = const Value.absent(),
                Value<double> purchasePrice = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> mrp = const Value.absent(),
                Value<String> manufactureDate = const Value.absent(),
                Value<String> expiryDate = const Value.absent(),
                Value<String?> supplier = const Value.absent(),
                Value<String?> addDate = const Value.absent(),
                Value<String?> updateDate = const Value.absent(),
                Value<String?> shopId = const Value.absent(),
                Value<String?> addedBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicineTableCompanion(
                id: id,
                medName: medName,
                genericName: genericName,
                brand: brand,
                category: category,
                strength: strength,
                dosageForm: dosageForm,
                schedule: schedule,
                imageUrl: imageUrl,
                batchNo: batchNo,
                quantity: quantity,
                avLoose: avLoose,
                looseQuantity: looseQuantity,
                totalLooseInStrip: totalLooseInStrip,
                minStockLevel: minStockLevel,
                maxStockLevel: maxStockLevel,
                stockStatus: stockStatus,
                purchasePrice: purchasePrice,
                sellingPrice: sellingPrice,
                mrp: mrp,
                manufactureDate: manufactureDate,
                expiryDate: expiryDate,
                supplier: supplier,
                addDate: addDate,
                updateDate: updateDate,
                shopId: shopId,
                addedBy: addedBy,
                updatedBy: updatedBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medName,
                required String genericName,
                required String brand,
                required String category,
                required String strength,
                required String dosageForm,
                Value<String> schedule = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                required String batchNo,
                Value<int> quantity = const Value.absent(),
                Value<bool> avLoose = const Value.absent(),
                Value<int?> looseQuantity = const Value.absent(),
                Value<int?> totalLooseInStrip = const Value.absent(),
                Value<int> minStockLevel = const Value.absent(),
                Value<int> maxStockLevel = const Value.absent(),
                Value<String> stockStatus = const Value.absent(),
                Value<double> purchasePrice = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> mrp = const Value.absent(),
                required String manufactureDate,
                required String expiryDate,
                Value<String?> supplier = const Value.absent(),
                Value<String?> addDate = const Value.absent(),
                Value<String?> updateDate = const Value.absent(),
                Value<String?> shopId = const Value.absent(),
                Value<String?> addedBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicineTableCompanion.insert(
                id: id,
                medName: medName,
                genericName: genericName,
                brand: brand,
                category: category,
                strength: strength,
                dosageForm: dosageForm,
                schedule: schedule,
                imageUrl: imageUrl,
                batchNo: batchNo,
                quantity: quantity,
                avLoose: avLoose,
                looseQuantity: looseQuantity,
                totalLooseInStrip: totalLooseInStrip,
                minStockLevel: minStockLevel,
                maxStockLevel: maxStockLevel,
                stockStatus: stockStatus,
                purchasePrice: purchasePrice,
                sellingPrice: sellingPrice,
                mrp: mrp,
                manufactureDate: manufactureDate,
                expiryDate: expiryDate,
                supplier: supplier,
                addDate: addDate,
                updateDate: updateDate,
                shopId: shopId,
                addedBy: addedBy,
                updatedBy: updatedBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicineTableTable, MedicineTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MedicineTableTable,
                    MedicineTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicineTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicineTableTable,
      MedicineTableData,
      $$MedicineTableTableFilterComposer,
      $$MedicineTableTableOrderingComposer,
      $$MedicineTableTableAnnotationComposer,
      $$MedicineTableTableCreateCompanionBuilder,
      $$MedicineTableTableUpdateCompanionBuilder,
      (
        MedicineTableData,
        BaseReferences<_$AppDatabase, $MedicineTableTable, MedicineTableData>,
      ),
      MedicineTableData,
      PrefetchHooks Function()
    >;
typedef $$BillTableTableCreateCompanionBuilder =
    BillTableCompanion Function({
      required String invNo,
      required int customerType,
      required String customerName,
      required String date,
      required double value,
      required String paymentType,
      Value<int> rowid,
    });
typedef $$BillTableTableUpdateCompanionBuilder =
    BillTableCompanion Function({
      Value<String> invNo,
      Value<int> customerType,
      Value<String> customerName,
      Value<String> date,
      Value<double> value,
      Value<String> paymentType,
      Value<int> rowid,
    });

final class $$BillTableTableReferences
    extends BaseReferences<_$AppDatabase, $BillTableTable, BillTableData> {
  $$BillTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $BillMedicineTableTable,
    List<BillMedicineTableData>
  >
  _billMedicineTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.billMedicineTable,
        aliasName: 'bill_table__inv_no__bill_medicine_table__inv_no',
      );

  $$BillMedicineTableTableProcessedTableManager get billMedicineTableRefs {
    final manager = $$BillMedicineTableTableTableManager(
      $_db,
      $_db.billMedicineTable,
    ).filter((f) => f.invNo.invNo.sqlEquals($_itemColumn<String>('inv_no')!));

    final cache = $_typedResult.readTableOrNull(
      _billMedicineTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillTableTableFilterComposer
    extends Composer<_$AppDatabase, $BillTableTable> {
  $$BillTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get invNo => $composableBuilder(
    column: $table.invNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> billMedicineTableRefs(
    Expression<bool> Function($$BillMedicineTableTableFilterComposer f) f,
  ) {
    final $$BillMedicineTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invNo,
      referencedTable: $db.billMedicineTable,
      getReferencedColumn: (t) => t.invNo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillMedicineTableTableFilterComposer(
            $db: $db,
            $table: $db.billMedicineTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BillTableTable> {
  $$BillTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get invNo => $composableBuilder(
    column: $table.invNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillTableTable> {
  $$BillTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get invNo =>
      $composableBuilder(column: $table.invNo, builder: (column) => column);

  GeneratedColumn<int> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  Expression<T> billMedicineTableRefs<T extends Object>(
    Expression<T> Function($$BillMedicineTableTableAnnotationComposer a) f,
  ) {
    final $$BillMedicineTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.invNo,
          referencedTable: $db.billMedicineTable,
          getReferencedColumn: (t) => t.invNo,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BillMedicineTableTableAnnotationComposer(
                $db: $db,
                $table: $db.billMedicineTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BillTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillTableTable,
          BillTableData,
          $$BillTableTableFilterComposer,
          $$BillTableTableOrderingComposer,
          $$BillTableTableAnnotationComposer,
          $$BillTableTableCreateCompanionBuilder,
          $$BillTableTableUpdateCompanionBuilder,
          (BillTableData, $$BillTableTableReferences),
          BillTableData,
          PrefetchHooks Function({bool billMedicineTableRefs})
        > {
  $$BillTableTableTableManager(_$AppDatabase db, $BillTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> invNo = const Value.absent(),
                Value<int> customerType = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillTableCompanion(
                invNo: invNo,
                customerType: customerType,
                customerName: customerName,
                date: date,
                value: value,
                paymentType: paymentType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String invNo,
                required int customerType,
                required String customerName,
                required String date,
                required double value,
                required String paymentType,
                Value<int> rowid = const Value.absent(),
              }) => BillTableCompanion.insert(
                invNo: invNo,
                customerType: customerType,
                customerName: customerName,
                date: date,
                value: value,
                paymentType: paymentType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillTableTable, BillTableData>(table),
                  $$BillTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billMedicineTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (billMedicineTableRefs) db.billMedicineTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billMedicineTableRefs)
                    await $_getPrefetchedData<
                      BillTableData,
                      $BillTableTable,
                      BillMedicineTableData
                    >(
                      currentTable: table,
                      referencedTable: $$BillTableTableReferences
                          ._billMedicineTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BillTableTableReferences(
                            db,
                            table,
                            p0,
                          ).billMedicineTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.invNo == item.invNo),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BillTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillTableTable,
      BillTableData,
      $$BillTableTableFilterComposer,
      $$BillTableTableOrderingComposer,
      $$BillTableTableAnnotationComposer,
      $$BillTableTableCreateCompanionBuilder,
      $$BillTableTableUpdateCompanionBuilder,
      (BillTableData, $$BillTableTableReferences),
      BillTableData,
      PrefetchHooks Function({bool billMedicineTableRefs})
    >;
typedef $$BillMedicineTableTableCreateCompanionBuilder =
    BillMedicineTableCompanion Function({
      Value<int> id,
      required String invNo,
      required String medicineId,
      required String medicineName,
      required int strip,
      Value<int?> loose,
      required int looseQty,
      required bool isLooseAvailable,
      required double price,
      required double tagPrice,
      required double totalPrice,
    });
typedef $$BillMedicineTableTableUpdateCompanionBuilder =
    BillMedicineTableCompanion Function({
      Value<int> id,
      Value<String> invNo,
      Value<String> medicineId,
      Value<String> medicineName,
      Value<int> strip,
      Value<int?> loose,
      Value<int> looseQty,
      Value<bool> isLooseAvailable,
      Value<double> price,
      Value<double> tagPrice,
      Value<double> totalPrice,
    });

final class $$BillMedicineTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BillMedicineTableTable,
          BillMedicineTableData
        > {
  $$BillMedicineTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BillTableTable _invNoTable(_$AppDatabase db) => db.billTable
      .createAlias('bill_medicine_table__inv_no__bill_table__inv_no');

  $$BillTableTableProcessedTableManager get invNo {
    final $_column = $_itemColumn<String>('inv_no')!;

    final manager = $$BillTableTableTableManager(
      $_db,
      $_db.billTable,
    ).filter((f) => f.invNo.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invNoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BillMedicineTableTableFilterComposer
    extends Composer<_$AppDatabase, $BillMedicineTableTable> {
  $$BillMedicineTableTableFilterComposer({
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

  ColumnFilters<String> get medicineId => $composableBuilder(
    column: $table.medicineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strip => $composableBuilder(
    column: $table.strip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loose => $composableBuilder(
    column: $table.loose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get looseQty => $composableBuilder(
    column: $table.looseQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLooseAvailable => $composableBuilder(
    column: $table.isLooseAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tagPrice => $composableBuilder(
    column: $table.tagPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$BillTableTableFilterComposer get invNo {
    final $$BillTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invNo,
      referencedTable: $db.billTable,
      getReferencedColumn: (t) => t.invNo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillTableTableFilterComposer(
            $db: $db,
            $table: $db.billTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillMedicineTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BillMedicineTableTable> {
  $$BillMedicineTableTableOrderingComposer({
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

  ColumnOrderings<String> get medicineId => $composableBuilder(
    column: $table.medicineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strip => $composableBuilder(
    column: $table.strip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loose => $composableBuilder(
    column: $table.loose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get looseQty => $composableBuilder(
    column: $table.looseQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLooseAvailable => $composableBuilder(
    column: $table.isLooseAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tagPrice => $composableBuilder(
    column: $table.tagPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$BillTableTableOrderingComposer get invNo {
    final $$BillTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invNo,
      referencedTable: $db.billTable,
      getReferencedColumn: (t) => t.invNo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillTableTableOrderingComposer(
            $db: $db,
            $table: $db.billTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillMedicineTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillMedicineTableTable> {
  $$BillMedicineTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicineId => $composableBuilder(
    column: $table.medicineId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get strip =>
      $composableBuilder(column: $table.strip, builder: (column) => column);

  GeneratedColumn<int> get loose =>
      $composableBuilder(column: $table.loose, builder: (column) => column);

  GeneratedColumn<int> get looseQty =>
      $composableBuilder(column: $table.looseQty, builder: (column) => column);

  GeneratedColumn<bool> get isLooseAvailable => $composableBuilder(
    column: $table.isLooseAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get tagPrice =>
      $composableBuilder(column: $table.tagPrice, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  $$BillTableTableAnnotationComposer get invNo {
    final $$BillTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invNo,
      referencedTable: $db.billTable,
      getReferencedColumn: (t) => t.invNo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillTableTableAnnotationComposer(
            $db: $db,
            $table: $db.billTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillMedicineTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillMedicineTableTable,
          BillMedicineTableData,
          $$BillMedicineTableTableFilterComposer,
          $$BillMedicineTableTableOrderingComposer,
          $$BillMedicineTableTableAnnotationComposer,
          $$BillMedicineTableTableCreateCompanionBuilder,
          $$BillMedicineTableTableUpdateCompanionBuilder,
          (BillMedicineTableData, $$BillMedicineTableTableReferences),
          BillMedicineTableData,
          PrefetchHooks Function({bool invNo})
        > {
  $$BillMedicineTableTableTableManager(
    _$AppDatabase db,
    $BillMedicineTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillMedicineTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillMedicineTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillMedicineTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invNo = const Value.absent(),
                Value<String> medicineId = const Value.absent(),
                Value<String> medicineName = const Value.absent(),
                Value<int> strip = const Value.absent(),
                Value<int?> loose = const Value.absent(),
                Value<int> looseQty = const Value.absent(),
                Value<bool> isLooseAvailable = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> tagPrice = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
              }) => BillMedicineTableCompanion(
                id: id,
                invNo: invNo,
                medicineId: medicineId,
                medicineName: medicineName,
                strip: strip,
                loose: loose,
                looseQty: looseQty,
                isLooseAvailable: isLooseAvailable,
                price: price,
                tagPrice: tagPrice,
                totalPrice: totalPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invNo,
                required String medicineId,
                required String medicineName,
                required int strip,
                Value<int?> loose = const Value.absent(),
                required int looseQty,
                required bool isLooseAvailable,
                required double price,
                required double tagPrice,
                required double totalPrice,
              }) => BillMedicineTableCompanion.insert(
                id: id,
                invNo: invNo,
                medicineId: medicineId,
                medicineName: medicineName,
                strip: strip,
                loose: loose,
                looseQty: looseQty,
                isLooseAvailable: isLooseAvailable,
                price: price,
                tagPrice: tagPrice,
                totalPrice: totalPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillMedicineTableTable, BillMedicineTableData>(
                    table,
                  ),
                  $$BillMedicineTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invNo = false}) {
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
                    if (invNo) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invNo,
                                referencedTable:
                                    $$BillMedicineTableTableReferences
                                        ._invNoTable(db),
                                referencedColumn:
                                    $$BillMedicineTableTableReferences
                                        ._invNoTable(db)
                                        .invNo,
                              )
                              as T;
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

typedef $$BillMedicineTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillMedicineTableTable,
      BillMedicineTableData,
      $$BillMedicineTableTableFilterComposer,
      $$BillMedicineTableTableOrderingComposer,
      $$BillMedicineTableTableAnnotationComposer,
      $$BillMedicineTableTableCreateCompanionBuilder,
      $$BillMedicineTableTableUpdateCompanionBuilder,
      (BillMedicineTableData, $$BillMedicineTableTableReferences),
      BillMedicineTableData,
      PrefetchHooks Function({bool invNo})
    >;
typedef $$OwnerAuthTableTableCreateCompanionBuilder =
    OwnerAuthTableCompanion Function({
      required String id,
      required String name,
      required String email,
      required String role,
      Value<bool> isShopHave,
      Value<String?> createdAt,
      Value<String?> selectedShopId,
      Value<int> rowid,
    });
typedef $$OwnerAuthTableTableUpdateCompanionBuilder =
    OwnerAuthTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> role,
      Value<bool> isShopHave,
      Value<String?> createdAt,
      Value<String?> selectedShopId,
      Value<int> rowid,
    });

class $$OwnerAuthTableTableFilterComposer
    extends Composer<_$AppDatabase, $OwnerAuthTableTable> {
  $$OwnerAuthTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isShopHave => $composableBuilder(
    column: $table.isShopHave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedShopId => $composableBuilder(
    column: $table.selectedShopId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnerAuthTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnerAuthTableTable> {
  $$OwnerAuthTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isShopHave => $composableBuilder(
    column: $table.isShopHave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedShopId => $composableBuilder(
    column: $table.selectedShopId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnerAuthTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnerAuthTableTable> {
  $$OwnerAuthTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isShopHave => $composableBuilder(
    column: $table.isShopHave,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get selectedShopId => $composableBuilder(
    column: $table.selectedShopId,
    builder: (column) => column,
  );
}

class $$OwnerAuthTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnerAuthTableTable,
          OwnerAuthTableData,
          $$OwnerAuthTableTableFilterComposer,
          $$OwnerAuthTableTableOrderingComposer,
          $$OwnerAuthTableTableAnnotationComposer,
          $$OwnerAuthTableTableCreateCompanionBuilder,
          $$OwnerAuthTableTableUpdateCompanionBuilder,
          (
            OwnerAuthTableData,
            BaseReferences<
              _$AppDatabase,
              $OwnerAuthTableTable,
              OwnerAuthTableData
            >,
          ),
          OwnerAuthTableData,
          PrefetchHooks Function()
        > {
  $$OwnerAuthTableTableTableManager(
    _$AppDatabase db,
    $OwnerAuthTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnerAuthTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnerAuthTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnerAuthTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isShopHave = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> selectedShopId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnerAuthTableCompanion(
                id: id,
                name: name,
                email: email,
                role: role,
                isShopHave: isShopHave,
                createdAt: createdAt,
                selectedShopId: selectedShopId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                required String role,
                Value<bool> isShopHave = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> selectedShopId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnerAuthTableCompanion.insert(
                id: id,
                name: name,
                email: email,
                role: role,
                isShopHave: isShopHave,
                createdAt: createdAt,
                selectedShopId: selectedShopId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OwnerAuthTableTable, OwnerAuthTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OwnerAuthTableTable,
                    OwnerAuthTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnerAuthTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnerAuthTableTable,
      OwnerAuthTableData,
      $$OwnerAuthTableTableFilterComposer,
      $$OwnerAuthTableTableOrderingComposer,
      $$OwnerAuthTableTableAnnotationComposer,
      $$OwnerAuthTableTableCreateCompanionBuilder,
      $$OwnerAuthTableTableUpdateCompanionBuilder,
      (
        OwnerAuthTableData,
        BaseReferences<_$AppDatabase, $OwnerAuthTableTable, OwnerAuthTableData>,
      ),
      OwnerAuthTableData,
      PrefetchHooks Function()
    >;
typedef $$ShopTableTableCreateCompanionBuilder =
    ShopTableCompanion Function({
      required String id,
      required String shopName,
      required String shopEmail,
      required String shopCode,
      required String phone,
      required String address,
      required String city,
      required String state,
      required String pincode,
      Value<String?> licenseNumber,
      Value<String?> gstNumber,
      Value<String> verifyStatus,
      Value<bool> isOwnerEmployee,
      Value<String?> logoUrl,
      Value<bool?> isOpen,
      Value<String?> ownerId,
      Value<int> rowid,
    });
typedef $$ShopTableTableUpdateCompanionBuilder =
    ShopTableCompanion Function({
      Value<String> id,
      Value<String> shopName,
      Value<String> shopEmail,
      Value<String> shopCode,
      Value<String> phone,
      Value<String> address,
      Value<String> city,
      Value<String> state,
      Value<String> pincode,
      Value<String?> licenseNumber,
      Value<String?> gstNumber,
      Value<String> verifyStatus,
      Value<bool> isOwnerEmployee,
      Value<String?> logoUrl,
      Value<bool?> isOpen,
      Value<String?> ownerId,
      Value<int> rowid,
    });

class $$ShopTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopEmail => $composableBuilder(
    column: $table.shopEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopCode => $composableBuilder(
    column: $table.shopCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verifyStatus => $composableBuilder(
    column: $table.verifyStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOwnerEmployee => $composableBuilder(
    column: $table.isOwnerEmployee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShopTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopEmail => $composableBuilder(
    column: $table.shopEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopCode => $composableBuilder(
    column: $table.shopCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verifyStatus => $composableBuilder(
    column: $table.verifyStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOwnerEmployee => $composableBuilder(
    column: $table.isOwnerEmployee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopName =>
      $composableBuilder(column: $table.shopName, builder: (column) => column);

  GeneratedColumn<String> get shopEmail =>
      $composableBuilder(column: $table.shopEmail, builder: (column) => column);

  GeneratedColumn<String> get shopCode =>
      $composableBuilder(column: $table.shopCode, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<String> get verifyStatus => $composableBuilder(
    column: $table.verifyStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOwnerEmployee => $composableBuilder(
    column: $table.isOwnerEmployee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<bool> get isOpen =>
      $composableBuilder(column: $table.isOpen, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);
}

class $$ShopTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopTableTable,
          ShopTableData,
          $$ShopTableTableFilterComposer,
          $$ShopTableTableOrderingComposer,
          $$ShopTableTableAnnotationComposer,
          $$ShopTableTableCreateCompanionBuilder,
          $$ShopTableTableUpdateCompanionBuilder,
          (
            ShopTableData,
            BaseReferences<_$AppDatabase, $ShopTableTable, ShopTableData>,
          ),
          ShopTableData,
          PrefetchHooks Function()
        > {
  $$ShopTableTableTableManager(_$AppDatabase db, $ShopTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shopName = const Value.absent(),
                Value<String> shopEmail = const Value.absent(),
                Value<String> shopCode = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> pincode = const Value.absent(),
                Value<String?> licenseNumber = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String> verifyStatus = const Value.absent(),
                Value<bool> isOwnerEmployee = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<bool?> isOpen = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopTableCompanion(
                id: id,
                shopName: shopName,
                shopEmail: shopEmail,
                shopCode: shopCode,
                phone: phone,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                licenseNumber: licenseNumber,
                gstNumber: gstNumber,
                verifyStatus: verifyStatus,
                isOwnerEmployee: isOwnerEmployee,
                logoUrl: logoUrl,
                isOpen: isOpen,
                ownerId: ownerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shopName,
                required String shopEmail,
                required String shopCode,
                required String phone,
                required String address,
                required String city,
                required String state,
                required String pincode,
                Value<String?> licenseNumber = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String> verifyStatus = const Value.absent(),
                Value<bool> isOwnerEmployee = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<bool?> isOpen = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopTableCompanion.insert(
                id: id,
                shopName: shopName,
                shopEmail: shopEmail,
                shopCode: shopCode,
                phone: phone,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                licenseNumber: licenseNumber,
                gstNumber: gstNumber,
                verifyStatus: verifyStatus,
                isOwnerEmployee: isOwnerEmployee,
                logoUrl: logoUrl,
                isOpen: isOpen,
                ownerId: ownerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShopTableTable, ShopTableData>(table),
                  BaseReferences<_$AppDatabase, $ShopTableTable, ShopTableData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShopTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopTableTable,
      ShopTableData,
      $$ShopTableTableFilterComposer,
      $$ShopTableTableOrderingComposer,
      $$ShopTableTableAnnotationComposer,
      $$ShopTableTableCreateCompanionBuilder,
      $$ShopTableTableUpdateCompanionBuilder,
      (
        ShopTableData,
        BaseReferences<_$AppDatabase, $ShopTableTable, ShopTableData>,
      ),
      ShopTableData,
      PrefetchHooks Function()
    >;
typedef $$EmployeeTableTableCreateCompanionBuilder =
    EmployeeTableCompanion Function({
      required String id,
      required String name,
      required String email,
      Value<String> role,
      Value<bool> isFromOwner,
      Value<String?> shopId,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$EmployeeTableTableUpdateCompanionBuilder =
    EmployeeTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> role,
      Value<bool> isFromOwner,
      Value<String?> shopId,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$EmployeeTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFromOwner => $composableBuilder(
    column: $table.isFromOwner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFromOwner => $composableBuilder(
    column: $table.isFromOwner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isFromOwner => $composableBuilder(
    column: $table.isFromOwner,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EmployeeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeeTableTable,
          EmployeeTableData,
          $$EmployeeTableTableFilterComposer,
          $$EmployeeTableTableOrderingComposer,
          $$EmployeeTableTableAnnotationComposer,
          $$EmployeeTableTableCreateCompanionBuilder,
          $$EmployeeTableTableUpdateCompanionBuilder,
          (
            EmployeeTableData,
            BaseReferences<
              _$AppDatabase,
              $EmployeeTableTable,
              EmployeeTableData
            >,
          ),
          EmployeeTableData,
          PrefetchHooks Function()
        > {
  $$EmployeeTableTableTableManager(_$AppDatabase db, $EmployeeTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isFromOwner = const Value.absent(),
                Value<String?> shopId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeTableCompanion(
                id: id,
                name: name,
                email: email,
                role: role,
                isFromOwner: isFromOwner,
                shopId: shopId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                Value<String> role = const Value.absent(),
                Value<bool> isFromOwner = const Value.absent(),
                Value<String?> shopId = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EmployeeTableCompanion.insert(
                id: id,
                name: name,
                email: email,
                role: role,
                isFromOwner: isFromOwner,
                shopId: shopId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmployeeTableTable, EmployeeTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EmployeeTableTable,
                    EmployeeTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeeTableTable,
      EmployeeTableData,
      $$EmployeeTableTableFilterComposer,
      $$EmployeeTableTableOrderingComposer,
      $$EmployeeTableTableAnnotationComposer,
      $$EmployeeTableTableCreateCompanionBuilder,
      $$EmployeeTableTableUpdateCompanionBuilder,
      (
        EmployeeTableData,
        BaseReferences<_$AppDatabase, $EmployeeTableTable, EmployeeTableData>,
      ),
      EmployeeTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicineTableTableTableManager get medicineTable =>
      $$MedicineTableTableTableManager(_db, _db.medicineTable);
  $$BillTableTableTableManager get billTable =>
      $$BillTableTableTableManager(_db, _db.billTable);
  $$BillMedicineTableTableTableManager get billMedicineTable =>
      $$BillMedicineTableTableTableManager(_db, _db.billMedicineTable);
  $$OwnerAuthTableTableTableManager get ownerAuthTable =>
      $$OwnerAuthTableTableTableManager(_db, _db.ownerAuthTable);
  $$ShopTableTableTableManager get shopTable =>
      $$ShopTableTableTableManager(_db, _db.shopTable);
  $$EmployeeTableTableTableManager get employeeTable =>
      $$EmployeeTableTableTableManager(_db, _db.employeeTable);
}
