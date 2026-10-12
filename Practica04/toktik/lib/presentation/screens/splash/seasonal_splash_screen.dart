import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';

class SeasonalSplashScreen extends StatefulWidget {
  const SeasonalSplashScreen({super.key});

  @override
  State<SeasonalSplashScreen> createState() => _SeasonalSplashScreenState();
}

class _SeasonalSplashScreenState extends State<SeasonalSplashScreen>
    with SingleTickerProviderStateMixin {
  static const _displayDuration = Duration(seconds: 5);

  late final AnimationController _logoAnimation;
  Timer? _navigationTimer;
  bool _isReady = false;
  bool _isOpeningApp = false;
  String? _startupError;

  @override
  void initState() {
    super.initState();
    _logoAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.94,
      upperBound: 1.04,
    )..repeat(reverse: true);
    unawaited(_prepareSplash());
  }

  Future<void> _prepareSplash() async {
    final themeProvider = context.read<SeasonalThemeProvider>();
    try {
      await themeProvider.initialize();
      if (!mounted) return;
      setState(() {
        _isReady = true;
        _startupError = null;
      });
      if (themeProvider.soundsEnabled) {
        unawaited(themeProvider.playThemeMusic());
      }
      _navigationTimer?.cancel();
      _navigationTimer = Timer(_displayDuration, _openApp);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isReady = true;
        _startupError = 'No se pudieron cargar los ajustes: $error';
      });
    }
  }

  Future<void> _toggleMusic() async {
    final provider = context.read<SeasonalThemeProvider>();
    if (provider.isThemeMusicPlaying) {
      await provider.setSoundsEnabled(false);
      return;
    }
    if (!provider.soundsEnabled) await provider.setSoundsEnabled(true);
    await provider.playThemeMusic();
  }

  Future<void> _openApp() async {
    if (!mounted || _isOpeningApp) return;
    _isOpeningApp = true;
    _navigationTimer?.cancel();
    await context.read<SeasonalThemeProvider>().stopThemeMusic();
    if (!mounted) return;
    await Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) =>
            const DiscoverScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _logoAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<SeasonalThemeProvider>();
    final season = theme.currentTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.32),
              Theme.of(context).scaffoldBackgroundColor,
              colors.secondary.withValues(alpha: 0.24),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Container(
                      width: 148,
                      height: 148,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.16),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.7),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.24),
                            blurRadius: 42,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        _seasonIcon(season),
                        size: 76,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    'TokTik',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    season.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    season.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 42),
                  if (!_isReady)
                    const CircularProgressIndicator()
                  else if (_startupError != null)
                    Text(
                      _startupError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.error),
                    )
                  else ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text('Preparando tu experiencia...'),
                  ],
                  if (theme.soundError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      theme.soundError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.error),
                    ),
                  ],
                  const SizedBox(height: 28),
                  OutlinedButton.icon(
                    onPressed: _isReady ? _toggleMusic : null,
                    icon: Icon(
                      theme.isThemeMusicPlaying
                          ? Icons.music_off
                          : Icons.music_note,
                    ),
                    label: Text(
                      theme.isThemeMusicPlaying
                          ? 'Desactivar música'
                          : 'Activar música',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _isReady ? _openApp : null,
                    child: const Text('Entrar ahora'),
                  ),
                  if (_startupError != null)
                    TextButton(
                      onPressed: () => unawaited(_prepareSplash()),
                      child: const Text('Reintentar'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _seasonIcon(SeasonTheme season) => switch (season) {
    SeasonTheme.normal => Icons.play_circle_fill,
    SeasonTheme.halloween => Icons.nightlight_round,
    SeasonTheme.christmas => Icons.ac_unit,
    SeasonTheme.valentines => Icons.favorite,
  };
}
