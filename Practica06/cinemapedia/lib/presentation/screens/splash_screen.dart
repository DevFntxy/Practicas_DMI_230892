import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/screens/movies/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _exitController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _exitOpacity;
  bool _introReady = false;
  bool _dataReady = false;
  bool _exitStarted = false;
  bool _navigationScheduled = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    _exitOpacity = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOutCubic,
    );

    _logoController.forward().then((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 360));
      if (!mounted) return;
      _introReady = true;
      _maybeOpenHome();
    });
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _maybeOpenHome() {
    if (!_introReady || !_dataReady || _exitStarted) return;
    _exitStarted = true;
    _exitController.forward().then((_) {
      if (!mounted || _navigationScheduled) return;
      _navigationScheduled = true;
      context.goNamed(HomeScreen.name);
    });
  }

  void _openHomeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _dataReady = true;
      _maybeOpenHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(initialLoadingProvider, (previous, isLoading) {
      if (!isLoading) {
        _dataReady = true;
        _maybeOpenHome();
      }
    });

    if (!ref.watch(initialLoadingProvider) && !_dataReady) {
      _openHomeAfterBuild();
    }

    final strings = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: FadeTransition(
        key: const ValueKey('splash-exit-fade'),
        opacity: ReverseAnimation(_exitOpacity),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.2),
              radius: 1.1,
              colors: [
                colorScheme.primary.withValues(alpha: 0.2),
                colorScheme.surfaceContainer,
                colorScheme.surface,
              ],
            ),
          ),
          child: Center(
            child: FadeTransition(
              key: const ValueKey('splash-logo-fade'),
              opacity: _logoOpacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.18),
                          blurRadius: 42,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/fanso-cinemapedia.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      semanticLabel: strings.appName,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    strings.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 118,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(minHeight: 3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
