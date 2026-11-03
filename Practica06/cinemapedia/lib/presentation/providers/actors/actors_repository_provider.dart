import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';

// Este repositorio es inmutable
final actorsRepositoryProvider = Provider((ref) {
  final locale = ref.watch(languageProvider);
  final language = switch (locale.languageCode) {
    'en' => 'en-US',
    'de' => 'de-DE',
    'ko' => 'ko-KR',
    _ => 'es-MX',
  };
  return ActorRepositoryImpl(ActorMovieDbDatasource(language: language));
});
