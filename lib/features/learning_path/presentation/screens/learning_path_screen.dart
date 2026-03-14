import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/lesson_card.dart';
import '../../../../shared/widgets/progress_overview_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../lessons/domain/models/lesson_summary_model.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key, required this.onOpenLesson});

  final ValueChanged<String> onOpenLesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final progressSummaryAsync = ref.watch(progressSummaryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(progressSummaryProvider);
        ref.invalidate(completedLessonIdsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          SectionHeader(title: l10n.beginnerRoadmap),
          categoriesAsync.when(
            data: (categories) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map(
                    (category) => Chip(
                      label: Text(category.title),
                      avatar: const Icon(Icons.flag_outlined, size: 18),
                    ),
                  )
                  .toList(),
            ),
            loading: () => const SizedBox(height: 70, child: AppLoadingView()),
            error: (_, __) => AppErrorView(message: l10n.errorGeneric),
          ),
          const SizedBox(height: 16),
          progressSummaryAsync.when(
            data: (summary) =>
                ProgressOverviewCard(summary: summary, title: l10n.progress),
            loading: () => const SizedBox(height: 120, child: AppLoadingView()),
            error: (_, __) => AppErrorView(message: l10n.errorGeneric),
          ),
          const SizedBox(height: 16),
          SectionHeader(title: l10n.nextLesson),
          progressSummaryAsync.when(
            data: (summary) {
              if (summary.nextLesson == null) {
                return AppEmptyView(message: l10n.noNextLesson);
              }

              return LessonCard(
                lesson: summary.nextLesson ?? _emptyLesson(),
                onTap: () => onOpenLesson(summary.nextLesson!.id),
              );
            },
            loading: () => const SizedBox(height: 100, child: AppLoadingView()),
            error: (_, __) => AppErrorView(message: l10n.errorGeneric),
          ),
        ],
      ),
    );
  }

  LessonSummaryModel _emptyLesson() {
    return const LessonSummaryModel(
      id: '',
      categoryId: '',
      title: '',
      shortDescription: '',
      categoryTitle: '',
      isFeatured: false,
    );
  }
}
