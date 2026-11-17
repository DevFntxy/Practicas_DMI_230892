import 'package:cinemapedia/infrastructure/datasources/movie_genres_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_genres_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieGenresRepositoryProvider = Provider((ref) {
  return MovieGenresRepositoryImpl(MovieGenresMovieDbDatasource());
});
