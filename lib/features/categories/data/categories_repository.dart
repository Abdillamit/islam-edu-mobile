import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/category_model.dart';
import 'categories_service.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepository(ref.watch(categoriesServiceProvider));
});

class CategoriesRepository {
  const CategoriesRepository(this._service);

  final CategoriesService _service;

  Future<List<CategoryModel>> fetchCategories({required String lang}) async {
    final list = await _service.getCategories(lang: lang);

    return list
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .toList();
  }
}
