import 'package:drift/drift.dart';

class MedicineTable extends Table {
  TextColumn get id => text()();
  TextColumn get medName => text()();
  TextColumn get genericName => text()();
  TextColumn get brand => text()();
  TextColumn get category => text()();
  TextColumn get strength => text()();
  TextColumn get dosageForm => text()();
  TextColumn get schedule => text().withDefault(const Constant('NONE'))();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get batchNo => text()();

  // Stock & Inventory
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  BoolColumn get avLoose => boolean().withDefault(const Constant(false))();
  IntColumn get looseQuantity =>
      integer().nullable().withDefault(const Constant(0))();
  IntColumn get totalLooseInStrip =>
      integer().nullable().withDefault(const Constant(0))();
  IntColumn get minStockLevel => integer().withDefault(const Constant(0))();
  IntColumn get maxStockLevel => integer().withDefault(const Constant(100))();
  TextColumn get stockStatus =>
      text().withDefault(const Constant('inStock'))();

  // Pricing
  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0.0))();
  RealColumn get mrp => real().withDefault(const Constant(0.0))();

  // Dates & Info
  TextColumn get manufactureDate => text()();
  TextColumn get expiryDate => text()();
  TextColumn get supplier => text().nullable()();
  TextColumn get addDate => text().nullable()();
  TextColumn get updateDate => text().nullable()();

  // Relation references
  TextColumn get shopId => text().nullable()();
  TextColumn get addedBy => text().nullable()();
  TextColumn get updatedBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
