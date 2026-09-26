import 'package:drift/drift.dart';

class OwnerAuthTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text()();
  BoolColumn get isShopHave => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text().nullable()();
  TextColumn get selectedShopId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
} 