import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/shared/catalog_search_button.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final strings = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  tooltip: MaterialLocalizations.of(context)
                      .openAppDrawerTooltip,
                  onPressed: Scaffold.of(context).openDrawer,
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
              Image.asset(
                'assets/fanso-cinemapedia.png',
                width: 38,
                height: 38,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(strings.appName, style: titleStyle),

              const Spacer(),

              const CatalogSearchButton(),
            ],
          ),
        ),
      ),
    );
  }
}
