import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/series/series_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trendingSeriesProvider = FutureProvider<List<TvShow>>(
  (ref) => ref.watch(seriesRepositoryProvider).getTrendingSeries(),
);

final popularSeriesProvider = FutureProvider<List<TvShow>>(
  (ref) => ref.watch(seriesRepositoryProvider).getPopularSeries(),
);

final onTheAirSeriesProvider = FutureProvider<List<TvShow>>(
  (ref) => ref.watch(seriesRepositoryProvider).getOnTheAirSeries(),
);

final seriesByIdProvider = FutureProvider.family<TvShow, String>(
  (ref, id) => ref.watch(seriesRepositoryProvider).getSeriesById(id),
);

final actorsBySeriesProvider = FutureProvider.family<List<Actor>, String>(
  (ref, id) => ref.watch(seriesRepositoryProvider).getActorsBySeries(id),
);

final seriesVideosProvider = FutureProvider.family<List<Video>, int>(
  (ref, id) => ref.watch(seriesRepositoryProvider).getVideosBySeries(id),
);

final similarSeriesProvider = FutureProvider.family<List<TvShow>, int>(
  (ref, id) => ref.watch(seriesRepositoryProvider).getSimilarSeries(id),
);
