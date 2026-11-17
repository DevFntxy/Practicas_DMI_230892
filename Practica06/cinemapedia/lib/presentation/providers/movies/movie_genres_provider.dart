import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_genre.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_genres_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieGenresProvider = FutureProvider<List<MovieGenre>>((ref) {
  return ref.watch(movieGenresRepositoryProvider).getMovieGenres();
});

final moviesByGenreProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  genreId,
) {
  return ref.watch(movieGenresRepositoryProvider).getMoviesByGenre(genreId);
});
