class LessonDetailModel {
  const LessonDetailModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.categoryTitle,
    required this.steps,
    required this.videoResources,
    required this.references,
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
  final List<LessonVideoResourceModel> videoResources;
  final List<LessonReferenceModel> references;
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
      videoResources: ((json['videoResources'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map(LessonVideoResourceModel.fromJson)
          .toList(),
      references: ((json['references'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map(LessonReferenceModel.fromJson)
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

class LessonVideoResourceModel {
  const LessonVideoResourceModel({required this.id, required this.url});

  final String id;
  final String url;

  factory LessonVideoResourceModel.fromJson(Map<String, dynamic> json) {
    return LessonVideoResourceModel(
      id: json['id'] as String,
      url: json['url'] as String? ?? '',
    );
  }
}

class LessonReferenceModel {
  const LessonReferenceModel({
    required this.id,
    required this.sourceName,
    required this.title,
    required this.url,
    required this.verificationNote,
    required this.sortOrder,
  });

  final String id;
  final String sourceName;
  final String title;
  final String url;
  final String verificationNote;
  final int sortOrder;

  factory LessonReferenceModel.fromJson(Map<String, dynamic> json) {
    return LessonReferenceModel(
      id: json['id'] as String,
      sourceName: json['sourceName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      verificationNote: json['verificationNote'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }
}
