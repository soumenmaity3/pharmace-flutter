import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/model/Output/employee_return_model.dart';
import 'package:pharmace/Backend/model/api_response.dart';
import 'package:pharmace/Frontend/Employees/data/employee_data.dart';
import 'package:pharmace/Frontend/Employees/model/employee_model.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/database_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

import '../Backend/api_service.dart';

final employeeProvider = StateNotifierProvider((ref) {
  final currentShopId = ref.watch(selectedShopProvider)?.id;
  final db = ref.watch(databaseProvider);
  return _EmployeeNotifier(db, currentShopId);
});

class _EmployeeNotifier extends StateNotifier<_EmployeeState> {
  AppDatabase db;

  String? currentShopId;

  _EmployeeNotifier(this.db, this.currentShopId)
    : super(_EmployeeState(allEmployee: [], filteredEmployee: [], search: '')) {
    if (currentShopId != null && currentShopId!.isNotEmpty) {
      loadAllEmployee(currentShopId!);
    }
  }

  Future<void> loadAllEmployee(String currentShopId) async {
    final List<EmployeeTableData> employeesData = await db.employeeDao
        .getAllEmployees(currentShopId);
    final List<EmployeeModel> employees = employeesData.map((e) {
      final role = Role.values.firstWhere(
        (r) => r.name.toLowerCase() == e.role.toLowerCase(),
        orElse: () => Role.staff,
      );

      return EmployeeModel(
        id: e.id,
        name: e.name,
        email: e.email,
        phone: '',
        joinDate: e.createdAt,
        revenueValue: '0',
        sales: 0,
        rating: 0.0,
        role: role,
        isActive: true,
      );
    }).toList();
    state = state.copyWith(allEmployee: employees, filteredEmployee: employees);
  }

  Future<ApiResponse<List<EmployeeReturnModel>>> fetchAndSyncFromBackend({
    required String shopId,
  }) async {
    final response = await ApiService().getAllEmployee(shopId: shopId);
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        response.data != null) {
      await syncFromBackend(response.data!, shopId);
    }
    return response;
  }
  Future<void> syncFromBackend(List<EmployeeReturnModel> employees,String shopId)async {
    await db.employeeDao.syncEmployees(employees, shopId);
    await loadAllEmployee(shopId);

  }

  void updateEmployee(EmployeeModel model) {
    final updateItem = state.allEmployee.map((item) {
      if (item.id == model.id) {
        return item.copyWith(
          name: model.name,
          email: model.email,
          isActive: model.isActive,
          phone: model.phone,
          role: model.role,
        );
      }
      return item;
    }).toList();
    state = state.copyWith(allEmployee: updateItem);
  }

  void updateEmployeeStatus({
    required String employeeId,
    required bool isActive,
  }) {
    final updatedEmployees = state.allEmployee.map((item) {
      if (item.id == employeeId) {
        return item.copyWith(isActive: isActive);
      }

      return item;
    }).toList();

    state = state.copyWith(allEmployee: updatedEmployees);
  }

  // void updateEmployeeRole({required String employeeId, required Role role}) {
  //   final updatedEmployees = state.allEmployee.map((item) {
  //     if (item.id == employeeId) {
  //       return item.copyWith(role: role);
  //     }
  //     return item;
  //   }).toList();
  //   state = state.copyWith(allEmployee: updatedEmployees);
  // }

  void search(String query) {
    final searchQuery = query.toLowerCase().trim();
    state = state.copyWith(
      filteredEmployee: _searchByQuery(
        allEmployee: state.allEmployee,
        query: searchQuery,
      ),
    );
  }

  List<EmployeeModel> _searchByQuery({
    required List<EmployeeModel> allEmployee,
    required String query,
  }) {
    if (query.isEmpty) {
      return allEmployee;
    }
    return allEmployee
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.email.toLowerCase().contains(query),
        )
        .toList();
  }

  void filteredEmployee(String query) {
    final filterQuery = query.toLowerCase().trim();
    state = state.copyWith(
      filteredEmployee: _filteredEmployee(
        emp: state.allEmployee,
        query: filterQuery,
      ),
    );
  }

  List<EmployeeModel> _filteredEmployee({
    required List<EmployeeModel> emp,
    required String query,
  }) {
    if (query == 'all') {
      return emp;
    }
    if (query == 'manager') {
      return emp.where((item) => item.role == Role.manager).toList();
    }
    if (query == 'cashier') {
      return emp.where((item) => item.role == Role.cashier).toList();
    }
    if (query == 'pharmacist') {
      return emp.where((item) => item.role == Role.pharmacist).toList();
    } else {
      return emp.where((item) => item.role == Role.staff).toList();
    }
  }
}

class _EmployeeState {
  final List<EmployeeModel> allEmployee;
  final List<EmployeeModel> filteredEmployee;
  final String search;

  _EmployeeState({
    required this.allEmployee,
    required this.filteredEmployee,
    required this.search,
  });

  _EmployeeState copyWith({
    List<EmployeeModel>? allEmployee,
    List<EmployeeModel>? filteredEmployee,
    String? search,
  }) {
    return _EmployeeState(
      allEmployee: allEmployee ?? this.allEmployee,
      filteredEmployee: filteredEmployee ?? this.filteredEmployee,
      search: search ?? this.search,
    );
  }
}
