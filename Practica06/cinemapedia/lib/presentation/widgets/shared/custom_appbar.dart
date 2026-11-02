import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final strings = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset(
                'assets/fanso-cinemapedia.png',
                width: 38,
                height: 38,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(strings.appName, style: titleStyle),
      
              const Spacer(),
      
              IconButton(
                tooltip: strings.settings,
                onPressed: () => context.pushNamed(LanguageSettingsScreen.name),
                icon: const Icon(Icons.settings_outlined),
              ),
              IconButton(
                tooltip: strings.search,
                onPressed: () {},
                icon: Icon(Icons.search, color: colors.primary),
              ),
            ],
          ),
        ),
      )
    );
  }
}