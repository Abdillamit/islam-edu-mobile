import 'package:flutter/material.dart';
import '../../features/lessons/domain/models/lesson_summary_model.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isCompleted = false,
    this.trailing,
  });

  final LessonSummaryModel lesson;
  final VoidCallback onTap;
  final bool isCompleted;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson.categoryTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              trailing ?? const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
