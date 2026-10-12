import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final PageController _feedController = PageController();
  int _selectedFeed = 0;

  @override
  void dispose() {
    _feedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoverProvider = context.watch<DiscoverProvider>();
    final themeProvider = context.watch<SeasonalThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: discoverProvider.initialLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : discoverProvider.loadError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      discoverProvider.loadError!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: discoverProvider.loadNextPage,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                PageView(
                  controller: _feedController,
                  onPageChanged: (index) =>
                      setState(() => _selectedFeed = index),
                  children: [
                    _buildFeed(
                      discoverProvider.discoverVideos,
                      discoverProvider,
                      const ValueKey('discover'),
                    ),
                    _buildFeed(
                      discoverProvider.forYouVideos,
                      discoverProvider,
                      const ValueKey('for-you'),
                    ),
                    _buildFeed(
                      discoverProvider.favoritesVideos,
                      discoverProvider,
                      const ValueKey('favorites'),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 8,
                  left: 16,
                  right: 12,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _feedTitles[_selectedFeed],
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      PopupMenuButton<_ThemeChoice>(
                        tooltip: 'Tema de temporada',
                        onSelected: (choice) =>
                            unawaited(themeProvider.setTheme(choice.season)),
                        itemBuilder: (context) => _ThemeChoice.values
                            .map(
                              (choice) => PopupMenuItem(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(
                                      choice.icon,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(choice.label),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        child: Icon(
                          _seasonIcon(themeProvider.currentTheme),
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        tooltip: themeProvider.soundsEnabled
                            ? 'Desactivar sonidos'
                            : 'Activar sonidos',
                        onPressed: () => unawaited(
                          themeProvider.setSoundsEnabled(
                            !themeProvider.soundsEnabled,
                          ),
                        ),
                        icon: Icon(
                          themeProvider.soundsEnabled
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (discoverProvider.actionError != null ||
                    themeProvider.soundError != null)
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 64,
                    left: 16,
                    right: 16,
                    child: Material(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          discoverProvider.actionError ??
                              themeProvider.soundError!,
                          style: TextStyle(color: colorScheme.onErrorContainer),
                        ),
                        trailing: IconButton(
                          tooltip: 'Cerrar',
                          onPressed: () {
                            discoverProvider.clearActionError();
                            themeProvider.clearSoundError();
                          },
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedFeed,
        onDestinationSelected: (index) => _feedController.animateToPage(
          index,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'For You',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildFeed(
    List<VideoPost> videos,
    DiscoverProvider discoverProvider,
    Key key,
  ) {
    if (videos.isEmpty) {
      return const Center(
        child: Text(
          'Aún no hay videos aquí.\nGuarda alguno en Favorites para verlo después.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return VideoScrollableView(
      key: key,
      videos: videos,
      discoverProvider: discoverProvider,
    );
  }

  static const _feedTitles = ['Discover', 'For You', 'Favorites'];

  IconData _seasonIcon(SeasonTheme theme) => switch (theme) {
    SeasonTheme.normal => Icons.public,
    SeasonTheme.halloween => Icons.nightlight_round,
    SeasonTheme.christmas => Icons.ac_unit,
    SeasonTheme.valentines => Icons.favorite,
  };
}

enum _ThemeChoice {
  automatic,
  normal,
  halloween,
  christmas,
  valentines;

  SeasonTheme? get season => switch (this) {
    _ThemeChoice.automatic => null,
    _ThemeChoice.normal => SeasonTheme.normal,
    _ThemeChoice.halloween => SeasonTheme.halloween,
    _ThemeChoice.christmas => SeasonTheme.christmas,
    _ThemeChoice.valentines => SeasonTheme.valentines,
  };

  String get label => switch (this) {
    _ThemeChoice.automatic => 'Automático (fecha del dispositivo)',
    _ThemeChoice.normal => 'Normal',
    _ThemeChoice.halloween => 'Halloween',
    _ThemeChoice.christmas => 'Christmas',
    _ThemeChoice.valentines => "Valentine's Day",
  };

  IconData get icon => switch (this) {
    _ThemeChoice.automatic => Icons.calendar_month,
    _ThemeChoice.normal => Icons.public,
    _ThemeChoice.halloween => Icons.nightlight_round,
    _ThemeChoice.christmas => Icons.ac_unit,
    _ThemeChoice.valentines => Icons.favorite,
  };
}
