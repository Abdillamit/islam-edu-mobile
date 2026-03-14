import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/lesson_card.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key, required this.onOpenLesson});

  final ValueChanged<String> onOpenLesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final bookmarksNotifier = ref.read(bookmarksProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => bookmarksNotifier.refreshBookmarks(),
      child: bookmarksAsync.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return ListView(
              children: [AppEmptyView(message: l10n.emptyBookmarks)],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              return LessonCard(
                lesson: item.lesson,
                onTap: () => onOpenLesson(item.lesson.id),
                trailing: IconButton(
                  onPressed: () =>
                      bookmarksNotifier.removeBookmark(item.lessonId),
                  icon: const Icon(Icons.delete_outline),
                ),
              );
            },
          );
        },
        loading: () => const AppLoadingView(),
        error: (_, __) => AppErrorView(
          message: l10n.errorGeneric,
          retryLabel: l10n.retry,
          onRetry: () => bookmarksNotifier.refreshBookmarks(),
        ),
      ),
    );
  }
}
