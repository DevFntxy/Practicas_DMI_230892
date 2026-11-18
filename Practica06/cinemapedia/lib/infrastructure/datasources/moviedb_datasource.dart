import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/catalog_search_datasource.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/datasources/series_datasource.dart';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/catalog_search_result.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class MoviedbDatasource extends MoviesDatasource
    implements SeriesDatasource, CatalogSearchDatasource {
  final Dio dio;

  MoviedbDatasource({required String language})
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {
            'api_key': Environment.theMovieDbKey,
            'language': language,
          },
        ),
      );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    final movieDetails = MovieDetails.fromJson(response.data);
    return MovieMapper.movieDetailsToEntity(movieDetails);
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosResponse = MoviedbVideosResponse.fromJson(response.data);

    final videos = moviedbVideosResponse.results
        .where((video) => video.site == 'YouTube')
        .map(VideoMapper.moviedbVideoToEntity)
        .toList();

    return videos.cast<Video>();
  }

  List<TvShow> _jsonToSeries(Map<String, dynamic> json) {
    final results = json['results'] as List? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(TvShow.fromJson)
        .where((series) => series.posterPath.isNotEmpty)
        .toList();
  }

  @override
  Future<List<TvShow>> getTrendingSeries({int page = 1}) async {
    final response = await dio.get(
      '/trending/tv/week',
      queryParameters: {'page': page},
    );
    return _jsonToSeries(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<TvShow>> getPopularSeries({int page = 1}) async {
    final response = await dio.get(
      '/tv/popular',
      queryParameters: {'page': page},
    );
    return _jsonToSeries(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<TvShow>> getOnTheAirSeries({int page = 1}) async {
    final response = await dio.get(
      '/tv/on_the_air',
      queryParameters: {'page': page},
    );
    return _jsonToSeries(response.data as Map<String, dynamic>);
  }

  @override
  Future<TvShow> getSeriesById(String id) async {
    final response = await dio.get('/tv/$id');
    return TvShow.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<Actor>> getActorsBySeries(String seriesId) async {
    final response = await dio.get('/tv/$seriesId/credits');
    final credits = CreditsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return credits.cast.map(ActorMapper.castToEntity).toList();
  }

  @override
  Future<List<Video>> getVideosBySeries(int seriesId) async {
    final response = await dio.get('/tv/$seriesId/videos');
    final videosResponse = MoviedbVideosResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return videosResponse.results
        .where((video) => video.site == 'YouTube')
        .map(VideoMapper.moviedbVideoToEntity)
        .toList();
  }

  @override
  Future<List<TvShow>> getSimilarSeries(int seriesId) async {
    final response = await dio.get('/tv/$seriesId/similar');
    return _jsonToSeries(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<CatalogSearchResult>> searchCatalog(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return [];

    final response = await dio.get(
      '/search/multi',
      queryParameters: {'query': normalizedQuery, 'include_adult': false},
    );
    final results = (response.data as Map<String, dynamic>)['results'] as List? ?? const [];

    return results
        .whereType<Map<String, dynamic>>()
        .where((result) => result['media_type'] == 'movie' || result['media_type'] == 'tv')
        .map(CatalogSearchResult.fromJson)
        .toList();
  }
}
