import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/catalog_search_repository_impl.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogSearchRepositoryProvider = Provider((ref) {
  final locale = ref.watch(languageProvider);
  final language = switch (locale.languageCode) {
    'en' => 'en-US',
    'de' => 'de-DE',
    'ko' => 'ko-KR',
    'fr' => 'fr-FR',
    'ja' => 'ja-JP',
    'pt' => 'pt-BR',
    _ => 'es-MX',
  };
  return CatalogSearchRepositoryImpl(
    MoviedbDatasource(language: language),
  );
});
