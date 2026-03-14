import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/app_search_field.dart';
import '../../../../shared/widgets/lesson_card.dart';
import '../../../lessons/presentation/providers/lessons_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

class LessonListScreen extends ConsumerStatefulWidget {
  const LessonListScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.onOpenLesson,
  });

  final String categoryId;
  final String categoryTitle;
  final ValueChanged<String> onOpenLesson;

  @override
  ConsumerState<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends ConsumerState<LessonListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lessonsAsync = ref.watch(
      lessonListProvider((categoryId: widget.categoryId, query: _searchQuery)),
    );
    final completedIdsAsync = ref.watch(completedLessonIdsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryTitle)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          children: [
            AppSearchField(
              hintText: l10n.searchHint,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: lessonsAsync.when(
                data: (paginated) {
                  final lessons = paginated.items;
                  if (lessons.isEmpty) {
                    return AppEmptyView(message: l10n.emptyLessons);
                  }

                  return completedIdsAsync.when(
                    data: (completedIds) {
                      return ListView.separated(
                        itemCount: lessons.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          final isCompleted = completedIds.contains(lesson.id);

                          return LessonCard(
                            lesson: lesson,
                            isCompleted: isCompleted,
                            onTap: () => widget.onOpenLesson(lesson.id),
                            trailing: isCompleted
                                ? Icon(
                                    Icons.check_circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : const Icon(Icons.chevron_right),
                          );
                        },
                      );
                    },
                    loading: () => const AppLoadingView(),
                    error: (_, __) => AppErrorView(message: l10n.errorGeneric),
                  );
                },
                loading: () => const AppLoadingView(),
                error: (_, __) => AppErrorView(
                  message: l10n.errorGeneric,
                  retryLabel: l10n.retry,
                  onRetry: () => ref.invalidate(
                    lessonListProvider((
                      categoryId: widget.categoryId,
                      query: _searchQuery,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
