import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_genre.dart';

abstract class MovieGenresDatasource {
  Future<List<MovieGenre>> getMovieGenres();

  Future<List<Movie>> getMoviesByGenre(int genreId);
}
