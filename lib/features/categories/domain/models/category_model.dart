class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.iconName,
  });

  final String id;
  final String slug;
  final String title;
  final String? description;
  final String? iconName;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      iconName: json['iconName'] as String?,
    );
  }
}
