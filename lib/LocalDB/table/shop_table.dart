import 'package:drift/drift.dart';

class ShopTable extends Table {
  TextColumn get id => text()();
  TextColumn get shopName => text()();
  TextColumn get shopEmail => text()();
  TextColumn get shopCode => text()();
  TextColumn get phone => text()();
  TextColumn get address => text()();
  TextColumn get city => text()();
  TextColumn get state => text()();
  TextColumn get pincode => text()();
  TextColumn get licenseNumber => text().nullable()();
  TextColumn get gstNumber => text().nullable()();
  TextColumn get verifyStatus =>
      text().withDefault(const Constant('Pending'))();
  BoolColumn get isOwnerEmployee =>
      boolean().withDefault(const Constant(false))();
  TextColumn get logoUrl => text().nullable()();
  BoolColumn get isOpen => boolean().nullable()();
  TextColumn get ownerId => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}
