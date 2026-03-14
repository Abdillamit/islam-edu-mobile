import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/paginated_list.dart';
import '../domain/models/lesson_detail_model.dart';
import '../domain/models/lesson_summary_model.dart';
import 'lessons_service.dart';

final lessonsRepositoryProvider = Provider<LessonsRepository>((ref) {
  return LessonsRepository(ref.watch(lessonsServiceProvider));
});

class LessonsRepository {
  const LessonsRepository(this._service);

  final LessonsService _service;

  Future<PaginatedList<LessonSummaryModel>> fetchLessons({
    required String lang,
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final json = await _service.getLessons(
      lang: lang,
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
    return _parsePaginatedLessons(json);
  }

  Future<PaginatedList<LessonSummaryModel>> searchLessons({
    required String lang,
    required String query,
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final json = await _service.searchLessons(
      lang: lang,
      query: query,
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
    return _parsePaginatedLessons(json);
  }

  Future<List<LessonSummaryModel>> fetchFeaturedLessons({
    required String lang,
  }) async {
    final list = await _service.getFeaturedLessons(lang: lang);

    return list
        .whereType<Map<String, dynamic>>()
        .map(LessonSummaryModel.fromJson)
        .toList();
  }

  Future<LessonDetailModel> fetchLessonDetail({
    required String lessonId,
    required String lang,
  }) async {
    final json = await _service.getLessonDetail(lessonId: lessonId, lang: lang);
    return LessonDetailModel.fromJson(json);
  }

  PaginatedList<LessonSummaryModel> _parsePaginatedLessons(
    Map<String, dynamic> json,
  ) {
    final items = ((json['items'] as List<dynamic>?) ?? [])
        .whereType<Map<String, dynamic>>()
        .map(LessonSummaryModel.fromJson)
        .toList();

    return PaginatedList<LessonSummaryModel>(
      items: items,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
