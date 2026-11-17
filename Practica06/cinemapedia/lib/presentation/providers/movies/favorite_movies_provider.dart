import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesNotifier, List<Movie>>((ref) {
      final notifier = FavoriteMoviesNotifier(
        repository: ref.watch(localStorageRepositoryProvider),
      );
      notifier.loadFavorites();
      return notifier;
    });

class FavoriteMoviesNotifier extends StateNotifier<List<Movie>> {
  final LocalStorageRepository repository;

  FavoriteMoviesNotifier({required this.repository}) : super([]);

  Future<void> loadFavorites() async {
    state = await repository.loadMovies(limit: 100);
  }

  bool isFavorite(int movieId) => state.any((movie) => movie.id == movieId);

  Future<void> toggleFavorite(Movie movie) async {
    await repository.toggleFavorite(movie);

    if (isFavorite(movie.id)) {
      state = state.where((favorite) => favorite.id != movie.id).toList();
      return;
    }

    state = [...state, movie];
  }
}
