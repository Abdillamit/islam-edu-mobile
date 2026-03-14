import 'dart:convert';
import 'dart:io';

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
  bool _isDetectingServer = false;

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
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isDetectingServer
                          ? null
                          : () => _autoDetectApiBaseUrl(),
                      icon: _isDetectingServer
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.radar_outlined),
                      label: Text(
                        _isDetectingServer
                            ? l10n.apiAutoDetecting
                            : l10n.apiAutoDetect,
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _isDetectingServer
                          ? null
                          : () => _saveApiBaseUrl(_apiBaseUrlController.text),
                      icon: const Icon(Icons.save_outlined),
                      label: Text(l10n.apiBaseUrlSave),
                    ),
                  ],
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

  Future<void> _saveApiBaseUrl(String value) async {
    final l10n = context.l10n;
    final success = await ref
        .read(appSettingsProvider.notifier)
        .setApiBaseUrl(value);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.apiBaseUrlSaved : l10n.apiBaseUrlInvalid),
      ),
    );

    if (success) {
      ref.invalidate(profileStatsProvider);
    }
  }

  Future<void> _autoDetectApiBaseUrl() async {
    final l10n = context.l10n;
    setState(() {
      _isDetectingServer = true;
    });

    final detected = await _findBackendInLocalNetwork();
    if (!mounted) {
      return;
    }

    setState(() {
      _isDetectingServer = false;
    });

    if (detected == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.apiAutoDetectFailure)));
      return;
    }

    _apiBaseUrlController.text = detected;
    await _saveApiBaseUrl(detected);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${l10n.apiAutoDetectSuccess}: $detected')),
    );
  }

  Future<String?> _findBackendInLocalNetwork() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );

    final privateAddresses = interfaces
        .expand((networkInterface) => networkInterface.addresses)
        .map((address) => address.address)
        .where(_isPrivateIpv4)
        .toList();

    if (privateAddresses.isEmpty) {
      return null;
    }

    for (final localIp in privateAddresses) {
      final parts = localIp.split('.');
      if (parts.length != 4) {
        continue;
      }

      final prefix = '${parts[0]}.${parts[1]}.${parts[2]}';
      final ownLast = int.tryParse(parts[3]);
      final candidateLastOctets = _orderedLastOctets(ownLast);

      for (var i = 0; i < candidateLastOctets.length; i += 24) {
        final batch = candidateLastOctets.skip(i).take(24).toList();
        final probeResults = await Future.wait(
          batch.map((last) async {
            final baseUrl = 'http://$prefix.$last:3000';
            final isHealthy = await _isHealthEndpointOk(baseUrl);
            return (baseUrl: baseUrl, ok: isHealthy);
          }),
        );

        for (final result in probeResults) {
          if (result.ok) {
            return result.baseUrl;
          }
        }
      }
    }

    return null;
  }

  List<int> _orderedLastOctets(int? ownLast) {
    final preferred = <int>[
      1,
      2,
      10,
      20,
      30,
      40,
      50,
      60,
      70,
      80,
      90,
      100,
      110,
      120,
      130,
      140,
      141,
      142,
      150,
      160,
      170,
      180,
      190,
      200,
      210,
      220,
      230,
      240,
      250,
      254,
    ];

    final all = <int>[for (var last = 1; last <= 254; last++) last];

    final ordered = <int>[...preferred, ...all];
    final unique = <int>{};

    for (final last in ordered) {
      if (ownLast != null && ownLast == last) {
        continue;
      }
      unique.add(last);
    }

    return unique.toList(growable: false);
  }

  Future<bool> _isHealthEndpointOk(String baseUrl) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(milliseconds: 350);

    try {
      final request = await client
          .getUrl(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(milliseconds: 700));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close().timeout(
        const Duration(milliseconds: 700),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(milliseconds: 700));
      return body.contains('"status":"ok"');
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  bool _isPrivateIpv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) {
      return false;
    }

    final octets = parts.map(int.tryParse).toList();
    if (octets.any((octet) => octet == null)) {
      return false;
    }

    final first = octets[0]!;
    final second = octets[1]!;

    if (first == 10) {
      return true;
    }

    if (first == 172 && second >= 16 && second <= 31) {
      return true;
    }

    if (first == 192 && second == 168) {
      return true;
    }

    return false;
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
