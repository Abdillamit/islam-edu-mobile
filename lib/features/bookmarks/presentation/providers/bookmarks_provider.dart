import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/app_settings_provider.dart';
import '../../data/bookmarks_repository.dart';
import '../../domain/models/bookmark_item_model.dart';

final bookmarksProvider =
    AsyncNotifierProvider<BookmarksNotifier, List<BookmarkItemModel>>(
      BookmarksNotifier.new,
    );

class BookmarksNotifier extends AsyncNotifier<List<BookmarkItemModel>> {
  BookmarksRepository get _repository => ref.read(bookmarksRepositoryProvider);

  @override
  Future<List<BookmarkItemModel>> build() async {
    final settings = ref.watch(appSettingsProvider);
    if (settings.isLoading || settings.deviceId.isEmpty) {
      return [];
    }

    return _repository.fetchBookmarks(
      lang: settings.locale.languageCode,
      deviceId: settings.deviceId,
    );
  }

  Future<void> refreshBookmarks() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> addBookmark(String lessonId) async {
    final settings = ref.read(appSettingsProvider);
    if (settings.deviceId.isEmpty) {
      return;
    }

    await _repository.addBookmark(
      lessonId: lessonId,
      deviceId: settings.deviceId,
    );

    await refreshBookmarks();
  }

  Future<void> removeBookmark(String lessonId) async {
    final settings = ref.read(appSettingsProvider);
    if (settings.deviceId.isEmpty) {
      return;
    }

    await _repository.removeBookmark(
      lessonId: lessonId,
      deviceId: settings.deviceId,
    );

    await refreshBookmarks();
  }

  bool isBookmarked(String lessonId) {
    return state.valueOrNull?.any(
          (bookmark) => bookmark.lessonId == lessonId,
        ) ??
        false;
  }
}
