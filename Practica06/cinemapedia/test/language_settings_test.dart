import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:cinemapedia/presentation/screens/settings/language_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('language setting updates the app language', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) => MaterialApp(
            locale: ref.watch(languageProvider),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const LanguageSettingsScreen(),
          ),
        ),
      ),
    );

    expect(find.text('Configuración'), findsOneWidget);
    expect(find.text('🇲🇽'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-en-US')));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Choose the language for the app'), findsOneWidget);
    expect(find.text('🇺🇸'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-de-DE')));
    await tester.pumpAndSettle();

    expect(find.text('Einstellungen'), findsOneWidget);
    expect(find.text('Wähle die Sprache der App'), findsOneWidget);
    expect(find.text('🇩🇪'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-ko-KR')));
    await tester.pumpAndSettle();

    expect(find.text('설정'), findsOneWidget);
    expect(find.text('앱에서 사용할 언어를 선택하세요'), findsOneWidget);
    expect(find.text('🇰🇷'), findsOneWidget);
  });
}
