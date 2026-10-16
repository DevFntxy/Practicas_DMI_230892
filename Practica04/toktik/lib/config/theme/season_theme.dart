import 'package:flutter/material.dart';

enum Season { normal, halloween, christmas, valentines }

class SeasonalTheme {
  final Season season;
  final String label;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final String fontFamily;
  final String? logoAsset;
  final IconData icon;

  const SeasonalTheme({
    required this.season,
    required this.label,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.fontFamily,
    required this.logoAsset,
    required this.icon,
  });

  factory SeasonalTheme.forDate(DateTime date) {
    if (date.month == 10) {
      return const SeasonalTheme(
        season: Season.halloween,
        label: 'Halloween',
        primary: Color(0xFFFF7B00),
        secondary: Color(0xFF9B5DE5),
        background: Color(0xFF140D1B),
        surface: Color(0xFF281735),
        fontFamily: 'Georgia',
        logoAsset: 'assets/logos/fanso_terror.png',
        icon: Icons.cruelty_free,
      );
    }
    if (date.month == 12) {
      return const SeasonalTheme(
        season: Season.christmas,
        label: 'Christmas',
        primary: Color(0xFFE53935),
        secondary: Color(0xFF43A047),
        background: Color(0xFF101A16),
        surface: Color(0xFF1B3026),
        fontFamily: 'serif',
        logoAsset: 'assets/logos/fanso_navidad.png',
        icon: Icons.ac_unit,
      );
    }
    if (date.month == 2 && date.day <= 14) {
      return const SeasonalTheme(
        season: Season.valentines,
        label: "Valentine's Day",
        primary: Color(0xFFE91E63),
        secondary: Color(0xFFFF80AB),
        background: Color(0xFF1D0D16),
        surface: Color(0xFF351728),
        fontFamily: 'cursive',
        logoAsset: null,
        icon: Icons.favorite,
      );
    }
    return const SeasonalTheme(
      season: Season.normal,
      label: 'Normal',
      primary: Color(0xFF6750A4),
      secondary: Color(0xFF03DAC6),
      background: Color(0xFF101010),
      surface: Color(0xFF202020),
      fontFamily: 'Roboto',
      logoAsset: 'assets/logos/fanso_normal.jpg',
      icon: Icons.play_circle_fill,
    );
  }
}
