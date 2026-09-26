import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const String authTokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: authTokenKey,
      value: token,
    );
  }

  static Future<String?> getToken() async {
    return await _storage.read(
      key: authTokenKey,
    );
  }

  static Future<void> deleteToken() async {
    await _storage.delete(
      key: authTokenKey,
    );
  }
}