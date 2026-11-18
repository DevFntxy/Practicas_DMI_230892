import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/catalog_search_result.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogSearchButton extends ConsumerWidget {
  const CatalogSearchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);

    return IconButton(
      tooltip: strings.searchMoviesAndSeries,
      onPressed: () {
        showSearch<CatalogSearchResult?>(
          context: context,
          query: ref.read(searchQueryProvider),
          delegate: SearchMovieDelegate(
            initialMovies: ref.read(searchedMoviesProvider),
            searchMovies: ref
                .read(searchedMoviesProvider.notifier)
                .searchMoviesByQuery,
            searchLabel: strings.searchMoviesAndSeries,
          ),
        ).then((result) {
          if (result == null || !context.mounted) return;
          final path = result.isSeries ? '/series/${result.id}' : '/movie/${result.id}';
          context.push(path);
        });
      },
      icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
    );
  }
}
