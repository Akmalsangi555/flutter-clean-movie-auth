
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final FlutterSecureStorage _storage;
  bool _isInitialized = false;

  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';

  Future<void> init() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      // Web platform uses web-specific implementation
      _storage = FlutterSecureStorage(
        aOptions: const AndroidOptions(),
        iOptions: IOSOptions(),
        webOptions: const WebOptions(),
      );
    } else {
      _storage = const FlutterSecureStorage();
    }

    _isInitialized = true;
  }

  FlutterSecureStorage get storage {
    if (!_isInitialized) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _storage;
  }

  // Token methods
  Future<void> saveToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  // User data methods
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final userDataString = jsonEncode(userData);
    await storage.write(key: userDataKey, value: userDataString);
    await storage.write(key: userIdKey, value: userData['user_id']?.toString() ?? '');
    await storage.write(key: userEmailKey, value: userData['email'] ?? '');
    await storage.write(key: userNameKey, value: '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await storage.read(key: userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  Future<String?> getUserId() async {
    return await storage.read(key: userIdKey);
  }

  Future<String?> getUserEmail() async {
    return await storage.read(key: userEmailKey);
  }

  // Auth status
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all
  Future<void> clearAll() async {
    await storage.delete(key: tokenKey);
    await storage.delete(key: userDataKey);
    await storage.delete(key: userIdKey);
    await storage.delete(key: userEmailKey);
    await storage.delete(key: userNameKey);
  }

  bool get isInitialized => _isInitialized;
}
