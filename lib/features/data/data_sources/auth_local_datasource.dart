
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> cacheUserData(Map<String, dynamic> userData);
  Future<Map<String, dynamic>?> getUserData();
  Future<void> clearAll();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl({required FlutterSecureStorage storage})
      : _storage = storage;

  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String userIdKey = 'user_id';

  @override
  Future<void> cacheToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  @override
  Future<void> cacheUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: userDataKey, value: jsonEncode(userData));
    if (userData['user_id'] != null) {
      await _storage.write(key: userIdKey, value: userData['user_id'].toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await _storage.read(key: userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  @override
  Future<void> clearAll() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: userDataKey);
    await _storage.delete(key: userIdKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
