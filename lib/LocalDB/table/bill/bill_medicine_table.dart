import 'package:drift/drift.dart';
import 'package:pharmace/LocalDB/table/bill/bill_table.dart';

class BillMedicineTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get invNo =>
      text().references(BillTable, #invNo, onDelete: KeyAction.cascade)();

  TextColumn get medicineId => text()();
  TextColumn get medicineName => text()();
  IntColumn get strip => integer()();
  IntColumn get loose => integer().nullable()();
  IntColumn get looseQty => integer()();
  BoolColumn get isLooseAvailable => boolean()();
  RealColumn get price => real()();
  RealColumn get tagPrice => real()();
  RealColumn get totalPrice => real()();
}
