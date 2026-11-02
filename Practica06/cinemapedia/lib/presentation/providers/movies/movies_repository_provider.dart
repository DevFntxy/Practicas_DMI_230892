import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';

// Este repositorio es inmutable
final movieRepositoryProvider = Provider((ref) {
  final locale = ref.watch(languageProvider);
  final language = switch (locale.languageCode) {
    'en' => 'en-US',
    'de' => 'de-DE',
    'ko' => 'ko-KR',
    _ => 'es-MX',
  };
  return MovieRepositoryImpl(MoviedbDatasource(language: language));
});
