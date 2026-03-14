import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import '../storage/app_settings_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final settings = ref.watch(appSettingsProvider);
  final configuredBaseUrl = settings.apiBaseUrl.trim();
  final baseUrl = configuredBaseUrl.isNotEmpty
      ? configuredBaseUrl
      : AppConstants.defaultApiBaseUrl;

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? lang,
    String? deviceId,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: _buildHeaders(lang: lang, deviceId: deviceId),
        ),
      );
      return response.data;
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? lang,
    String? deviceId,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: _buildHeaders(lang: lang, deviceId: deviceId),
        ),
      );
      return response.data;
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? lang,
    String? deviceId,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: _buildHeaders(lang: lang, deviceId: deviceId),
        ),
      );
      return response.data;
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Map<String, String> _buildHeaders({String? lang, String? deviceId}) {
    final headers = <String, String>{};

    if (lang != null && lang.isNotEmpty) {
      headers['Accept-Language'] = lang;
    }

    if (deviceId != null && deviceId.isNotEmpty) {
      headers['X-Device-Id'] = deviceId;
    }

    return headers;
  }
}
