import 'dart:async';

import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash shows the logo and opens home after startup data loads', (
    tester,
  ) async {
    final requests = List.generate(4, (_) => Completer<List<Movie>>());
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/',
          name: HomeScreen.name,
          builder: (context, state) =>
              const Scaffold(body: Text('Home reached')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nowPlayingMoviesProvider.overrideWith(
            (ref) => _moviesNotifier(requests[0]),
          ),
          popularMoviesProvider.overrideWith(
            (ref) => _moviesNotifier(requests[1]),
          ),
          topRatedMoviesProvider.overrideWith(
            (ref) => _moviesNotifier(requests[2]),
          ),
          upcomingMoviesProvider.overrideWith(
            (ref) => _moviesNotifier(requests[3]),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Home reached'), findsNothing);

    for (final request in requests) {
      request.complete([_movie]);
    }

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Home reached'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}

MoviesNotifier _moviesNotifier(Completer<List<Movie>> request) {
  return MoviesNotifier(fetchMoreMovies: ({page = 1}) => request.future);
}

final _movie = Movie(
  adult: false,
  backdropPath: '',
  genreIds: const [],
  id: 1,
  originalLanguage: 'en',
  originalTitle: 'Movie',
  overview: '',
  popularity: 1,
  posterPath: '',
  releaseDate: DateTime(2026),
  title: 'Movie',
  video: false,
  voteAverage: 5,
  voteCount: 1,
);
