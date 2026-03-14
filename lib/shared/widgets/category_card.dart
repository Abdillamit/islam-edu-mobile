import 'package:flutter/material.dart';
import '../../features/categories/domain/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(_mapIcon(category.iconName)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (category.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        category.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapIcon(String? iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'shower':
        return Icons.shower_outlined;
      case 'mosque':
        return Icons.mosque_outlined;
      case 'menu_book':
        return Icons.menu_book_outlined;
      case 'self_improvement':
        return Icons.self_improvement_outlined;
      case 'school':
        return Icons.school_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
