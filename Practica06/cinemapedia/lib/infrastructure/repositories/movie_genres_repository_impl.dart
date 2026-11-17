import 'package:cinemapedia/domain/datasources/movie_genres_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_genre.dart';
import 'package:cinemapedia/domain/repositories/movie_genres_repository.dart';

class MovieGenresRepositoryImpl extends MovieGenresRepository {
  final MovieGenresDatasource datasource;

  MovieGenresRepositoryImpl(this.datasource);

  @override
  Future<List<MovieGenre>> getMovieGenres() => datasource.getMovieGenres();

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId) =>
      datasource.getMoviesByGenre(genreId);
}
