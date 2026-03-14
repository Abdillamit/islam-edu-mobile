import 'package:flutter/material.dart';
import '../../features/progress/domain/models/progress_summary_model.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({
    super.key,
    required this.summary,
    required this.title,
  });

  final ProgressSummaryModel summary;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: summary.totalLessons == 0
                  ? 0
                  : summary.completedLessons / summary.totalLessons,
              minHeight: 10,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(height: 10),
            Text(
              '${summary.completedLessons}/${summary.totalLessons} • ${summary.completionPercent}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
