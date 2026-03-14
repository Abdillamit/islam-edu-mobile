import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/progress_summary_model.dart';
import 'progress_service.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(progressServiceProvider));
});

class ProgressRepository {
  const ProgressRepository(this._service);

  final ProgressService _service;

  Future<ProgressSummaryModel> fetchSummary({
    required String lang,
    required String deviceId,
  }) async {
    final json = await _service.getSummary(lang: lang, deviceId: deviceId);
    return ProgressSummaryModel.fromJson(json);
  }

  Future<Set<String>> fetchCompletedLessonIds({
    required String lang,
    required String deviceId,
  }) async {
    final json = await _service.getCompleted(lang: lang, deviceId: deviceId);
    final items = (json['items'] as List<dynamic>?) ?? [];

    return items
        .whereType<Map<String, dynamic>>()
        .map((item) => item['lessonId'] as String?)
        .whereType<String>()
        .toSet();
  }

  Future<void> markLessonCompleted({
    required String lessonId,
    required String deviceId,
  }) {
    return _service.markCompleted(lessonId: lessonId, deviceId: deviceId);
  }
}
