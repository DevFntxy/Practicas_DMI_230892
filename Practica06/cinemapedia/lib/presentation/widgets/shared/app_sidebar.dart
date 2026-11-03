import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia/presentation/screens/settings/language_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Row(
                children: [
                  Image.asset(
                    'assets/fanso-cinemapedia.png',
                    width: 76,
                    height: 76,
                    fit: BoxFit.contain,
                    semanticLabel: strings.appName,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      strings.appName,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: colors.outlineVariant),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: Text(strings.home),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.goNamed(HomeScreen.name);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: colors.outlineVariant),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: ListTile(
                leading: Icon(Icons.settings_outlined, color: colors.primary),
                title: Text(strings.settings),
                subtitle: Text(strings.language),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.pushNamed(LanguageSettingsScreen.name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
