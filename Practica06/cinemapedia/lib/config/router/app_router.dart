import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings/language',
      name: LanguageSettingsScreen.name,
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
  ]
);