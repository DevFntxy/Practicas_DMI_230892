import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteSeriesProvider =
    StateNotifierProvider<FavoriteSeriesNotifier, List<TvShow>>((ref) {
      final notifier = FavoriteSeriesNotifier(
        repository: ref.watch(localStorageRepositoryProvider),
      );
      notifier.loadFavorites();
      return notifier;
    });

class FavoriteSeriesNotifier extends StateNotifier<List<TvShow>> {
  final LocalStorageRepository repository;

  FavoriteSeriesNotifier({required this.repository}) : super([]);

  Future<void> loadFavorites() async {
    state = await repository.loadFavoriteSeries(limit: 100);
  }

  bool isFavorite(int seriesId) => state.any((series) => series.id == seriesId);

  Future<void> toggleFavorite(TvShow series) async {
    await repository.toggleFavoriteSeries(series);

    if (isFavorite(series.id)) {
      state = state.where((favorite) => favorite.id != series.id).toList();
      return;
    }

    state = [...state, series];
  }
}
