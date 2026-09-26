import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/LocalDB/Maper/bill/bill_medicine_maper.dart';
import 'package:pharmace/LocalDB/database.dart';

extension BillMaper on InvModel {
  /// Converts the invoice header into BillTableCompanion
  BillTableCompanion toCompanion() {
    return BillTableCompanion.insert(
      invNo: invNo,
      customerType: customerType,
      customerName: customerName,
      date: date,
      value: value,
      paymentType: paymentType.name,
    );
  }

  /// Converts all selected medicines into BillMedicineTableCompanions
  List<BillMedicineTableCompanion> toMedicineCompanions() {
    return selectedMedicine
        .map((medicine) => medicine.toCompanion(invNo: invNo))
        .toList();
  }
}

extension BillDataMapper on BillTableData {
  /// Maps BillTableData and its medicines back into InvModel
  InvModel toModel({List<BillMedicineTableData> medicines = const []}) {
    return InvModel(
      invNo: invNo,
      customerType: customerType,
      customerName: customerName,
      date: date,
      value: value,
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == paymentType,
        orElse: () => PaymentType.cash,
      ),
      selectedMedicine: medicines.map((m) => m.toModel()).toList(),
    );
  }
}
