import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService(ref.watch(apiClientProvider));
});

class ProgressService {
  const ProgressService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getSummary({
    required String lang,
    required String deviceId,
  }) async {
    final response = await _apiClient.get(
      '/progress/summary',
      queryParameters: {'lang': lang},
      lang: lang,
      deviceId: deviceId,
    );
    return (response as Map<String, dynamic>?) ?? const <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getCompleted({
    required String lang,
    required String deviceId,
    int page = 1,
    int limit = 200,
  }) async {
    final response = await _apiClient.get(
      '/progress/completed',
      queryParameters: {'lang': lang, 'page': page, 'limit': limit},
      lang: lang,
      deviceId: deviceId,
    );
    return (response as Map<String, dynamic>?) ?? const <String, dynamic>{};
  }

  Future<void> markCompleted({
    required String lessonId,
    required String deviceId,
  }) async {
    await _apiClient.post(
      '/progress/complete',
      deviceId: deviceId,
      data: {'lessonId': lessonId},
    );
  }
}
