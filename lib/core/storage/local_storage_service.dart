import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return const LocalStorageService();
});

class LocalStorageService {
  const LocalStorageService();

  static const _languageCodeKey = 'language_code';
  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _deviceIdKey = 'device_id';

  Future<String> getLanguageCode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_languageCodeKey) ?? 'ru';
  }

  Future<void> setLanguageCode(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageCodeKey, languageCode);
  }

  Future<bool> isOnboardingCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingCompletedKey, true);
  }

  Future<String> getOrCreateDeviceId() async {
    final preferences = await SharedPreferences.getInstance();
    final existing = preferences.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    const uuid = Uuid();
    final generated = uuid.v4();
    await preferences.setString(_deviceIdKey, generated);
    return generated;
  }
}
