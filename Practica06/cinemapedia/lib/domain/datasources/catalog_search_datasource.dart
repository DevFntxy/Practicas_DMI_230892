import 'package:cinemapedia/domain/entities/catalog_search_result.dart';

abstract class CatalogSearchDatasource {
  Future<List<CatalogSearchResult>> searchCatalog(String query);
}
