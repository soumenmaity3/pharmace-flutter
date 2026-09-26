import 'package:pharmace/Backend/model/Input/shop_model.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';

class ShopReturnModel {
  final String id;
  final String shopName;
  final String shopEmail;
  final String shopCode;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  String? licenseNumber;
  String? gstNumber;
  final Verify verifyStatus;
  String? logoUrl;
  bool? isOpen;
  final bool isOwnerEmployee;
  final ShopOwnerModel owner;

  ShopReturnModel({
    required this.id,
    required this.shopName,
    required this.shopEmail,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.verifyStatus,
    this.isOpen,
    required this.owner,
    this.logoUrl,
    this.gstNumber,
    this.licenseNumber,
    required this.shopCode,
    this.isOwnerEmployee = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'shopEmail': shopEmail,
      'shopCode': shopCode,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'verifyStatus': verifyStatus,
      'isOpen': isOpen,
      'isOwnerEmployee': isOwnerEmployee,
      'owner': owner.toJson(),
      'logoUrl': logoUrl,
      'gstNumber': gstNumber,
      'licenseNumber': licenseNumber,
    };
  }

  factory ShopReturnModel.fromJson(Map<String, dynamic> json) {
    return ShopReturnModel(
      id: json['id'],
      shopName: json['shopName'],
      shopEmail: json['shopEmail'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      verifyStatus: Verify.values.firstWhere(
        (v) =>
            v.label.toLowerCase() ==
            (json['verifyStatus'] as String?)?.toLowerCase(),
        orElse: () => Verify.pending,
      ),
      logoUrl: json['logoUrl']?.toString(),
      isOpen: json['isOpen'] as bool?,
      isOwnerEmployee: (json['isOwnerEmployee'] ?? json['is_owner_employee']) as bool? ?? false,
      owner: ShopOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      shopCode: json['shopCode'],
    );
  }
  static List<ShopReturnModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => ShopReturnModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
