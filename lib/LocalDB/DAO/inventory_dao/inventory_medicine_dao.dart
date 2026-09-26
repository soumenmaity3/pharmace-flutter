import 'package:drift/drift.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/LocalDB/Maper/inventory/medicine_model_maper.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/LocalDB/table/inventory/medicine_table.dart';

part 'inventory_medicine_dao.g.dart';

@DriftAccessor(tables: [MedicineTable])
class InventoryMedicineDao extends DatabaseAccessor<AppDatabase>
    with _$InventoryMedicineDaoMixin {
  InventoryMedicineDao(super.db);

  /// Fetch all cached medicines
  Future<List<MedicineTableData>> getAllMedicines(String shopId) {
    return (select(medicineTable)..where((t)=>t.shopId.equals(shopId))).get();
  }

  /// Watch all cached medicines in real-time stream
  Stream<List<MedicineTableData>> watchAllMedicines(String shopId) {
    return (select(medicineTable)..where((t)=>t.shopId.equals(shopId))).watch();
  }

  /// Search medicines by medicine name, generic name, or brand
  Future<List<MedicineTableData>> searchMedicines(String query) {
    final cleanQuery = '%${query.toLowerCase().trim()}%';
    return (select(medicineTable)
          ..where((t) =>
              t.medName.lower().like(cleanQuery) |
              t.genericName.lower().like(cleanQuery) |
              t.brand.lower().like(cleanQuery)))
        .get();
  }

  /// Get single medicine by id
  Future<MedicineTableData?> getMedicineById(String id) {
    return (select(medicineTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Bulk sync medicines fetched from API
  Future<void> syncMedicines(List<MedicineOutputModel> medicines,String shopId) async {
    await transaction(() async {
      await batch((b) {
        b.insertAllOnConflictUpdate(
          medicineTable,
          medicines.map((med) => med.toCompanion().copyWith(shopId: Value(shopId))),
        );
      });
    });
  }

  /// Insert from UI MedicineOutputModel
  Future<void> insertMedicine(MedicineOutputModel medicine) {
    return into(medicineTable).insertOnConflictUpdate(medicine.toCompanion());
  }

  /// Insert or update directly with a companion
  Future<void> insertOrUpdateCompanion(MedicineTableCompanion companion) {
    return into(medicineTable).insertOnConflictUpdate(companion);
  }

  /// Delete a medicine by id
  Future<void> deleteMedicine(String id) {
    return (delete(medicineTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all local medicine records
  Future<int> deleteAllMedicines() {
    return delete(medicineTable).go();
  }

  /// Alias for backward compatibility
  Future<int> deleteAllData() => deleteAllMedicines();
}
