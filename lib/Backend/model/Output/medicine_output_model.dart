import 'package:pharmace/Backend/model/Input/medicine_input_model.dart';
import 'package:pharmace/Backend/model/Output/employee_return_model.dart';
import 'package:pharmace/Backend/model/Output/shop_return_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';

class MedicineOutputModel {
  final String? id;
  final String medName;
  final String genericName;
  final String brand;
  final String category;
  final String strength;
  final DosageForm dosageForm;
  final Schedules schedule;
  final String? imageUrl;
  final String batchNo;
  final int quantity;
  final bool avLoose;
  final int looseQuantity;
  final int totalLooseInStrip;
  final int minStockLevel;
  final int maxStockLevel;
  final double purchasePrice;
  final double sellingPrice;
  final double mrp;
  final String manufactureDate;
  final String expiryDate;
  final String? addDate;
  final String? updateDate;
  final ShopReturnModel? shop;
  final EmployeeReturnModel? addedBy;
  final EmployeeReturnModel? updatedBy;
  final String? supplier;
  final bool? expiryAfterManufacture;
  final bool? sellingPriceValid;
  final bool? stockLevelValid;

  const MedicineOutputModel({
    this.id,
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
    required this.looseQuantity,
    required this.totalLooseInStrip,
    required this.minStockLevel,
    required this.maxStockLevel,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.mrp,
    required this.manufactureDate,
    required this.expiryDate,
    this.addDate,
    this.updateDate,
    this.shop,
    this.addedBy,
    this.updatedBy,
    this.supplier,
    this.expiryAfterManufacture,
    this.sellingPriceValid,
    this.stockLevelValid,
  });

  MedicineOutputModel copyWith({
    String? id,
    String? medName,
    String? genericName,
    String? brand,
    String? category,
    String? strength,
    DosageForm? dosageForm,
    Schedules? schedule,
    String? imageUrl,
    String? batchNo,
    int? quantity,
    bool? avLoose,
    int? looseQuantity,
    int? totalLooseInStrip,
    int? minStockLevel,
    int? maxStockLevel,
    double? purchasePrice,
    double? sellingPrice,
    double? mrp,
    String? manufactureDate,
    String? expiryDate,
    String? addDate,
    String? updateDate,
    ShopReturnModel? shop,
    EmployeeReturnModel? addedBy,
    EmployeeReturnModel? updatedBy,
    String? supplier,
    bool? expiryAfterManufacture,
    bool? sellingPriceValid,
    bool? stockLevelValid,
  }) {
    return MedicineOutputModel(
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
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate ?? this.expiryDate,
      addDate: addDate ?? this.addDate,
      updateDate: updateDate ?? this.updateDate,
      shop: shop ?? this.shop,
      addedBy: addedBy ?? this.addedBy,
      updatedBy: updatedBy ?? this.updatedBy,
      supplier: supplier ?? this.supplier,
      expiryAfterManufacture:
          expiryAfterManufacture ?? this.expiryAfterManufacture,
      sellingPriceValid: sellingPriceValid ?? this.sellingPriceValid,
      stockLevelValid: stockLevelValid ?? this.stockLevelValid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'medName': medName,
      'genericName': genericName,
      'brand': brand,
      'category': category,
      'strength': strength,
      'dosageForm': dosageForm.label ?? dosageForm.name,
      'schedule': schedule.label ?? schedule.name,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'batchNo': batchNo,
      'quantity': quantity,
      'avLoose': avLoose,
      'looseQuantity': looseQuantity,
      'totalLooseInStrip': totalLooseInStrip,
      'minStockLevel': minStockLevel,
      'maxStockLevel': maxStockLevel,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'mrp': mrp,
      'manufactureDate': manufactureDate,
      'expiryDate': expiryDate,
      if (addDate != null) 'addDate': addDate,
      if (updateDate != null) 'updateDate': updateDate,
      if (shop != null) 'shop': shop?.toJson(),
      if (addedBy != null) 'addedBy': addedBy?.toJson(),
      if (updatedBy != null) 'updatedBy': updatedBy?.toJson(),
      if (supplier != null) 'supplier': supplier,
      if (expiryAfterManufacture != null)
        'expiryAfterManufacture': expiryAfterManufacture,
      if (sellingPriceValid != null) 'sellingPriceValid': sellingPriceValid,
      if (stockLevelValid != null) 'stockLevelValid': stockLevelValid,
    };
  }

  factory MedicineOutputModel.fromJson(Map<String, dynamic> json) {
    return MedicineOutputModel(
      id: json['id'] as String?,
      medName: json['medName'] as String? ?? '',
      genericName: json['genericName'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      strength: json['strength'] as String? ?? '',
      dosageForm: DosageForm.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
                (json['dosageForm'] as String?)?.toLowerCase() ||
            (e.label?.toLowerCase() ==
                (json['dosageForm'] as String?)?.toLowerCase()),
        orElse: () => DosageForm.other,
      ),
      schedule: Schedules.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
                (json['schedule'] as String?)?.toLowerCase() ||
            (e.label?.toLowerCase() ==
                (json['schedule'] as String?)?.toLowerCase()),
        orElse: () => Schedules.none,
      ),
      imageUrl: json['imageUrl'] as String?,
      batchNo: json['batchNo'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      avLoose: json['avLoose'] as bool? ?? false,
      looseQuantity: (json['looseQuantity'] as num?)?.toInt() ?? 0,
      totalLooseInStrip: (json['totalLooseInStrip'] as num?)?.toInt() ?? 0,
      minStockLevel: (json['minStockLevel'] as num?)?.toInt() ?? 0,
      maxStockLevel: (json['maxStockLevel'] as num?)?.toInt() ?? 0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      manufactureDate: json['manufactureDate'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      addDate: json['addDate'] as String?,
      updateDate: json['updateDate'] as String?,
      shop: json['shop'] != null && json['shop'] is Map<String, dynamic>
          ? ShopReturnModel.fromJson(json['shop'] as Map<String, dynamic>)
          : null,
      addedBy: _parseEmployee(json['addedBy'] ?? json['added_by']),
      updatedBy: _parseEmployee(json['updatedBy'] ?? json['updated_by']),
      supplier: json['supplier'] as String?,
      expiryAfterManufacture: json['expiryAfterManufacture'] as bool?,
      sellingPriceValid: json['sellingPriceValid'] as bool?,
      stockLevelValid: json['stockLevelValid'] as bool?,
    );
  }

  static EmployeeReturnModel? _parseEmployee(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      final map = value['data'] is Map<String, dynamic>
          ? value['data'] as Map<String, dynamic>
          : value;
      return EmployeeReturnModel.fromJson(map);
    }
    if (value is String && value.trim().isNotEmpty) {
      final trimmed = value.trim();
      return EmployeeReturnModel(
        id: trimmed,
        name: trimmed,
        email: '',
      );
    }
    return null;
  }

  static List<MedicineOutputModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) =>
            MedicineOutputModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  StockStatus get stockStatus {
    if (quantity <= 0) {
      return StockStatus.outOfStock;
    }
    try {
      if (expiryDate.isNotEmpty) {
        final exp = DateTime.tryParse(expiryDate);
        if (exp != null &&
            exp.isBefore(DateTime.now().add(const Duration(days: 90)))) {
          return StockStatus.expiring;
        }
      }
    } catch (_) {}
    if (quantity <= minStockLevel) {
      return StockStatus.lowStock;
    }
    return StockStatus.inStock;
  }

  // Compatibility getters for seamless migration from MedicineModel
  String get medicineNmae => medName;
  String get manufacturerName => brand;
  int get stockValue => quantity;
  double get price => sellingPrice;
  double get purchesePrice => purchasePrice;
  bool get isLooseAv => avLoose;
  String get expData => expiryDate;
  String? get imgUrl => imageUrl;
  int get minLevel => minStockLevel;
  Schedules get schedules => schedule;
  String get upDate => updateDate ?? '';
  String get manufactureContackNo => '';

  void operator [](String other) {}
}

typedef MedicineReturnModel = MedicineOutputModel;
typedef MedicineModel = MedicineOutputModel;