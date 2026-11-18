import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_sidebar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerWidget {
  static const name = 'favorites-screen';

  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteMoviesProvider);

    // TODO: idioma
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      drawer: const AppSidebar(),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
      body: favorites.isEmpty
          ? const _EmptyFavorites()
          : _FavoritesGrid(favorites: favorites),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<Movie> favorites;

  const _FavoritesGrid({required this.favorites});

  @override
  Widget build(BuildContext context) {
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

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    // TODO: idioma
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 48),
            SizedBox(height: 12),
            Text('Todavía no tienes películas favoritas.'),
            SizedBox(height: 4),
            Text('Agrega películas con el ícono de corazón.'),
          ],
        ),
      ),
    );
  }
}
