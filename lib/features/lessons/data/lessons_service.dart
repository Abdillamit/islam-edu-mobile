import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final lessonsServiceProvider = Provider<LessonsService>((ref) {
  return LessonsService(ref.watch(apiClientProvider));
});

class LessonsService {
  const LessonsService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getLessons({
    required String lang,
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/lessons',
      queryParameters: {
        'lang': lang,
        'categoryId': categoryId,
        'page': page,
        'limit': limit,
      },
      lang: lang,
    );

    return (response as Map<String, dynamic>?) ?? const <String, dynamic>{};
  }

  Future<Map<String, dynamic>> searchLessons({
    required String lang,
    required String query,
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/lessons/search',
      queryParameters: {
        'lang': lang,
        'q': query,
        'categoryId': categoryId,
        'page': page,
        'limit': limit,
      },
      lang: lang,
    );

    return (response as Map<String, dynamic>?) ?? const <String, dynamic>{};
  }

  Future<List<dynamic>> getFeaturedLessons({required String lang}) async {
    final response = await _apiClient.get(
      '/lessons/featured',
      queryParameters: {'lang': lang},
      lang: lang,
    );

    if (response is! List<dynamic>) {
      return [];
    }
    return response;
  }

  Future<Map<String, dynamic>> getLessonDetail({
    required String lessonId,
    required String lang,
  }) async {
    final response = await _apiClient.get(
      '/lessons/$lessonId',
      queryParameters: {'lang': lang},
      lang: lang,
    );

    return (response as Map<String, dynamic>?) ?? const <String, dynamic>{};
  }
}
