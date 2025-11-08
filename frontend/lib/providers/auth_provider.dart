import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/api_client.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required ApiClient apiClient,
    FlutterSecureStorage? secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _authService = AuthService(apiClient);

  static const _tokenKey = 'auth_token';

  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
  final AuthService _authService;

  AppUser? _user;
  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  AppUser? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    final storedToken = await _secureStorage.read(key: _tokenKey);
    if (storedToken != null) {
      _token = storedToken;
      _apiClient.setAuthToken(_token);
      try {
        _user = await _authService.getProfile();
      } catch (error) {
        await logout();
        debugPrint('Failed to restore session: $error');
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _authenticate(() => _authService.login(email: email, password: password));
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    return _authenticate(
      () => _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      ),
    );
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _apiClient.setAuthToken(null);
    await _secureStorage.delete(key: _tokenKey);
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    if (_token == null) return;
    _user = await _authService.getProfile();
    notifyListeners();
  }

  Future<bool> _authenticate(
    Future<(String, AppUser)> Function() authOperation,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (token, user) = await authOperation();
      _token = token;
      _user = user;
      _apiClient.setAuthToken(token);
      await _secureStorage.write(key: _tokenKey, value: token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      _errorMessage = _mapError(error);
      notifyListeners();
      return false;
    }
  }

  String? _mapError(Object error) {
    if (error is DioException) {
      final message = error.response?.data is Map<String, dynamic>
          ? (error.response!.data['message'] as String?)
          : null;
      return message ?? 'Unable to authenticate. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}

