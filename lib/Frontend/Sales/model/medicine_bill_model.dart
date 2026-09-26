class MedicineBillModel {
  final String id;
  final String medicineName;
  final int strip;
  final int? loose;
  final int looseQty;
  final bool isLooseAv;
  final double price;
  final double tagPrice;
  final double totalPrice;

  MedicineBillModel({
    required this.id,
    required this.medicineName,
    required this.strip,
    this.loose,
    this.looseQty = 0,
    required this.price,
    required this.isLooseAv,
    required this.tagPrice,
    this.totalPrice = 0,
  });

  MedicineBillModel copyWith({int? strip, int? looseQty, double? totalPrice}) {
    return MedicineBillModel(
      id: id,
      medicineName: medicineName,
      strip: strip ?? this.strip,
      loose: loose,
      looseQty: looseQty ?? this.looseQty,
      price: price,
      isLooseAv: isLooseAv,
      tagPrice: tagPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
