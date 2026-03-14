import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/app_settings_provider.dart';
import '../../data/categories_repository.dart';
import '../../domain/models/category_model.dart';

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final settings = ref.watch(appSettingsProvider);
  if (settings.isLoading) {
    return [];
  }

  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.fetchCategories(lang: settings.locale.languageCode);
});
