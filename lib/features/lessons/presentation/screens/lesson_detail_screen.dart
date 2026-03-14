import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../bookmarks/presentation/providers/bookmarks_provider.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../providers/lessons_providers.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lessonAsync = ref.watch(lessonDetailProvider(lessonId));
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final isBookmarked =
        bookmarksAsync.valueOrNull?.any(
          (bookmark) => bookmark.lessonId == lessonId,
        ) ??
        false;
    final completedIdsAsync = ref.watch(completedLessonIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
              if (isBookmarked) {
                await bookmarksNotifier.removeBookmark(lessonId);
                if (!context.mounted) {
                  return;
                }
                _showMessage(context, l10n.bookmarkRemoved);
              } else {
                await bookmarksNotifier.addBookmark(lessonId);
                if (!context.mounted) {
                  return;
                }
                _showMessage(context, l10n.bookmarkAdded);
              }
            },
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
          ),
        ],
      ),
      body: lessonAsync.when(
        data: (lesson) {
          final completedIds = completedIdsAsync.valueOrNull ?? <String>{};
          final isCompleted = completedIds.contains(lesson.id);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            children: [
              Text(
                lesson.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                lesson.shortDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (lesson.imageUrl != null) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    lesson.imageUrl!,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Text(lesson.description),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _playAudio(context, lesson.audioUrl),
                      icon: const Icon(Icons.volume_up_outlined),
                      label: Text(l10n.playAudio),
                    ),
                  ),
                ],
              ),
              if (lesson.videoResources.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  l10n.lessonVideos,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...lesson.videoResources.asMap().entries.map((entry) {
                  final index = entry.key;
                  final video = entry.value;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_outline),
                      title: Text('${l10n.videoLabel} ${index + 1}'),
                      subtitle: Text(video.url),
                      onTap: () => _openExternalUrl(
                        context,
                        video.url,
                        fallbackMessage: l10n.noVideoAvailable,
                      ),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 18),
              Text(
                l10n.lessonSteps,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...lesson.steps.map(
                (step) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${step.sortOrder + 1}')),
                    title: Text(step.content),
                  ),
                ),
              ),
              if (lesson.references.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  l10n.verifiedSources,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...lesson.references.map(
                  (reference) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.verified_outlined),
                      title: Text(reference.title),
                      subtitle: Text(reference.sourceName),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _openExternalUrl(
                        context,
                        reference.url,
                        fallbackMessage: l10n.sourceOpenError,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              PrimaryButton(
                label: isCompleted ? l10n.completed : l10n.markCompleted,
                onPressed: isCompleted
                    ? null
                    : () async {
                        await ref
                            .read(progressActionsProvider)
                            .markCompleted(lesson.id);
                        if (!context.mounted) {
                          return;
                        }
                        ref.invalidate(bookmarksProvider);
                        _showMessage(context, l10n.completeSuccess);
                      },
              ),
            ],
          );
        },
        loading: () => const AppLoadingView(),
        error: (_, __) => AppErrorView(
          message: l10n.lessonNotFound,
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(lessonDetailProvider(lessonId)),
        ),
      ),
    );
  }

  Future<void> _playAudio(BuildContext context, String? audioUrl) async {
    final l10n = context.l10n;
    if (audioUrl == null || audioUrl.isEmpty) {
      _showMessage(context, l10n.noAudioAvailable);
      return;
    }

    await _openExternalUrl(
      context,
      audioUrl,
      fallbackMessage: l10n.noAudioAvailable,
    );
  }

  Future<void> _openExternalUrl(
    BuildContext context,
    String url, {
    required String fallbackMessage,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showMessage(context, fallbackMessage);
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showMessage(context, fallbackMessage);
    }
  }

  void _showMessage(BuildContext context, String message) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
