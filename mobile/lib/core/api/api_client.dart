import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Dio HTTP client configured with auth interceptor and timeout.
class ApiClient {
  ApiClient({
    FlutterSecureStorage? storage,
    String? baseUrl,
  }) : _storage = storage ?? const FlutterSecureStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        sendTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      LogInterceptor(
        requestBody: FlavorConfig.flavor == AppFlavor.dev,
        responseBody: FlavorConfig.flavor == AppFlavor.dev,
        error: true,
      ),
    ]);
  }

  late final Dio _dio;
  final FlutterSecureStorage _storage;

  Dio get dio => _dio;

  // ── Convenience methods ──────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.delete<T>(path, data: data, options: options);
}

/// Interceptor that attaches the bearer token from secure storage.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 → clear token and let the router redirect to login
    if (err.response?.statusCode == 401) {
      _storage.delete(key: AppConstants.keyAuthToken);
    }
    handler.next(err);
  }
}

/// Converts a Dio error to a user-friendly message.
String dioErrorMessage(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return 'Connection timed out. Please check your internet.';
  }
  if (e.type == DioExceptionType.connectionError) {
    return 'No internet connection.';
  }

  final status = e.response?.statusCode;
  final data = e.response?.data;

  if (data is Map<String, dynamic>) {
    // Laravel validation errors
    if (data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      return errors.values
          .expand((v) => v is List ? v.cast<String>() : [v.toString()])
          .first;
    }
    if (data.containsKey('message')) {
      return data['message'] as String;
    }
  }

  return switch (status) {
    400 => 'Bad request.',
    401 => 'Session expired. Please log in again.',
    403 => 'You don\'t have permission to do that.',
    404 => 'Resource not found.',
    422 => 'Validation error.',
    429 => 'Too many requests. Please slow down.',
    500 => 'Server error. Please try again later.',
    _ => 'Something went wrong. Please try again.',
  };
}
