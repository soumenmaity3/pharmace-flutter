import 'package:drift/drift.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/LocalDB/Maper/bill/bill_maper.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/LocalDB/table/bill/bill_medicine_table.dart';
import 'package:pharmace/LocalDB/table/bill/bill_table.dart';

part 'bill_dao.g.dart';

@DriftAccessor(tables: [BillTable, BillMedicineTable])
class BillDao extends DatabaseAccessor<AppDatabase> with _$BillDaoMixin {
  BillDao(super.db);

  /// CREATE: Insert a complete bill with all its medicines
  Future<void> insertBill(InvModel bill) async {
    await transaction(() async {
      await into(billTable).insert(bill.toCompanion());
      await batch((b) {
        b.insertAll(billMedicineTable, bill.toMedicineCompanions());
      });
    });
  }

  /// READ: Fetch all bills with their medicines
  Future<List<InvModel>> getAllBills() async {
    final bills = await select(billTable).get();
    final allMedicines = await select(billMedicineTable).get();

    // Group medicines by invoice number
    final medicineMap = <String, List<BillMedicineTableData>>{};
    for (final med in allMedicines) {
      medicineMap.putIfAbsent(med.invNo, () => []).add(med);
    }

    return bills.map((bill) {
      return bill.toModel(medicines: medicineMap[bill.invNo] ?? []);
    }).toList();
  }


  /// READ: Fetch a bill and its medicines by invoice number
  Future<InvModel?> getBillByInvNo(String invNo) async {
    final billRow = await (select(
      billTable,
    )..where((t) => t.invNo.equals(invNo))).getSingleOrNull();
    if (billRow == null) return null;

    final medicineRows = await (select(
      billMedicineTable,
    )..where((t) => t.invNo.equals(invNo))).get();
    return billRow.toModel(medicines: medicineRows);
  }

  ///UPDATE: Update only paymentType
  Future<void> updatePaymenType({
    required String invNo,
    required PaymentType paymentType,
  }) async {
    await transaction(() async {
      await (update(billTable)..where((item) => item.invNo.equals(invNo)))
          .write(BillTableCompanion(paymentType: Value(paymentType.name)));
    });
  }

  /// UPDATE: Update an existing bill and replace its medicines
  Future<void> updateBill(InvModel bill) async {
    await transaction(() async {
      await (update(
        billTable,
      )..where((t) => t.invNo.equals(bill.invNo))).write(bill.toCompanion());

      await (delete(
        billMedicineTable,
      )..where((t) => t.invNo.equals(bill.invNo))).go();

      await batch((b) {
        b.insertAll(billMedicineTable, bill.toMedicineCompanions());
      });
    });
  }

  /// UPDATE: Update only the payment type
  Future<int> updatePaymentStatus(String invNo, PaymentType paymentType) {
    return (update(billTable)..where((t) => t.invNo.equals(invNo))).write(
      BillTableCompanion(paymentType: Value(paymentType.name)),
    );
  }

  /// DELETE: Delete a bill and its associated medicines
  Future<void> deleteBill(String invNo) async {
    await transaction(() async {
      await (delete(billMedicineTable)..where((t) => t.invNo.equals(invNo))).go();
      await (delete(billTable)..where((t) => t.invNo.equals(invNo))).go();
    });
  }

  /// DELETE: Delete all bills and their medicines
  Future<void> deleteAllData() async {
    await transaction(() async {
      await delete(billMedicineTable).go();
      await delete(billTable).go();
    });
  }

}
