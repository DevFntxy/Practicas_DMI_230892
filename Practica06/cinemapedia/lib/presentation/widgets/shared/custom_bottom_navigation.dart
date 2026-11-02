import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:flutter/material.dart';


class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return BottomNavigationBar(
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.home_max ),
          label: strings.home
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.label_outline ),
          label: strings.categories
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.favorite_outline ),
          label: strings.favorites
        ),
      ]
    );
  }
}