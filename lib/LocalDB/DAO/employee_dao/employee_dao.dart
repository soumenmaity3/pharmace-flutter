import 'package:drift/drift.dart';
import 'package:pharmace/Backend/model/Output/employee_return_model.dart';

import '../../database.dart';
import '../../table/employee_table.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [EmployeeTable])
class EmployeeDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  Future<List<EmployeeTableData>> getAllEmployees(String shopId) async {
    return (select(employeeTable)..where((t) => t.shopId.equals(shopId))).get();
  }

  Future<void> syncEmployees(
    List<EmployeeReturnModel> employees,
    String shopId,
  ) async {
    await transaction(() async {
      await batch((b) {
        b.insertAllOnConflictUpdate(
          employeeTable,
          employees
              .map(
                (emp) => EmployeeTableCompanion(
                  id: Value(emp.id ?? ''),
                  name: Value(emp.name),
                  email: Value(emp.email),
                  role: Value(emp.role ?? 'Manager'),
                  shopId: Value(shopId),
                  createdAt: Value(emp.createdAt ?? ''),
                ),
              )
              .toList(),
        );
      });
    });
  }

  Future<void> deleteAll() async {
    delete(employeeTable).go();
  }
}
