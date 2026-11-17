import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteMovieButton extends ConsumerWidget {
  final Movie movie;

  const FavoriteMovieButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref
        .watch(favoriteMoviesProvider)
        .any((favorite) => favorite.id == movie.id);

    // TODO: idioma
    return IconButton.filledTonal(
      tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
      onPressed: () =>
          ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie),
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
    );
  }
}
