import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  static const name = 'language-settings-screen';

  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final selectedLocale = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            strings.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(strings.chooseLanguage),
          const SizedBox(height: 12),
          RadioGroup<Locale>(
            groupValue: selectedLocale,
            onChanged: (locale) {
              if (locale != null) {
                ref.read(languageProvider.notifier).state = locale;
              }
            },
            child: Column(
              children: [
                Card(
                  child: RadioListTile<Locale>(
                    key: const ValueKey('language-es-MX'),
                    value: const Locale('es', 'MX'),
                    secondary: const Text(
                      '🇲🇽',
                      style: TextStyle(fontSize: 28),
                    ),
                    title: Text(strings.spanish),
                    subtitle: Text(strings.mexico),
                  ),
                ),
                Card(
                  child: RadioListTile<Locale>(
                    key: const ValueKey('language-en-US'),
                    value: const Locale('en', 'US'),
                    secondary: const Text(
                      '🇺🇸',
                      style: TextStyle(fontSize: 28),
                    ),
                    title: Text(strings.english),
                    subtitle: Text(strings.unitedStates),
                  ),
                ),
                Card(
                  child: RadioListTile<Locale>(
                    key: const ValueKey('language-de-DE'),
                    value: const Locale('de', 'DE'),
                    secondary: const Text(
                      '🇩🇪',
                      style: TextStyle(fontSize: 28),
                    ),
                    title: Text(strings.german),
                    subtitle: Text(strings.germany),
                  ),
                ),
                Card(
                  child: RadioListTile<Locale>(
                    key: const ValueKey('language-ko-KR'),
                    value: const Locale('ko', 'KR'),
                    secondary: const Text(
                      '🇰🇷',
                      style: TextStyle(fontSize: 28),
                    ),
                    title: Text(strings.korean),
                    subtitle: Text(strings.southKorea),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
