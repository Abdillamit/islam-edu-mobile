import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/bookmark_item_model.dart';
import 'bookmarks_service.dart';

final bookmarksRepositoryProvider = Provider<BookmarksRepository>((ref) {
  return BookmarksRepository(ref.watch(bookmarksServiceProvider));
});

class BookmarksRepository {
  const BookmarksRepository(this._service);

  final BookmarksService _service;

  Future<List<BookmarkItemModel>> fetchBookmarks({
    required String lang,
    required String deviceId,
  }) async {
    final json = await _service.getBookmarks(lang: lang, deviceId: deviceId);
    final items = (json['items'] as List<dynamic>?) ?? [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(BookmarkItemModel.fromJson)
        .toList();
  }

  Future<void> addBookmark({
    required String lessonId,
    required String deviceId,
  }) {
    return _service.addBookmark(lessonId: lessonId, deviceId: deviceId);
  }

  Future<void> removeBookmark({
    required String lessonId,
    required String deviceId,
  }) {
    return _service.removeBookmark(lessonId: lessonId, deviceId: deviceId);
  }
}
