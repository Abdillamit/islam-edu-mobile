import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/category_card.dart';
import '../../../../shared/widgets/daily_useful_card.dart';
import '../../../../shared/widgets/lesson_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../lessons/presentation/providers/lessons_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    required this.onOpenCategory,
    required this.onOpenLesson,
  });

  final ValueChanged<(String id, String title)> onOpenCategory;
  final ValueChanged<String> onOpenLesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final previewCategoriesAsync = ref.watch(homeCategoriesPreviewProvider);
    final featuredLessonsAsync = ref.watch(featuredLessonsProvider);
    final continueLearningAsync = ref.watch(continueLearningProvider);
    final progressSummaryAsync = ref.watch(progressSummaryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(homeCategoriesPreviewProvider);
        ref.invalidate(featuredLessonsProvider);
        ref.invalidate(continueLearningProvider);
        ref.invalidate(progressSummaryProvider);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          Text(
            l10n.homeGreeting,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(l10n.homeGreetingSubtitle),
          const SizedBox(height: 18),
          SectionHeader(title: l10n.continueLearning),
          const SizedBox(height: 8),
          progressSummaryAsync.when(
            data: (summary) => Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  '${summary.completedLessons}/${summary.totalLessons} • ${summary.completionPercent}%',
                ),
              ),
            ),
            loading: () => const SizedBox(height: 80, child: AppLoadingView()),
            error: (_, __) => AppErrorView(message: l10n.errorGeneric),
          ),
          const SizedBox(height: 8),
          continueLearningAsync.when(
            data: (lesson) {
              if (lesson == null) {
                return AppEmptyView(message: l10n.noNextLesson);
              }
              return LessonCard(
                lesson: lesson,
                onTap: () => onOpenLesson(lesson.id),
              );
            },
            loading: () => const SizedBox(height: 110, child: AppLoadingView()),
            error: (_, __) => AppErrorView(message: l10n.errorGeneric),
          ),
          const SizedBox(height: 20),
          SectionHeader(title: l10n.featuredLessons),
          featuredLessonsAsync.when(
            data: (lessons) {
              if (lessons.isEmpty) {
                return AppEmptyView(message: l10n.emptyLessons);
              }

              return Column(
                children: lessons
                    .map(
                      (lesson) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: LessonCard(
                          lesson: lesson,
                          onTap: () => onOpenLesson(lesson.id),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const SizedBox(height: 110, child: AppLoadingView()),
            error: (_, __) => AppErrorView(
              message: l10n.errorGeneric,
              onRetry: () => ref.invalidate(featuredLessonsProvider),
              retryLabel: l10n.retry,
            ),
          ),
          const SizedBox(height: 10),
          SectionHeader(title: l10n.categoriesTitle),
          previewCategoriesAsync.when(
            data: (categories) {
              return Column(
                children: categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CategoryCard(
                          category: category,
                          onTap: () =>
                              onOpenCategory((category.id, category.title)),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const SizedBox(height: 80, child: AppLoadingView()),
            error: (_, __) => AppErrorView(
              message: l10n.errorGeneric,
              onRetry: () => ref.invalidate(homeCategoriesPreviewProvider),
              retryLabel: l10n.retry,
            ),
          ),
          const SizedBox(height: 14),
          DailyUsefulCard(
            title: l10n.dailyUsefulCardTitle,
            body: l10n.dailyUsefulCardBody,
          ),
        ],
      ),
    );
  }
}
