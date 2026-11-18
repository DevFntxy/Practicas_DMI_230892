import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';

abstract class SeriesDatasource {
  Future<List<TvShow>> getTrendingSeries({int page = 1});

  Future<List<TvShow>> getPopularSeries({int page = 1});

  Future<List<TvShow>> getOnTheAirSeries({int page = 1});

  Future<TvShow> getSeriesById(String id);

  Future<List<Actor>> getActorsBySeries(String seriesId);

  Future<List<Video>> getVideosBySeries(int seriesId);

  Future<List<TvShow>> getSimilarSeries(int seriesId);
}
