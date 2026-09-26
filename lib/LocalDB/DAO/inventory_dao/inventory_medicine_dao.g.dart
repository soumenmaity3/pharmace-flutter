// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_medicine_dao.dart';

// ignore_for_file: type=lint
mixin _$InventoryMedicineDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicineTableTable get medicineTable => attachedDatabase.medicineTable;
  InventoryMedicineDaoManager get managers => InventoryMedicineDaoManager(this);
}

class InventoryMedicineDaoManager {
  final _$InventoryMedicineDaoMixin _db;
  InventoryMedicineDaoManager(this._db);
  $$MedicineTableTableTableManager get medicineTable =>
      $$MedicineTableTableTableManager(_db.attachedDatabase, _db.medicineTable);
}
