class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final String joinDate;
  final String revenueValue;
  final int sales;
  final double rating;
  final Role role;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.joinDate,
    required this.revenueValue,
    required this.sales,
    required this.rating,
    required this.role,
    required this.id,
    this.isActive = true,
  });
  EmployeeModel copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isActive,
    String? revenueValue,
    int? sales,
    double? rating,
    Role? role,
  }) {
    return EmployeeModel(
      id: id ,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      joinDate: joinDate,
      revenueValue: revenueValue ?? this.revenueValue,
      sales: sales ?? this.sales,
      rating: rating ?? this.rating,
      role: role ?? this.role,
    );
  }
}

enum Role { manager, pharmacist, cashier, staff }
