import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/movies/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/series/favorite_series_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_sidebar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/series/series_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerWidget {
  static const name = 'favorites-screen';

  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.favorites),
          bottom: TabBar(
            tabs: [
              Tab(text: strings.favoriteMovies),
              Tab(text: strings.favoriteSeries),
            ],
          ),
        ),
        drawer: const AppSidebar(),
        bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
        body: TabBarView(
          children: [
            _FavoriteMoviesTab(favorites: ref.watch(favoriteMoviesProvider)),
            _FavoriteSeriesTab(favorites: ref.watch(favoriteSeriesProvider)),
          ],
        ),
      ),
    );
  }
}

class _FavoriteMoviesTab extends StatelessWidget {
  final List<Movie> favorites;

  const _FavoriteMoviesTab({required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) return const _EmptyFavorites();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.52,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) => MoviePosterCard(movie: favorites[index]),
    );
  }
}

class _FavoriteSeriesTab extends StatelessWidget {
  final List<TvShow> favorites;

  const _FavoriteSeriesTab({required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) return const _EmptyFavorites();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.52,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) =>
          SeriesPosterCard(series: favorites[index]),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 48),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context).noFavorites),
          ],
        ),
      ),
    );
  }
}
