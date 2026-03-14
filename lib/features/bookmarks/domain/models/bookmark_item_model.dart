import '../../../lessons/domain/models/lesson_summary_model.dart';

class BookmarkItemModel {
  const BookmarkItemModel({
    required this.id,
    required this.lessonId,
    required this.createdAt,
    required this.lesson,
  });

  final String id;
  final String lessonId;
  final DateTime createdAt;
  final LessonSummaryModel lesson;

  factory BookmarkItemModel.fromJson(Map<String, dynamic> json) {
    return BookmarkItemModel(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lesson: LessonSummaryModel.fromJson(
        (json['lesson'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
      ),
    );
  }
}
