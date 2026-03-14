import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final bookmarksServiceProvider = Provider<BookmarksService>((ref) {
  return BookmarksService(ref.watch(apiClientProvider));
});

class BookmarksService {
  const BookmarksService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getBookmarks({
    required String lang,
    required String deviceId,
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _apiClient.get(
      '/bookmarks',
      queryParameters: {'lang': lang, 'page': page, 'limit': limit},
      lang: lang,
      deviceId: deviceId,
    );
    return (response as Map<String, dynamic>?) ?? const <String, dynamic>{};
  }

  Future<void> addBookmark({
    required String lessonId,
    required String deviceId,
  }) async {
    await _apiClient.post(
      '/bookmarks',
      deviceId: deviceId,
      data: {'lessonId': lessonId},
    );
  }

  Future<void> removeBookmark({
    required String lessonId,
    required String deviceId,
  }) async {
    await _apiClient.delete('/bookmarks/$lessonId', deviceId: deviceId);
  }
}
