import 'package:flutter/material.dart';
import 'package:toktik/config/theme/season_theme.dart';

class AppTheme {
  ThemeData getTheme(SeasonTheme season) {
    final (primary, secondary, background, fontFamily) = switch (season) {
      SeasonTheme.normal => (
        const Color(0xFF8C52FF),
        const Color(0xFF5A3E9B),
        const Color(0xFF111111),
        'Roboto',
      ),
      SeasonTheme.halloween => (
        const Color(0xFFFF7A18),
        const Color(0xFF8E44AD),
        const Color(0xFF170F1D),
        'monospace',
      ),
      SeasonTheme.christmas => (
        const Color(0xFF16A085),
        const Color(0xFFC0392B),
        const Color(0xFF0C1916),
        'serif',
      ),
      SeasonTheme.valentines => (
        const Color(0xFFFF5B8D),
        const Color(0xFFC2185B),
        const Color(0xFF1D1018),
        'serif',
      ),
    };

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        secondary: secondary,
        brightness: Brightness.dark,
      ),
      fontFamily: fontFamily,
    );
  }
}
