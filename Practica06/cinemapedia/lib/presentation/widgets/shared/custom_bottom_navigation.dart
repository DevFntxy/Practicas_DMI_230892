import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) {
        final locations = ['/', '/categories', '/favorites'];
        context.go(locations[index]);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_max),
          label: strings.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.label_outline),
          label: strings.categories,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          label: strings.favorites,
        ),
      ],
    );
  }
}
