import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';

class OwnerSignUpReturnModel {
  final String token;
  final ShopOwnerModel owner;

  OwnerSignUpReturnModel({required this.token, required this.owner});

  factory OwnerSignUpReturnModel.fromJson(Map<String, dynamic> json) {
    return OwnerSignUpReturnModel(
      token: json['token'],
      owner: ShopOwnerModel.fromJson(json['details']),
    );
  }
}
