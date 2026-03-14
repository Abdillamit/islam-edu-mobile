import '../../../lessons/domain/models/lesson_summary_model.dart';

class ProgressSummaryModel {
  const ProgressSummaryModel({
    required this.totalLessons,
    required this.completedLessons,
    required this.completionPercent,
    required this.nextLesson,
  });

  final int totalLessons;
  final int completedLessons;
  final int completionPercent;
  final LessonSummaryModel? nextLesson;

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    final nextLessonJson = json['nextLesson'];

    return ProgressSummaryModel(
      totalLessons: json['totalLessons'] as int? ?? 0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      completionPercent: json['completionPercent'] as int? ?? 0,
      nextLesson: nextLessonJson is Map<String, dynamic>
          ? LessonSummaryModel.fromJson(nextLessonJson)
          : null,
    );
  }
}
