import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';

            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings/language',
      name: LanguageSettingsScreen.name,
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: CategoriesScreen.name,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/series',
      name: SeriesScreen.name,
      builder: (context, state) => const SeriesScreen(),
      routes: [
        GoRoute(
          path: ':id',
          name: SeriesDetailScreen.name,
          builder: (context, state) => SeriesDetailScreen(
            seriesId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      name: FavoritesView.name,
      builder: (context, state) => const FavoritesView(),
    ),
  ],
);
