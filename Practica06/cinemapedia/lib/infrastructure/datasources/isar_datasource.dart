import 'dart:convert';

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDatasource extends LocalStorageDatasource {
  static const _favoritesKey = 'cinemapedia_favorite_movies';
  static const _favoriteSeriesKey = 'cinemapedia_favorite_series';

  Future<List<Movie>> _loadStoredMovies() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedMovies = preferences.getStringList(_favoritesKey) ?? [];

    return encodedMovies
        .map((encoded) => Movie.fromJson(jsonDecode(encoded)))
        .toList();
  }

  Future<void> _saveMovies(List<Movie> movies) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _favoritesKey,
      movies.map((movie) => jsonEncode(movie.toJson())).toList(),
    );
  }

  Future<List<TvShow>> _loadStoredSeries() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedSeries = preferences.getStringList(_favoriteSeriesKey) ?? [];

    return encodedSeries
        .map((encoded) => TvShow.fromJson(jsonDecode(encoded)))
        .toList();
  }

  Future<void> _saveSeries(List<TvShow> series) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _favoriteSeriesKey,
      series.map((show) => jsonEncode(show.toJson())).toList(),
    );
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final movies = await _loadStoredMovies();
    return movies.any((movie) => movie.id == movieId);
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final movies = await _loadStoredMovies();
    final exists = movies.any((favorite) => favorite.id == movie.id);

    if (exists) {
      await _saveMovies(
        movies.where((favorite) => favorite.id != movie.id).toList(),
      );
      return;
    }

    await _saveMovies([...movies, movie]);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final movies = await _loadStoredMovies();
    final end = (offset + limit).clamp(0, movies.length);
    return movies.sublist(offset.clamp(0, movies.length), end);
  }

  @override
  Future<void> toggleFavoriteSeries(TvShow series) async {
    final favorites = await _loadStoredSeries();
    final exists = favorites.any((favorite) => favorite.id == series.id);

    if (exists) {
      await _saveSeries(
        favorites.where((favorite) => favorite.id != series.id).toList(),
      );
      return;
    }

    await _saveSeries([...favorites, series]);
  }

  @override
  Future<List<TvShow>> loadFavoriteSeries({
    int limit = 10,
    int offset = 0,
  }) async {
    final series = await _loadStoredSeries();
    final start = offset.clamp(0, series.length);
    final end = (offset + limit).clamp(start, series.length);
    return series.sublist(start, end);
  }
}
