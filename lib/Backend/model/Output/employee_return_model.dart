import 'package:pharmace/Backend/model/Output/shop_return_model.dart';

class EmployeeReturnModel {
  final String? id;
  final String name;
  final String email;
  final String? password;
  final String? role;
  final bool? isFromOwner;
  final String? createdAt;
  final ShopReturnModel? shop;

  const EmployeeReturnModel({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.role,
    this.isFromOwner,
    this.createdAt,
    this.shop,
  });

  EmployeeReturnModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    bool? isFromOwner,
    String? createdAt,
    ShopReturnModel? shop,
  }) {
    return EmployeeReturnModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isFromOwner: isFromOwner ?? this.isFromOwner,
      createdAt: createdAt ?? this.createdAt,
      shop: shop ?? this.shop,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (isFromOwner != null) 'isFromOwner': isFromOwner,
      if (createdAt != null) 'createdAt': createdAt,
      if (shop != null) 'shop': shop?.toJson(),
    };
  }

  factory EmployeeReturnModel.fromJson(Map<String, dynamic> json) {
    return EmployeeReturnModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String?,
      role: json['role'] as String?,
      isFromOwner: json['isFromOwner'] as bool?,
      createdAt: json['createdAt'] as String?,
      shop: json['shop'] != null && json['shop'] is Map<String, dynamic>
          ? ShopReturnModel.fromJson(json['shop'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<EmployeeReturnModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (item) => EmployeeReturnModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}

typedef EmployeeOutputModel = EmployeeReturnModel;
