import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';

class MedicineInputModel {
  final String medName,
      genericName,
      brand,
      category,
      strength,
      imageUrl,
      batchNo,
      supplier;
  final DosageForm dosageForm;
  final Schedules schedule;
  final StockStatus stockStatus;
  final int quantity,
      looseQuantity,
      totalLooseInStrip,
      minStockLevel,
      maxStockLevel;
  final double purchasePrice, sellingPrice, mrp;
  final String manufactureDate, expiryDate;
  final bool avLoose;

  MedicineInputModel({
    required this.medName,
    required this.genericName,
    required this.brand,
    required this.category,
    required this.strength,
    required this.imageUrl,
    required this.batchNo,
    required this.supplier,
    required this.dosageForm,
    required this.schedule,
    required this.quantity,
    required this.looseQuantity,
    required this.totalLooseInStrip,
    required this.minStockLevel,
    required this.maxStockLevel,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.mrp,
    required this.manufactureDate,
    required this.expiryDate,
    required this.avLoose,
    required this.stockStatus,
  });
  Map<String, dynamic> toJson() {
    return {
      'medName': medName,
      'genericName': genericName,
      'brand': brand,
      'category': category,
      'strength': strength,
      'imageUrl': imageUrl,
      'batchNo': batchNo,
      'supplier': supplier,
      'dosageForm': dosageForm.label,
      'schedule': schedule.label ?? schedule.name,
      'quantity': quantity,
      'looseQuantity': looseQuantity,
      'totalLooseInStrip': totalLooseInStrip,
      'minStockLevel': minStockLevel,
      'maxStockLevel': maxStockLevel,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'mrp': mrp,
      'manufactureDate': manufactureDate,
      'expiryDate': expiryDate,
      'avLoose': avLoose,
      'stockStatus': stockStatus.name,
    };
  }

  factory MedicineInputModel.fromJson(Map<String, dynamic> json) {
    return MedicineInputModel(
      medName: json['medName']?.toString() ?? '',
      genericName: json['genericName']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      strength: json['strength']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      batchNo: json['batchNo']?.toString() ?? '',
      supplier: json['supplier']?.toString() ?? '',
      dosageForm: DosageForm.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
                (json['dosageForm'] as String?)?.toLowerCase() ||
            (e.label?.toLowerCase() ==
                (json['dosageForm'] as String?)?.toLowerCase()),
        orElse: () => DosageForm.tablet,
      ),
      schedule: Schedules.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
                (json['schedule'] as String?)?.toLowerCase() ||
            (e.label?.toLowerCase() ==
                (json['schedule'] as String?)?.toLowerCase()),
        orElse: () => Schedules.none,
      ),
      stockStatus: StockStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
                (json['stockStatus'] as String?)?.toLowerCase() ||
            (e.label?.toLowerCase() ==
                (json['stockStatus'] as String?)?.toLowerCase()),
        orElse: () => StockStatus.inStock,
      ),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      looseQuantity: (json['looseQuantity'] as num?)?.toInt() ?? 0,
      totalLooseInStrip: (json['totalLooseInStrip'] as num?)?.toInt() ?? 0,
      minStockLevel: (json['minStockLevel'] as num?)?.toInt() ?? 0,
      maxStockLevel: (json['maxStockLevel'] as num?)?.toInt() ?? 0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      manufactureDate: json['manufactureDate']?.toString() ?? '',
      expiryDate: json['expiryDate']?.toString() ?? '',
      avLoose: json['avLoose'] ?? false,
    );
  }
}

enum Schedules {
  none('NONE'),
  g('G'),
  h('H'),
  h1('H1'),
  x('X'),
  other('OTHER');

  const Schedules(this.label);

  final String? label;
}
