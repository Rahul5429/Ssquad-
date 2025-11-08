import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/user.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<(String, AppUser)> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
    return _parseAuthResponse(response);
  }

  Future<(String, AppUser)> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return _parseAuthResponse(response);
  }

  Future<AppUser> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/auth/me');
    return AppUser.fromJson(response.data?['data'] as Map<String, dynamic>);
  }

  (String, AppUser) _parseAuthResponse(Response<Map<String, dynamic>> response) {
    final payload = response.data?['data'] as Map<String, dynamic>;
    final token = payload['token'] as String;
    final user = AppUser.fromJson(payload['user'] as Map<String, dynamic>);
    return (token, user);
  }
}

