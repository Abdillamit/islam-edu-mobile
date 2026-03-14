import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/app_settings_provider.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _apiBaseUrlController;
  bool _apiBaseUrlInitialized = false;

  @override
  void initState() {
    super.initState();
    _apiBaseUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _apiBaseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(appSettingsProvider);
    final statsAsync = ref.watch(profileStatsProvider);

    final effectiveApiBaseUrl = settings.apiBaseUrl.isNotEmpty
        ? settings.apiBaseUrl
        : AppConstants.defaultApiBaseUrl;

    if (!_apiBaseUrlInitialized) {
      _apiBaseUrlController.text = settings.apiBaseUrl;
      _apiBaseUrlInitialized = true;
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        Text(l10n.profileTab, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectedLanguage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: settings.locale.languageCode,
                  items: [
                    DropdownMenuItem(
                      value: 'ky',
                      child: Text(l10n.languageKyrgyz),
                    ),
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text(l10n.languageRussian),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == null) {
                      return;
                    }
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setLanguageCode(value);
                    ref.invalidate(profileStatsProvider);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.apiBaseUrlLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _apiBaseUrlController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(hintText: l10n.apiBaseUrlHint),
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.apiBaseUrlCurrent}: $effectiveApiBaseUrl',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.apiBaseUrlHelp,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: () async {
                      final success = await ref
                          .read(appSettingsProvider.notifier)
                          .setApiBaseUrl(_apiBaseUrlController.text);
                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? l10n.apiBaseUrlSaved
                                : l10n.apiBaseUrlInvalid,
                          ),
                        ),
                      );

                      if (success) {
                        ref.invalidate(profileStatsProvider);
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(l10n.apiBaseUrlSave),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        statsAsync.when(
          data: (stats) => Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileStats,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  _StatRow(
                    label: l10n.completedLessons,
                    value: stats.completedLessons.toString(),
                  ),
                  const SizedBox(height: 6),
                  _StatRow(
                    label: l10n.savedLessons,
                    value: stats.savedLessons.toString(),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const SizedBox(height: 100, child: AppLoadingView()),
          error: (_, __) => AppErrorView(message: l10n.errorGeneric),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutApp,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(l10n.aboutDescription),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            title: Text(l10n.feedbackSupport),
            subtitle: Text(l10n.supportPlaceholder),
            leading: const Icon(Icons.support_agent_outlined),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
