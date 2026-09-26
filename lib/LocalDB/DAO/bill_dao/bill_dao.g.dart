// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_dao.dart';

// ignore_for_file: type=lint
mixin _$BillDaoMixin on DatabaseAccessor<AppDatabase> {
  $BillTableTable get billTable => attachedDatabase.billTable;
  $BillMedicineTableTable get billMedicineTable =>
      attachedDatabase.billMedicineTable;
  BillDaoManager get managers => BillDaoManager(this);
}

class BillDaoManager {
  final _$BillDaoMixin _db;
  BillDaoManager(this._db);
  $$BillTableTableTableManager get billTable =>
      $$BillTableTableTableManager(_db.attachedDatabase, _db.billTable);
  $$BillMedicineTableTableTableManager get billMedicineTable =>
      $$BillMedicineTableTableTableManager(
        _db.attachedDatabase,
        _db.billMedicineTable,
      );
}
