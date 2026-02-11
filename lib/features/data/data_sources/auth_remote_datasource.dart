
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webflow_auth_app/features/data/models/sign_up_user_model.dart';
import '../../../../core/network/network_api_service.dart';
import '../../../../core/constants/app_url.dart';
import '../models/user_login_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserLoginModel> login(String email, String password);
  Future<SignUpUserModel> signup(Map<String, dynamic> userData);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkApiService _apiService;
  final FlutterSecureStorage _storage;

  AuthRemoteDataSourceImpl({
    required NetworkApiService apiService,
    required FlutterSecureStorage storage,
  })  : _apiService = apiService,
        _storage = storage;

  @override
  Future<UserLoginModel> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    final response = await _apiService.postApi(AppUrl.login, data);

    // Save token to secure storage
    if (response['token'] != null) {
      await _storage.write(key: 'auth_token', value: response['token']);
      await _storage.write(key: 'user_id', value: response['user']['user_id'].toString());
    }

    return UserLoginModel.fromJson(response);
  }

  @override
  Future<SignUpUserModel> signup(Map<String, dynamic> userData) async {
    final response = await _apiService.postApi(AppUrl.register, userData);
    return SignUpUserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    try {
      await _apiService.postApi(AppUrl.logout, {});
    } finally {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_id');
    }
  }
}
