import 'package:flutter/material.dart';

class AppTheme {
  static const _background = Color(0xFF101115);
  static const _surface = Color(0xFF1A1B22);
  static const _pink = Color(0xFFF04D96);
  static const _blue = Color(0xFF55A9E8);

  ThemeData getTheme() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _pink,
          brightness: Brightness.dark,
        ).copyWith(
          primary: _pink,
          onPrimary: Colors.white,
          secondary: _blue,
          onSecondary: _background,
          surface: _background,
          surfaceContainer: _surface,
          outline: const Color(0xFF383A44),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surface,
        elevation: 0,
        selectedItemColor: _pink,
        unselectedItemColor: Color(0xFF92939D),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _pink, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _surface,
        selectedColor: _pink.withValues(alpha: 0.18),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _pink,
        linearTrackColor: _surface,
      ),
    );
  }
}
