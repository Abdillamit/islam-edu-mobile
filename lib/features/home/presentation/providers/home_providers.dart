import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/domain/models/category_model.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../lessons/domain/models/lesson_summary_model.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

final homeCategoriesPreviewProvider = FutureProvider<List<CategoryModel>>((
  ref,
) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories.take(4).toList();
});

final continueLearningProvider = FutureProvider<LessonSummaryModel?>((
  ref,
) async {
  final summary = await ref.watch(progressSummaryProvider.future);
  return summary.nextLesson;
});
