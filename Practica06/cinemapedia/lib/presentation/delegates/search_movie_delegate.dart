import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/catalog_search_result.dart';
import 'package:cinemapedia/config/localization/app_localizations.dart';

typedef SearchMoviesCallback = Future<List<CatalogSearchResult>> Function(
  String query,
);

class SearchMovieDelegate extends SearchDelegate<CatalogSearchResult?> {
  final SearchMoviesCallback searchMovies;
  List<CatalogSearchResult> initialMovies;
  final String searchLabel;

  StreamController<List<CatalogSearchResult>> debouncedMovies =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
    required this.searchLabel,
  }) : super(searchFieldLabel: searchLabel);

  void clearStreams() {
    _debounceTimer?.cancel();
    if (!debouncedMovies.isClosed) debouncedMovies.close();
    if (!isLoadingStream.isClosed) isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        initialMovies = [];
        if (!debouncedMovies.isClosed) debouncedMovies.add([]);
        if (!isLoadingStream.isClosed) isLoadingStream.add(false);
        return;
      }

      try {
        final results = await searchMovies(query);
        initialMovies = results;
        if (!debouncedMovies.isClosed) debouncedMovies.add(results);
      } catch (error, stackTrace) {
        if (!debouncedMovies.isClosed) {
          debouncedMovies.addError(error, stackTrace);
        }
      } finally {
        if (!isLoadingStream.isClosed) isLoadingStream.add(false);
      }
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context).searchFailed),
          );
        }
        final movies = snapshot.data ?? [];
        if (movies.isEmpty && query.trim().isNotEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context).noSearchResults),
          );
        }

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _CatalogItem(
            result: movies[index],
            onResultSelected: (context, result) {
              clearStreams();
              close(context, result);
            },
          ),
        );
      },
    );
  }

  // @override
  // String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != _lastQuery) {
      _lastQuery = query;
      _onQueryChanged(query);
    }
    return buildResultsAndSuggestions();
  }

  String _lastQuery = '';
}

class _CatalogItem extends StatelessWidget {
  final CatalogSearchResult result;
  final void Function(BuildContext, CatalogSearchResult) onResultSelected;

  const _CatalogItem({
    required this.result,
    required this.onResultSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        onResultSelected(context, result);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 76,
              height: 112,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  result.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported_outlined,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyles.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          result.isSeries ? strings.series : strings.movies,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),

                  Text(
                    result.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(result.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
