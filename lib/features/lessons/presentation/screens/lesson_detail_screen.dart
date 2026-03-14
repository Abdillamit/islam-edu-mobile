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
import '../../domain/models/lesson_detail_model.dart';
import '../providers/lessons_providers.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  int _selectedVideoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lessonAsync = ref.watch(lessonDetailProvider(widget.lessonId));
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final isBookmarked =
        bookmarksAsync.valueOrNull?.any(
          (bookmark) => bookmark.lessonId == widget.lessonId,
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
                await bookmarksNotifier.removeBookmark(widget.lessonId);
                if (!context.mounted) {
                  return;
                }
                _showMessage(context, l10n.bookmarkRemoved);
              } else {
                await bookmarksNotifier.addBookmark(widget.lessonId);
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

          final hasVideos = lesson.videoResources.isNotEmpty;
          final safeVideoIndex = hasVideos
              ? _selectedVideoIndex.clamp(0, lesson.videoResources.length - 1)
              : 0;
          final selectedVideo = hasVideos
              ? lesson.videoResources[safeVideoIndex]
              : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _AnimatedSection(
                index: 0,
                child: _buildIntroCard(context, lesson),
              ),
              const SizedBox(height: 14),
              _AnimatedSection(
                index: 1,
                child: OutlinedButton.icon(
                  onPressed: () => _playAudio(context, lesson.audioUrl),
                  icon: const Icon(Icons.volume_up_outlined),
                  label: Text(l10n.playAudio),
                ),
              ),
              if (hasVideos && selectedVideo != null) ...[
                const SizedBox(height: 18),
                _AnimatedSection(
                  index: 2,
                  child: _buildVideoCard(
                    context,
                    selectedVideoUrl: selectedVideo.url,
                    selectedVideoIndex: safeVideoIndex,
                    totalVideos: lesson.videoResources.length,
                  ),
                ),
                if (lesson.videoResources.length > 1) ...[
                  const SizedBox(height: 10),
                  _AnimatedSection(
                    index: 3,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: lesson.videoResources.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        return ChoiceChip(
                          label: Text('${l10n.videoLabel} ${index + 1}'),
                          selected: safeVideoIndex == index,
                          onSelected: (_) {
                            setState(() {
                              _selectedVideoIndex = index;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 18),
              _AnimatedSection(
                index: 4,
                child: Text(
                  l10n.lessonSteps,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              ...lesson.steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AnimatedSection(
                    index: 5 + index,
                    child: _buildStepCard(context, step),
                  ),
                );
              }),
              if (lesson.references.isNotEmpty) ...[
                const SizedBox(height: 12),
                _AnimatedSection(
                  index: 40,
                  child: Text(
                    l10n.verifiedSources,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                ...lesson.references.map((reference) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AnimatedSection(
                      index: 41 + reference.sortOrder,
                      child: _buildReferenceCard(context, reference),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 14),
              _AnimatedSection(
                index: 60,
                child: PrimaryButton(
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
              ),
            ],
          );
        },
        loading: () => const AppLoadingView(),
        error: (_, __) => AppErrorView(
          message: l10n.lessonNotFound,
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(lessonDetailProvider(widget.lessonId)),
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context, LessonDetailModel lesson) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF4EF), Color(0xFFF4EAD9)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lesson.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(lesson.shortDescription, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text(lesson.description),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context, {
    required String selectedVideoUrl,
    required int selectedVideoIndex,
    required int totalVideos,
  }) {
    final l10n = context.l10n;
    final videoId = _extractYoutubeId(selectedVideoUrl);
    final thumbnailUrl = videoId != null
        ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
        : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: InkWell(
                onTap: () => _openVideo(context, selectedVideoUrl),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbnailUrl != null)
                      Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildVideoFallback(),
                      )
                    else
                      _buildVideoFallback(),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x33000000), Color(0x88000000)],
                        ),
                      ),
                    ),
                    const Center(child: _AnimatedPlayButton()),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 10,
                      child: Text(
                        '${l10n.videoLabel} ${selectedVideoIndex + 1} / $totalVideos',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedVideoUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () => _openVideo(context, selectedVideoUrl),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.openVideo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoFallback() {
    return Container(
      color: const Color(0xFFB8CDC4),
      alignment: Alignment.center,
      child: const Icon(Icons.ondemand_video, size: 42, color: Colors.white),
    );
  }

  Widget _buildStepCard(BuildContext context, LessonStepModel step) {
    final number = step.sortOrder + 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFD3EADF),
            foregroundColor: const Color(0xFF155A49),
            child: Text('$number'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceCard(BuildContext context, LessonReferenceModel reference) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openExternalUrl(
          context,
          reference.url,
          fallbackMessage: context.l10n.sourceOpenError,
          preferInApp: true,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE8F4EE),
                child: Icon(Icons.verified_outlined, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reference.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reference.sourceName,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  String? _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }

    if (uri.host.contains('youtu.be')) {
      if (uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      }
    }

    final queryVideoId = uri.queryParameters['v'];
    if (queryVideoId != null && queryVideoId.isNotEmpty) {
      return queryVideoId;
    }

    final embedIndex = uri.pathSegments.indexOf('embed');
    if (embedIndex != -1 && uri.pathSegments.length > embedIndex + 1) {
      return uri.pathSegments[embedIndex + 1];
    }

    return null;
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

  Future<void> _openVideo(BuildContext context, String videoUrl) async {
    await _openExternalUrl(
      context,
      videoUrl,
      fallbackMessage: context.l10n.noVideoAvailable,
      preferInApp: true,
    );
  }

  Future<void> _openExternalUrl(
    BuildContext context,
    String url, {
    required String fallbackMessage,
    bool preferInApp = false,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showMessage(context, fallbackMessage);
      return;
    }

    var opened = await launchUrl(
      uri,
      mode: preferInApp
          ? LaunchMode.inAppBrowserView
          : LaunchMode.externalApplication,
    );

    if (!opened && preferInApp) {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

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

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 280 + (index * 35).clamp(0, 520));

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, innerChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: innerChild,
          ),
        );
      },
      child: child,
    );
  }
}

class _AnimatedPlayButton extends StatelessWidget {
  const _AnimatedPlayButton();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return Container(
          width: 68 * value,
          height: 68 * value,
          decoration: BoxDecoration(
            color: const Color(0xE6FFFFFF),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(Icons.play_arrow_rounded, size: 40),
        );
      },
    );
  }
}
