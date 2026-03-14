import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/category_card.dart';
import '../providers/categories_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key, required this.onOpenCategory});

  final ValueChanged<(String id, String title)> onOpenCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categoriesAsync = ref.watch(categoriesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(categoriesProvider);
      },
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return ListView(
              children: [AppEmptyView(message: l10n.emptyLessons)],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                category: category,
                onTap: () => onOpenCategory((category.id, category.title)),
              );
            },
          );
        },
        loading: () => const AppLoadingView(),
        error: (_, __) => AppErrorView(
          message: l10n.errorGeneric,
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(categoriesProvider),
        ),
      ),
    );
  }
}
