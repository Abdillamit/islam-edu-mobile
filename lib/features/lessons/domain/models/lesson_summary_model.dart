class LessonSummaryModel {
  const LessonSummaryModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.shortDescription,
    required this.categoryTitle,
    required this.isFeatured,
    this.imageUrl,
    this.audioUrl,
  });

  final String id;
  final String categoryId;
  final String title;
  final String shortDescription;
  final String categoryTitle;
  final bool isFeatured;
  final String? imageUrl;
  final String? audioUrl;

  factory LessonSummaryModel.fromJson(Map<String, dynamic> json) {
    return LessonSummaryModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      categoryTitle: json['categoryTitle'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }
}
