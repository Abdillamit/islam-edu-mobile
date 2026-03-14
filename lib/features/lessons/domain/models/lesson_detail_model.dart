class LessonDetailModel {
  const LessonDetailModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.categoryTitle,
    required this.steps,
    this.imageUrl,
    this.audioUrl,
  });

  final String id;
  final String categoryId;
  final String title;
  final String shortDescription;
  final String description;
  final String categoryTitle;
  final List<LessonStepModel> steps;
  final String? imageUrl;
  final String? audioUrl;

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryTitle: json['categoryTitle'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      steps: ((json['steps'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map(LessonStepModel.fromJson)
          .toList(),
    );
  }
}

class LessonStepModel {
  const LessonStepModel({
    required this.id,
    required this.sortOrder,
    required this.content,
  });

  final String id;
  final int sortOrder;
  final String content;

  factory LessonStepModel.fromJson(Map<String, dynamic> json) {
    return LessonStepModel(
      id: json['id'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      content: json['content'] as String? ?? '',
    );
  }
}
