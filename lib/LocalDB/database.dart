import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmace/LocalDB/DAO/OwnerDao/owner_auth_dao.dart';
import 'package:pharmace/LocalDB/DAO/bill_dao/bill_dao.dart';
import 'package:pharmace/LocalDB/DAO/inventory_dao/inventory_medicine_dao.dart';
import 'package:pharmace/LocalDB/DAO/shop_dao/shop_dao.dart';
import 'package:pharmace/LocalDB/table/bill/bill_medicine_table.dart';
import 'package:pharmace/LocalDB/table/bill/bill_table.dart';
import 'package:pharmace/LocalDB/table/employee_table.dart';
import 'package:pharmace/LocalDB/table/inventory/medicine_table.dart';
import 'package:pharmace/LocalDB/table/owner_auth_table.dart';
import 'package:pharmace/LocalDB/table/shop_table.dart';

import 'DAO/employee_dao/employee_dao.dart';

part 'database.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@DriftDatabase(
  tables: [
    MedicineTable,
    BillTable,
    BillMedicineTable,
    OwnerAuthTable,
    ShopTable,
    EmployeeTable
  ],
  daos: [InventoryMedicineDao, BillDao, OwnerAuthDao, ShopDao,EmployeeDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(billTable);
        await m.createTable(billMedicineTable);
      }
      if (from < 3) {
        await m.createTable(ownerAuthTable);
      }
      if (from < 4) {
        await m.create(shopTable);
      }
      if (from < 5) {
        await m.renameColumn(shopTable, 'owner_id', shopTable.ownerId);
      }
      if (from < 6) {
        await m.addColumn(ownerAuthTable, ownerAuthTable.selectedShopId);
      }
      if (from < 8) {
        await m.addColumn(medicineTable, medicineTable.schedule);
      }
      if (from < 9) {
        await m.drop(medicineTable);
        await m.createTable(medicineTable);
      }
      if (from < 10) {
        try {
          await customStatement('ALTER TABLE owner_auth_table DROP COLUMN is_self_employee');
        } catch (_) {}
        await m.addColumn(shopTable, shopTable.isOwnerEmployee);
      }
      if(from<11){
        await m.createTable(employeeTable);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');

      // Safety check: verify medicine_table has required columns like med_name
      final tableInfo =
          await customSelect("PRAGMA table_info('medicine_table')").get();
      final columnNames =
          tableInfo.map((row) => row.read<String>('name')).toSet();
      if (columnNames.isNotEmpty && !columnNames.contains('med_name')) {
        await customStatement('DROP TABLE IF EXISTS "medicine_table"');
        final m = createMigrator();
        await m.createTable(medicineTable);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'medicine_inventory',
      // web: DriftWebOptions(
      //   sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      //   driftWorker: Uri.parse('drift_worker.js'),
      // ),
      native: DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
    );
  }
}
