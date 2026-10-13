import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadApp());
  }

  Future<void> _loadApp() async {
    final startedAt = DateTime.now();
    try {
      final seasonalProvider = context.read<SeasonalThemeProvider>();
      await seasonalProvider.initialize();
      if (!mounted) return;

      final remaining =
          const Duration(milliseconds: 1200) -
          DateTime.now().difference(startedAt);
      if (remaining > Duration.zero) await Future<void>.delayed(remaining);
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const DiscoverScreen()),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo iniciar TokTik: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<SeasonalThemeProvider>().activeTheme;
    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [theme.surface, theme.background],
                radius: 0.9,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SeasonLogo(theme: theme),
                    const SizedBox(height: 24),
                    Text(
                      'TokTik',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: theme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      theme.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 32),
                    if (_isLoading)
                      SizedBox(
                        width: 180,
                        child: LinearProgressIndicator(
                          color: theme.primary,
                          backgroundColor: theme.surface,
                        ),
                      )
                    else ...[
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _loadApp();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonLogo extends StatelessWidget {
  final SeasonalTheme theme;

  const _SeasonLogo({required this.theme});

  @override
  Widget build(BuildContext context) {
    final image = theme.logoAsset;
    if (image == null) {
      return _fallback();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Image.asset(
        image,
        width: 170,
        height: 170,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: theme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: theme.primary, width: 3),
      ),
      child: Icon(theme.icon, color: theme.primary, size: 88),
    );
  }
}
