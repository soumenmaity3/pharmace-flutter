import 'package:drift/drift.dart';

class BillTable extends Table {
  TextColumn get invNo => text()();
  IntColumn get customerType => integer()();
  TextColumn get customerName => text()();
  TextColumn get date => text()();
  RealColumn get value => real()();
  TextColumn get paymentType => text()();

  @override
  Set<Column> get primaryKey => {invNo};
}
