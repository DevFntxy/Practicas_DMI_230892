import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavorite(Movie movie);

  Future<bool> isMovieFavorite(int movieId);

  Future<List<Movie>> loadMovies({int limit = 10, offset = 0});

  Future<void> toggleFavoriteSeries(TvShow series);

  Future<List<TvShow>> loadFavoriteSeries({int limit = 10, int offset = 0});
}
