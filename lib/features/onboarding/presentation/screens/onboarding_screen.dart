import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/app_settings_provider.dart';
import '../../../../core/utils/context_l10n.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedLanguageCode = ref.watch(onboardingLanguageProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  l10n.welcomeTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 30),
                Text(
                  l10n.selectLanguage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _LanguageOptionCard(
                  isSelected: selectedLanguageCode == 'ky',
                  title: l10n.languageKyrgyz,
                  onTap: () {
                    ref.read(onboardingLanguageProvider.notifier).state = 'ky';
                  },
                ),
                const SizedBox(height: 10),
                _LanguageOptionCard(
                  isSelected: selectedLanguageCode == 'ru',
                  title: l10n.languageRussian,
                  onTap: () {
                    ref.read(onboardingLanguageProvider.notifier).state = 'ru';
                  },
                ),
                const Spacer(),
                PrimaryButton(
                  label: l10n.continueText,
                  onPressed: () async {
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setLanguageCode(selectedLanguageCode);
                    await ref
                        .read(appSettingsProvider.notifier)
                        .completeOnboarding();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  const _LanguageOptionCard({
    required this.isSelected,
    required this.title,
    required this.onTap,
  });

  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
