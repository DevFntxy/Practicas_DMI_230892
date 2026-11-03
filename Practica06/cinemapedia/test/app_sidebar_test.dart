import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/presentation/screens/settings/language_settings_screen.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sidebar settings opens the existing language settings screen', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            drawer: const AppSidebar(),
            body: Builder(
              builder: (context) => IconButton(
                tooltip: 'Open menu',
                onPressed: Scaffold.of(context).openDrawer,
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/settings/language',
          name: LanguageSettingsScreen.name,
          builder: (context, state) => const LanguageSettingsScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('es', 'MX'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.text('Configuración'), findsOneWidget);

    await tester.tap(find.text('Configuración'));
    await tester.pumpAndSettle();

    expect(find.text('Elige el idioma de la aplicación'), findsOneWidget);
    expect(find.byKey(const ValueKey('language-es-MX')), findsOneWidget);
  });
}
