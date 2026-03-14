import 'package:dio/dio.dart';

class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  factory AppException.fromDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;
    String message = 'Request failed.';

    if (responseData is Map<String, dynamic> &&
        responseData['message'] is String) {
      message = responseData['message'] as String;
    } else if (exception.message != null &&
        exception.message!.trim().isNotEmpty) {
      message = exception.message!;
    }

    return AppException(message: message, statusCode: statusCode);
  }

  @override
  String toString() =>
      'AppException(statusCode: $statusCode, message: $message)';
}
