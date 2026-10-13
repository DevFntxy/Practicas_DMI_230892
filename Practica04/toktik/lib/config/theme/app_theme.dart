import 'package:flutter/material.dart';
import 'package:toktik/config/theme/season_theme.dart';

class AppTheme {
  final SeasonalTheme seasonalTheme;

  const AppTheme(this.seasonalTheme);

  ThemeData getTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seasonalTheme.primary,
      brightness: Brightness.dark,
      primary: seasonalTheme.primary,
      secondary: seasonalTheme.secondary,
      surface: seasonalTheme.surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: seasonalTheme.background,
      fontFamily: seasonalTheme.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: seasonalTheme.background,
        foregroundColor: Colors.white,
      ),
    );
  }
}
