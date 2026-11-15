import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Dio HTTP client configured with auth interceptor and timeout.
class ApiClient {
  ApiClient({FlutterSecureStorage? storage, String? baseUrl})
    : _storage = storage ?? const FlutterSecureStorage() {
    const environmentBaseUrl = String.fromEnvironment('API_BASE_URL');
    _dio = Dio(
      BaseOptions(
        baseUrl:
            baseUrl ??
            (environmentBaseUrl.isNotEmpty
                ? environmentBaseUrl
                : FlavorConfig.apiBaseUrl),
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
  }) => _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response<T>> put<T>(String path, {dynamic data, Options? options}) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> patch<T>(String path, {dynamic data, Options? options}) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) => _dio.delete<T>(path, data: data, options: options);

  Future<bool> warmUp({
    int attempts = AppConstants.warmUpMaxAttempts,
    Duration delay = const Duration(seconds: AppConstants.warmUpDelaySeconds),
  }) async {
    final baseUrl = _dio.options.baseUrl;
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    const apiV1Suffix = '/api/v1';
    final origin = normalizedBase.endsWith(apiV1Suffix)
        ? normalizedBase.substring(
            0,
            normalizedBase.length - apiV1Suffix.length,
          )
        : normalizedBase;
    final healthUrl = '$origin/up';

    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        await _dio.getUri<void>(
          Uri.parse(healthUrl),
          options: Options(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: Duration(
              seconds: AppConstants.warmUpReceiveTimeoutSeconds,
            ),
          ),
        );
        return true;
      } on DioException {
        if (attempt < attempts - 1) {
          await Future<void>.delayed(delay);
        }
      }
    }
    return false;
  }
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
  // ── Network / transport errors ───────────────────────────────────
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return 'The connection is taking too long. Please try again.';
  }
  if (e.type == DioExceptionType.connectionError) {
    return 'Unable to connect to the server. Please check your internet connection.';
  }

  // ── HTTP status errors ───────────────────────────────────────────
  final status = e.response?.statusCode;
  final data = e.response?.data;

  if (data is Map<String, dynamic>) {
    // Laravel validation errors (422)
    if (data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      final first = errors.values.firstOrNull;
      if (first is List && first.isNotEmpty) return first.first.toString();
      return errors.values
          .expand((v) => v is List ? v.cast<String>() : [v.toString()])
          .first;
    }
    // Backend message field — but do not forward raw 401 messages
    final backendMsg = data['message'] as String?;
    if (backendMsg != null && backendMsg.isNotEmpty && status != 401) {
      return backendMsg;
    }
  }

  return switch (status) {
    400 => 'Bad request. Please check your input.',
    401 => 'Incorrect email or password. Please try again.',
    403 => 'Please verify your email address before logging in.',
    404 => 'No account found with this email address.',
    422 => 'Validation error. Please check your input.',
    429 => 'Too many attempts. Please slow down and try again later.',
    500 || 502 || 503 || 504 =>
      'Our server is temporarily unavailable. Please try again in a moment.',
    _ => 'Something went wrong. Please try again.',
  };
}
