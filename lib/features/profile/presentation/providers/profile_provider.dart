import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../bookmarks/presentation/providers/bookmarks_provider.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  final summary = await ref.watch(progressSummaryProvider.future);
  final bookmarks = await ref.watch(bookmarksProvider.future);

  return ProfileStats(
    completedLessons: summary.completedLessons,
    savedLessons: bookmarks.length,
  );
});

class ProfileStats {
  const ProfileStats({
    required this.completedLessons,
    required this.savedLessons,
  });

  final int completedLessons;
  final int savedLessons;
}
