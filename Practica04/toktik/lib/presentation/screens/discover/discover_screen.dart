import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seasonalProvider = context.watch<SeasonalThemeProvider>();
    if (!seasonalProvider.isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return DefaultTabController(
      length: VideoFeed.values.length,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const TabBarView(
              children: [
                VideoScrollableView(feed: VideoFeed.discover),
                VideoScrollableView(feed: VideoFeed.forYou),
                VideoScrollableView(feed: VideoFeed.favorites),
              ],
            ),
            SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SeasonHeader(theme: seasonalProvider.activeTheme),
                  const TabBar(
                    tabs: [
                      Tab(text: 'Discover'),
                      Tab(text: 'For You'),
                      Tab(text: 'Favorites'),
                    ],
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            if (seasonalProvider.audioError != null)
              Positioned(
                top: MediaQuery.paddingOf(context).top + 124,
                left: 16,
                right: 16,
                child: Material(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      seasonalProvider.audioError!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SeasonHeader extends StatelessWidget {
  final SeasonalTheme theme;

  const _SeasonHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SeasonalThemeProvider>();
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.background.withValues(alpha: 0.95),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          if (theme.logoAsset != null)
            ClipOval(
              child: Image.asset(
                theme.logoAsset!,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(theme.icon, color: theme.primary),
              ),
            )
          else
            Icon(theme.icon, color: theme.primary, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'TokTik · ${theme.label}',
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: 'Probar fecha y temporada',
            onPressed: () => _chooseTestDate(context, provider),
            icon: Icon(Icons.calendar_month, color: theme.primary),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseTestDate(
    BuildContext context,
    SeasonalThemeProvider provider,
  ) async {
    final action = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Probar temporada'),
        content: Text(
          'Fecha activa: ${provider.effectiveDate.day}/'
          '${provider.effectiveDate.month}/${provider.effectiveDate.year}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Usar fecha del dispositivo'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Elegir fecha'),
          ),
        ],
      ),
    );
    if (!context.mounted || action == null) return;

    if (!action) {
      await _updateTestDate(context, provider, null);
      return;
    }

    final now = DateTime.now();
    final initialDate = provider.simulatedDate ?? now;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Elige una fecha para probar la temporada',
    );
    if (!context.mounted || selectedDate == null) return;
    await _updateTestDate(context, provider, selectedDate);
  }

  Future<void> _updateTestDate(
    BuildContext context,
    SeasonalThemeProvider provider,
    DateTime? date,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (date == null) {
        await provider.useDeviceDate();
      } else {
        await provider.setSimulatedDate(date);
      }
    } catch (error) {
      if (!messenger.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo guardar la fecha: $error')),
      );
    }

    if (!messenger.mounted || provider.audioError == null) return;
    messenger.showSnackBar(SnackBar(content: Text(provider.audioError!)));
  }
}
