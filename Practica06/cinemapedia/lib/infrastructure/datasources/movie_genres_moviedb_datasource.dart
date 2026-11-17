import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movie_genres_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_genre.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genre_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieGenresMovieDbDatasource extends MovieGenresDatasource {
  final Dio dio;

  MovieGenresMovieDbDatasource()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {'api_key': Environment.theMovieDbKey},
        ),
      );

  @override
  Future<List<MovieGenre>> getMovieGenres() async {
    final response = await dio.get('/genre/movie/list');
    final genres = response.data['genres'] as List<dynamic>;

    return genres
        .map(
          (genre) =>
              GenreMovieDB.fromJson(genre as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    final response = await dio.get(
      '/discover/movie',
      queryParameters: {'with_genres': genreId},
    );
    final movieResponse = MovieDbResponse.fromJson(response.data);

    return movieResponse.results.map(MovieMapper.movieDBToEntity).toList();
  }
}
