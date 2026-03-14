import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_service.dart';

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsState>((ref) {
      final storage = ref.watch(localStorageServiceProvider);
      return AppSettingsNotifier(storage);
    });

class AppSettingsState {
  const AppSettingsState({
    required this.isLoading,
    required this.locale,
    required this.onboardingCompleted,
    required this.deviceId,
    required this.apiBaseUrl,
  });

  final bool isLoading;
  final Locale locale;
  final bool onboardingCompleted;
  final String deviceId;
  final String apiBaseUrl;

  AppSettingsState copyWith({
    bool? isLoading,
    Locale? locale,
    bool? onboardingCompleted,
    String? deviceId,
    String? apiBaseUrl,
  }) {
    return AppSettingsState(
      isLoading: isLoading ?? this.isLoading,
      locale: locale ?? this.locale,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      deviceId: deviceId ?? this.deviceId,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettingsState> {
  AppSettingsNotifier(this._storage)
    : super(
        const AppSettingsState(
          isLoading: true,
          locale: Locale('ru'),
          onboardingCompleted: false,
          deviceId: '',
          apiBaseUrl: '',
        ),
      ) {
    _initialize();
  }

  final LocalStorageService _storage;

  Future<void> _initialize() async {
    final languageCode = await _storage.getLanguageCode();
    final onboardingCompleted = await _storage.isOnboardingCompleted();
    final deviceId = await _storage.getOrCreateDeviceId();
    final apiBaseUrl = await _storage.getApiBaseUrl();

    state = state.copyWith(
      isLoading: false,
      locale: Locale(languageCode),
      onboardingCompleted: onboardingCompleted,
      deviceId: deviceId,
      apiBaseUrl: apiBaseUrl,
    );
  }

  Future<void> setLanguageCode(String languageCode) async {
    await _storage.setLanguageCode(languageCode);
    state = state.copyWith(locale: Locale(languageCode));
  }

  Future<void> completeOnboarding() async {
    await _storage.setOnboardingCompleted();
    state = state.copyWith(onboardingCompleted: true);
  }

  Future<bool> setApiBaseUrl(String input) async {
    final normalizedInput = input.trim();
    if (normalizedInput.isEmpty) {
      await _storage.setApiBaseUrl('');
      state = state.copyWith(apiBaseUrl: '');
      return true;
    }

    final parsed = Uri.tryParse(normalizedInput);
    if (parsed == null ||
        parsed.host.isEmpty ||
        (parsed.scheme != 'http' && parsed.scheme != 'https')) {
      return false;
    }

    final sanitized = parsed
        .replace(
          queryParameters: parsed.queryParameters.isEmpty
              ? null
              : parsed.queryParameters,
        )
        .toString()
        .replaceFirst(RegExp(r'\/+$'), '');
    await _storage.setApiBaseUrl(sanitized);
    state = state.copyWith(apiBaseUrl: sanitized);
    return true;
  }
}
