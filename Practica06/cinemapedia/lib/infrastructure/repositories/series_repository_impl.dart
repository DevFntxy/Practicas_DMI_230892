import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/datasources/series_datasource.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/series_repository.dart';

class SeriesRepositoryImpl extends SeriesRepository {
  final SeriesDatasource datasource;

  SeriesRepositoryImpl(this.datasource);

  @override
  Future<List<TvShow>> getTrendingSeries({int page = 1}) =>
      datasource.getTrendingSeries(page: page);

  @override
  Future<List<TvShow>> getPopularSeries({int page = 1}) =>
      datasource.getPopularSeries(page: page);

  @override
  Future<List<TvShow>> getOnTheAirSeries({int page = 1}) =>
      datasource.getOnTheAirSeries(page: page);

  @override
  Future<TvShow> getSeriesById(String id) => datasource.getSeriesById(id);

  @override
  Future<List<Actor>> getActorsBySeries(String seriesId) =>
      datasource.getActorsBySeries(seriesId);

  @override
  Future<List<Video>> getVideosBySeries(int seriesId) =>
      datasource.getVideosBySeries(seriesId);

  @override
  Future<List<TvShow>> getSimilarSeries(int seriesId) =>
      datasource.getSimilarSeries(seriesId);
}
