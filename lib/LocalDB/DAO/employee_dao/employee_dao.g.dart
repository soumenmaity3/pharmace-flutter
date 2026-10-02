// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_dao.dart';

// ignore_for_file: type=lint
mixin _$EmployeeDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmployeeTableTable get employeeTable => attachedDatabase.employeeTable;
  EmployeeDaoManager get managers => EmployeeDaoManager(this);
}

class EmployeeDaoManager {
  final _$EmployeeDaoMixin _db;
  EmployeeDaoManager(this._db);
  $$EmployeeTableTableTableManager get employeeTable =>
      $$EmployeeTableTableTableManager(_db.attachedDatabase, _db.employeeTable);
}
