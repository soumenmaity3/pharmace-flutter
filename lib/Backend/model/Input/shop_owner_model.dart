class ShopOwnerModel {
  final String? id;
  final String name;
  final String email;
  final String password;
  final Role role;
  final bool isShopHave;
  final String? createdAt;
  final String? selectedShopId;

  const ShopOwnerModel({
    this.id,
    required this.name,
    required this.email,
    this.password = '',
    required this.role,
    this.isShopHave = false,
    this.createdAt,
    this.selectedShopId,
  });

  ShopOwnerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    Role? role,
    bool? isShopHave,
    String? createdAt,
    String? selectedShopId,
  }) {
    return ShopOwnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isShopHave: isShopHave ?? this.isShopHave,
      createdAt: createdAt ?? this.createdAt,
      selectedShopId: selectedShopId ?? this.selectedShopId,
    );
  }

  // Dart → JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.value,
      'isShopHave': isShopHave,
      if (createdAt != null) 'createdAt': createdAt,
      if (selectedShopId != null) 'selectedShopId': selectedShopId,
    };
  }

  // JSON → Dart
  factory ShopOwnerModel.fromJson(Map<String, dynamic> json) {
    return ShopOwnerModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: Role.values.firstWhere(
        (role) =>
            role.value.toUpperCase() ==
            (json['role'] as String?)?.toUpperCase(),
        orElse: () => Role.owner,
      ),
      isShopHave: json['isShopHave'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      selectedShopId: json['selectedShopId'] as String?,
    );
  }
}

enum Role {
  owner('OWNER'),
  admin('ADMIN'),
  employee('EMPLOYEE');

  final String value;

  const Role(this.value);
}
