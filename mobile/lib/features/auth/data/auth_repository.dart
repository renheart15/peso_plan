// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/auth_state.dart';

/// Handles all auth-related API calls and token management.
class AuthRepository {
  AuthRepository({
    required ApiClient api,
    required FlutterSecureStorage storage,
  })  : _api = api,
        _storage = storage;

  final ApiClient _api;
  final FlutterSecureStorage _storage;

  // ── Token management ─────────────────────────────────────────────

  Future<String?> getToken() => _storage.read(key: AppConstants.keyAuthToken);

  Future<void> saveToken(String token) =>
      _storage.write(key: AppConstants.keyAuthToken, value: token);

  Future<void> clearToken() =>
      _storage.delete(key: AppConstants.keyAuthToken);

  Future<bool> hasToken() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }

  // ── API calls ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );
    return ApiResponseUtils.unwrapData(res.data);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String householdName,
    required String deviceName,
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'household_name': householdName,
        'device_name': deviceName,
      },
    );
    return ApiResponseUtils.unwrapData(res.data);
  }

  Future<void> logout({String? deviceToken}) async {
    await _api.post<void>(
      '/auth/logout',
      data: deviceToken != null ? {'device_token': deviceToken} : null,
    );
    await clearToken();
  }

  Future<void> forgotPassword(String email) async {
    await _api.post<void>(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  Future<void> resendVerificationEmail() async {
    await _api.post<void>('/auth/email/resend');
  }

  Future<Map<String, dynamic>> me() async {
    final res = await _api.get<Map<String, dynamic>>('/auth/me');
    return ApiResponseUtils.unwrapData(res.data);
  }

  Future<void> registerDeviceToken({
    required String token,
    required String platform,
  }) async {
    await _api.post<void>(
      '/device-tokens',
      data: {'token': token, 'platform': platform},
    );
  }

  Future<void> removeDeviceToken(String token) async {
    await _api.delete<void>('/device-tokens/$token');
  }
}

// ── StateNotifier ────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthState()) {
    _init();
  }

  final AuthRepository _repo;

  Future<void> _init() async {
    final hasToken = await _repo.hasToken();
    if (!hasToken) {
      state = state.copyWith(isLoggedIn: false);
      return;
    }

    try {
      final data = await _repo.me();
      final user = data['user'] is Map<String, dynamic>
          ? data['user'] as Map<String, dynamic>
          : data;
      state = state.copyWith(
        isLoggedIn: true,
        userId: user['id'] as int?,
        userEmail: user['email'] as String?,
        userName: user['name'] as String?,
        isEmailVerified: user['email_verified_at'] != null,
        householdId: (user['current_household_id'] as int?),
      );
    } catch (_) {
      await _repo.clearToken();
      state = state.copyWith(isLoggedIn: false);
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.login(
        email: email,
        password: password,
        deviceName: deviceName,
      );
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await _repo.saveToken(token);

      final isFirstLogin = data['is_first_login'] as bool? ?? false;
      state = state.copyWith(
        isLoggedIn: true,
        isLoading: false,
        isFirstLogin: isFirstLogin,
        userId: user['id'] as int?,
        userEmail: user['email'] as String?,
        userName: user['name'] as String?,
        isEmailVerified: user['email_verified_at'] != null,
        householdId: user['current_household_id'] as int?,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is Exception ? e.toString() : 'Login failed.',
      );
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String householdName,
    required String deviceName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        householdName: householdName,
        deviceName: deviceName,
      );
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await _repo.saveToken(token);

      state = state.copyWith(
        isLoggedIn: true,
        isLoading: false,
        isFirstLogin: true,
        userId: user['id'] as int?,
        userEmail: user['email'] as String?,
        userName: user['name'] as String?,
        isEmailVerified: false,
        householdId: user['current_household_id'] as int?,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is Exception ? e.toString() : 'Registration failed.',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repo.logout();
    } finally {
      state = const AuthState(isLoggedIn: false);
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
