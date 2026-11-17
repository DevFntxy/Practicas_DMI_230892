import 'dart:convert';

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDatasource extends LocalStorageDatasource {
  static const _favoritesKey = 'cinemapedia_favorite_movies';

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
}