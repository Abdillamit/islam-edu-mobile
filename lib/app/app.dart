import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islam_edu_mobile/l10n/app_localizations.dart';
import '../core/storage/app_settings_provider.dart';
import '../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import 'navigation/app_routes.dart';
import 'navigation/main_shell_screen.dart';
import 'theme/app_theme.dart';

class IslamEduApp extends ConsumerWidget {
  const IslamEduApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    if (settings.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (!settings.onboardingCompleted) {
      ref.read(onboardingLanguageProvider.notifier).state =
          settings.locale.languageCode;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Islam Education KG',
      theme: AppTheme.lightTheme(),
      locale: settings.locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ky'), Locale('ru')],
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: settings.onboardingCompleted
          ? const MainShellScreen()
          : const OnboardingScreen(),
    );
  }
}
