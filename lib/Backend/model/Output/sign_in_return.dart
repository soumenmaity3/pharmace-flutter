import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';

class SignInReturn {
  final String token;
  final ShopOwnerModel owner;

  SignInReturn({
    required this.token,
    required this.owner,
  });

  factory SignInReturn.fromJson(
    Map<String, dynamic> json,
  ) {
    return SignInReturn(
      token: json['token'],
      owner: ShopOwnerModel.fromJson(
        json['details'] as Map<String, dynamic>,
      ),
    );
  }
}