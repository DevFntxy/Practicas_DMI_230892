import 'package:cinemapedia/domain/datasources/catalog_search_datasource.dart';
import 'package:cinemapedia/domain/entities/catalog_search_result.dart';
import 'package:cinemapedia/domain/repositories/catalog_search_repository.dart';

class CatalogSearchRepositoryImpl extends CatalogSearchRepository {
  final CatalogSearchDatasource datasource;

  CatalogSearchRepositoryImpl(this.datasource);

  @override
  Future<List<CatalogSearchResult>> searchCatalog(String query) =>
      datasource.searchCatalog(query);
}
