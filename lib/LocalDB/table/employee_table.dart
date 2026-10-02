import 'package:drift/drift.dart';

class EmployeeTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get email => text()();

  TextColumn get role => text().withDefault(const Constant('Manager'))();

  BoolColumn get isFromOwner => boolean().withDefault(const Constant(true))();

  TextColumn get shopId => text().nullable()();

  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
