import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cinemapedia/domain/entities/catalog_search_result.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<CatalogSearchResult>>((ref) {
      final catalogRepository = ref.watch(catalogSearchRepositoryProvider);

      return SearchedMoviesNotifier(
        searchMovies: catalogRepository.searchCatalog,
        ref: ref,
      );
    });

typedef SearchMoviesCallback = Future<List<CatalogSearchResult>> Function(
  String query,
);

class SearchedMoviesNotifier extends StateNotifier<List<CatalogSearchResult>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({required this.searchMovies, required this.ref})
    : super([]);

  Future<List<CatalogSearchResult>> searchMoviesByQuery(String query) async {
    final results = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = results;
    return results;
  }
}
