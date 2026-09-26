import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pharmace/Backend/auth/secure_storage_service.dart';
import 'package:pharmace/Backend/model/Input/medicine_input_model.dart';
import 'package:pharmace/Backend/model/Input/shop_model.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Backend/model/Output/shop_return_model.dart';
import 'package:pharmace/Backend/model/api_response.dart';
import 'package:pharmace/Backend/model/Output/owner_sign_up_return_model.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/Backend/model/Output/sign_in_return.dart';

class ApiService {
  static Future<String?> getToken() async {
    return SecureStorageService.getToken();
  }

  static Future<bool> isTokenExpired() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return true;
    }

    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  static String get baseUrl =>
      'http://${Platform.isAndroid ? '10.95.27.150' : 'localhost'}:8080/v1';
  static const Map<String, String> header = {
    'Content-Type': 'application/json',
  };

  Future<ApiResponse<OwnerSignUpReturnModel>> signUpOwner(
    ShopOwnerModel owner,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/ownr/sign-up'),
          headers: header,
          body: jsonEncode(owner.toJson()),
        )
        .timeout(Duration(seconds: 15));

    Map<String, dynamic>? json;
    String? message;
    if (response.body.trim().isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        json = decoded;
        message =
            decoded['message']?.toString() ?? decoded['error']?.toString();
      } else if (decoded is String) {
        message = decoded;
      }
    }
    message ??= response.body.trim().isNotEmpty ? response.body : null;

    return ApiResponse(
      statusCode: response.statusCode,
      data:
          response.statusCode >= 200 &&
              response.statusCode < 300 &&
              json != null
          ? OwnerSignUpReturnModel.fromJson(json)
          : null,
      message: message,
    );
  }

  Future<ApiResponse<SignInReturn>> signInOwner(
    Map<String, String> loginDetails,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/ownr/sign-in'),
          headers: header,
          body: jsonEncode(loginDetails),
        )
        .timeout(Duration(seconds: 15));
    Map<String, dynamic>? json;
    String? message;
    if (response.body.trim().isNotEmpty) {
      final decode = jsonDecode(response.body);
      if (decode is Map<String, dynamic>) {
        json = decode;
        message = decode['message']?.toString() ?? decode['error']?.toString();
      } else {
        message = decode;
      }
    }
    message ??= response.body.trim().isNotEmpty ? response.body : null;

    return ApiResponse(
      statusCode: response.statusCode,
      data:
          response.statusCode >= 200 &&
              response.statusCode < 300 &&
              json != null
          ? SignInReturn.fromJson(json)
          : null,
      message: message,
    );
  }

  Future<ApiResponse<List<ShopReturnModel>>> getOwnerShops() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/shop/get-owner-shop'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          final shops = ShopReturnModel.fromJsonList(decoded);
          return ApiResponse(statusCode: response.statusCode, data: shops);
        }
      }

      return ApiResponse(
        statusCode: response.statusCode,
        message: 'Failed to load shops',
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, message: e.toString());
    }
  }

  Future<ApiResponse<bool>> isHaveThisOwner() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: false,
          message: 'Token not found',
        );
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/ownr/token-valid'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 15));

      bool? data;
      String? message;

      if (response.body.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is bool) {
            data = decoded;
          } else if (decoded is Map<String, dynamic>) {
            message =
                decoded['message']?.toString() ?? decoded['error']?.toString();
          } else {
            message = decoded.toString();
          }
        } catch (e) {
          message = response.body;
        }
      }

      return ApiResponse<bool>(
        statusCode: response.statusCode,
        data: data,
        message: message,
      );
    } catch (e) {
      return ApiResponse<bool>(
        statusCode: 500,
        data: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<bool>> isShopHaveOfThisOwner() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse<bool>(
          statusCode: 500,
          data: false,
          message: 'Token is not valid',
        );
      }
      final response = await http
          .get(
            Uri.parse('$baseUrl/ownr/isShopHave'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 15));
      bool? data;
      String? message;
      if (response.body.trim().isNotEmpty) {
        try {
          final decode = jsonDecode(response.body);
          if (decode is bool) {
            data = decode;
          } else if (decode is Map<String, dynamic>) {
            message =
                decode['message']?.toString() ?? decode['error'].toString();
          } else {
            message = response.body;
          }
        } catch (e) {
          message = e.toString();
        }
      }
      return ApiResponse(
        statusCode: response.statusCode,
        data: data,
        message: message,
      );
    } catch (e) {
      return ApiResponse<bool>(
        statusCode: 500,
        data: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> addShop(ShopModel shop) async {
    // try {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 500,
        data: null,
        message: 'Token is not valid',
      );
    }
    final response = await http
        .post(
          Uri.parse('$baseUrl/shop/add-shop'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(shop),
        )
        .timeout(Duration(seconds: 15));
    Map<String, dynamic>? json;
    String? message;
    if (response.body.trim().isNotEmpty) {
      // try {
      final decode = jsonDecode(response.body);

      if (decode is Map<String, dynamic>) {
        json = decode;
        message = decode['message']?.toString() ?? decode['error']?.toString();
      } else {
        message = decode;
      }

      return ApiResponse(
        statusCode: response.statusCode,
        data:
            response.statusCode >= 200 &&
                response.statusCode < 300 &&
                json != null
            ? decode
            : null,
        message: message,
      );
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: null,
      message: 'Empty response body',
    );
  }

  Future<ApiResponse<int>> markSelfEmployee(String shopId) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }
      final response = await http
          .put(
            Uri.parse('$baseUrl/ownr/mark-self-employee?shopId=$shopId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      String? message;
      if (response.body.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            message =
                decoded['message']?.toString() ?? decoded['error']?.toString();
          } else {
            message = decoded.toString();
          }
        } catch (_) {
          message = response.body;
        }
      }

      return ApiResponse(
        statusCode: response.statusCode,
        data: response.statusCode,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<bool>> toggleShopStatus(String shopId) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }

      final response = await http
          .put(
            Uri.parse('$baseUrl/shop/shop-is-open?shopId=$shopId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      bool? data;
      String? message;

      if (response.body.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is bool) {
            data = decoded;
          } else if (decoded is Map<String, dynamic>) {
            message =
                decoded['message']?.toString() ?? decoded['error']?.toString();
            if (decoded['data'] is bool) {
              data = decoded['data'] as bool;
            }
          } else {
            message = decoded.toString();
          }
        } catch (_) {
          final trimmed = response.body.trim().toLowerCase();
          if (trimmed == 'true') {
            data = true;
          } else if (trimmed == 'false') {
            data = false;
          } else {
            message = response.body;
          }
        }
      }

      return ApiResponse<bool>(
        statusCode: response.statusCode,
        data: response.statusCode >= 200 && response.statusCode < 300
            ? data
            : null,
        message: message,
      );
    } catch (e) {
      return ApiResponse<bool>(
        statusCode: 500,
        data: null,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<MedicineOutputModel>> addMedicine(
    String shopId,
    MedicineInputModel medicine,
  ) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }
      final response = await http
          .post(
            Uri.parse('$baseUrl/inv/add-med/$shopId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(medicine.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic>? json;
      String? message;
      if (response.body.trim().isNotEmpty) {
        try {
          final decode = jsonDecode(response.body);
          if (decode is Map<String, dynamic>) {
            json = decode;
            message =
                decode['message']?.toString() ??
                decode['error']?.toString() ??
                decode['detail']?.toString();
          } else {
            message = decode.toString();
          }
        } on FormatException {
          message = response.body.trim();
        }
      }
      message ??= response.body.trim().isNotEmpty ? response.body : null;

      return ApiResponse(
        statusCode: response.statusCode,
        data:
            response.statusCode >= 200 &&
                response.statusCode < 300 &&
                json != null
            ? MedicineOutputModel.fromJson(json)
            : null,
        message: message,
      );
    } on FormatException catch (e) {
      return ApiResponse(statusCode: 502, data: null, message: e.toString());
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<List<MedicineOutputModel>>> getInventory({
    required String shopId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }

      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/inv/get-inv/$shopId'
              '?page=$page'
              '&size=$size',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      List<MedicineOutputModel>? medicines;
      String? message;

      if (response.body.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is List) {
            medicines = MedicineOutputModel.fromJsonList(decoded);
          } else if (decoded is Map<String, dynamic>) {
            message =
                decoded['message']?.toString() ??
                decoded['error']?.toString() ??
                decoded['detail']?.toString();

            final rawList =
                decoded['content'] ??
                decoded['data'] ??
                decoded['items'] ??
                decoded['medicines'];

            if (rawList is List) {
              medicines = MedicineOutputModel.fromJsonList(rawList);
            }
          } else {
            message = decoded.toString();
          }
        } on FormatException {
          message = response.body.trim();
        }
      }

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse<List<MedicineOutputModel>>(
        statusCode: response.statusCode,
        data: isSuccess ? (medicines ?? []) : null,
        message: message ?? (isSuccess ? null : 'Failed to load inventory'),
      );
    } on FormatException catch (e) {
      return ApiResponse(statusCode: 502, data: null, message: e.toString());
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<MedicineOutputModel>> updateMedicine({
    required String shopId,
    required MedicineInputModel inputModel,
    required String invId,
  }) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }
      final response = await http
          .put(
            Uri.parse('$baseUrl/inv/update-med/$shopId/$invId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(inputModel),
          )
          .timeout(Duration(seconds: 15));
      MedicineOutputModel? medicine;
      String? message;
      if (response.body.trim().isNotEmpty) {
        final decode = jsonDecode(response.body);
        if (decode is Map<String, dynamic>) {
          medicine = MedicineOutputModel.fromJson(decode);
          message =
              decode['message']?.toString() ??
              decode['error']?.toString() ??
              decode['detail']?.toString();
        } else if (decode is String) {
          message = decode;
        }
      }
      return ApiResponse<MedicineOutputModel>(
        statusCode: response.statusCode,
        data: response.statusCode >= 200 && response.statusCode < 300
            ? medicine
            : null,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<MedicineOutputModel>> adjustStock({
    required String shopId,
    required String invId,
    int? adjustStock = 0,
    int? adjustLooseStock = 0,
  }) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }
      final response = await http
          .put(
            Uri.parse(
              '$baseUrl/inv/adj-stock/$shopId/$invId?adjustStock=$adjustStock&adjustLooseStock=$adjustLooseStock',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 15));
      MedicineOutputModel? medicine;
      String? message;
      if (response.body.trim().isNotEmpty) {
        final decode = jsonDecode(response.body);
        if (decode is Map<String, dynamic>) {
          medicine = MedicineOutputModel.fromJson(decode);
          message =
              decode['message']?.toString() ??
              decode['error']?.toString() ??
              decode['detail']?.toString();
        } else if (decode is String) {
          message = decode;
        }
      }
      return ApiResponse<MedicineOutputModel>(
        statusCode: response.statusCode,
        data: response.statusCode >= 200 && response.statusCode < 300
            ? medicine
            : null,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }
}
