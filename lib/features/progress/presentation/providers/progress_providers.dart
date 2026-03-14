import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/app_settings_provider.dart';
import '../../data/progress_repository.dart';
import '../../domain/models/progress_summary_model.dart';

final progressSummaryProvider = FutureProvider<ProgressSummaryModel>((
  ref,
) async {
  final settings = ref.watch(appSettingsProvider);
  if (settings.isLoading || settings.deviceId.isEmpty) {
    return const ProgressSummaryModel(
      totalLessons: 0,
      completedLessons: 0,
      completionPercent: 0,
      nextLesson: null,
    );
  }

  final repository = ref.watch(progressRepositoryProvider);
  return repository.fetchSummary(
    lang: settings.locale.languageCode,
    deviceId: settings.deviceId,
  );
});

final completedLessonIdsProvider = FutureProvider<Set<String>>((ref) async {
  final settings = ref.watch(appSettingsProvider);
  if (settings.isLoading || settings.deviceId.isEmpty) {
    return <String>{};
  }

  final repository = ref.watch(progressRepositoryProvider);
  return repository.fetchCompletedLessonIds(
    lang: settings.locale.languageCode,
    deviceId: settings.deviceId,
  );
});

final progressActionsProvider = Provider<ProgressActions>((ref) {
  return ProgressActions(ref);
});

class ProgressActions {
  const ProgressActions(this._ref);

  final Ref _ref;

  Future<void> markCompleted(String lessonId) async {
    final settings = _ref.read(appSettingsProvider);
    if (settings.deviceId.isEmpty) {
      return;
    }

    final repository = _ref.read(progressRepositoryProvider);
    await repository.markLessonCompleted(
      lessonId: lessonId,
      deviceId: settings.deviceId,
    );

    _ref.invalidate(progressSummaryProvider);
    _ref.invalidate(completedLessonIdsProvider);
  }
}
