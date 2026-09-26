import 'package:drift/drift.dart';
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';
import 'package:pharmace/LocalDB/database.dart';

extension BillMedicineMapper on MedicineBillModel {
  BillMedicineTableCompanion toCompanion({required String invNo}) {
    return BillMedicineTableCompanion.insert(
      invNo: invNo,
      medicineId: id,
      medicineName: medicineName,
      strip: strip,
      loose: Value(loose),
      looseQty: looseQty,
      isLooseAvailable: isLooseAv,
      price: price,
      tagPrice: tagPrice,
      totalPrice: totalPrice,
    );
  }
}

extension BillMedicineDataMapper on BillMedicineTableData {
  MedicineBillModel toModel() {
    return MedicineBillModel(
      id: medicineId,
      medicineName: medicineName,
      strip: strip,
      loose: loose,
      looseQty: looseQty,
      price: price,
      isLooseAv: isLooseAvailable,
      tagPrice: tagPrice,
      totalPrice: totalPrice,
    );
  }
}
