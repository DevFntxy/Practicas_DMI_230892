import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final strings = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset(
                'assets/fanso-cinemapedia.png',
                width: 38,
                height: 38,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(strings.appName, style: titleStyle),

              const Spacer(),

              IconButton(
                tooltip: strings.settings,
                onPressed: () => context.pushNamed(LanguageSettingsScreen.name),
                icon: const Icon(Icons.settings_outlined),
              ),
              IconButton(
                tooltip: strings.search,
                onPressed: () {
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchMovies: ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery,
                    ),
                  ).then((movie) {
                    if (movie == null || !context.mounted) return;
                    context.push('/movie/${movie.id}');
                  });
                },
                icon: Icon(Icons.search, color: colors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
