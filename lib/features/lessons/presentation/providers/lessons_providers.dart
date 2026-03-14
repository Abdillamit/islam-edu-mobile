import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/paginated_list.dart';
import '../../../../core/storage/app_settings_provider.dart';
import '../../data/lessons_repository.dart';
import '../../domain/models/lesson_detail_model.dart';
import '../../domain/models/lesson_summary_model.dart';

typedef LessonListArgs = ({String categoryId, String query});

final featuredLessonsProvider = FutureProvider<List<LessonSummaryModel>>((
  ref,
) async {
  final settings = ref.watch(appSettingsProvider);
  if (settings.isLoading) {
    return [];
  }

  final repository = ref.watch(lessonsRepositoryProvider);
  return repository.fetchFeaturedLessons(lang: settings.locale.languageCode);
});

final lessonListProvider =
    FutureProvider.family<PaginatedList<LessonSummaryModel>, LessonListArgs>((
      ref,
      args,
    ) async {
      final settings = ref.watch(appSettingsProvider);
      if (settings.isLoading) {
        return const PaginatedList(
          items: [],
          page: 1,
          limit: AppConstants.defaultPageSize,
          total: 0,
          totalPages: 0,
        );
      }

      final repository = ref.watch(lessonsRepositoryProvider);
      final query = args.query.trim();

      if (query.isNotEmpty) {
        return repository.searchLessons(
          lang: settings.locale.languageCode,
          query: query,
          categoryId: args.categoryId,
          limit: AppConstants.defaultPageSize,
        );
      }

      return repository.fetchLessons(
        lang: settings.locale.languageCode,
        categoryId: args.categoryId,
        limit: AppConstants.defaultPageSize,
      );
    });

final lessonDetailProvider = FutureProvider.family<LessonDetailModel, String>((
  ref,
  lessonId,
) async {
  final settings = ref.watch(appSettingsProvider);
  final repository = ref.watch(lessonsRepositoryProvider);

  return repository.fetchLessonDetail(
    lessonId: lessonId,
    lang: settings.locale.languageCode,
  );
});
