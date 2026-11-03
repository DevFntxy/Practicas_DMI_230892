import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/localization/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    if (ref.read(nowPlayingMoviesProvider).isEmpty) {
      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    }
    if (ref.read(popularMoviesProvider).isEmpty) {
      ref.read(popularMoviesProvider.notifier).loadNextPage();
    }
    if (ref.read(topRatedMoviesProvider).isEmpty) {
      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    }
    if (ref.read(upcomingMoviesProvider).isEmpty) {
      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(languageProvider, (previous, next) {
      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
      ref.read(popularMoviesProvider.notifier).loadNextPage();
      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    });

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final strings = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                // const CustomAppbar(),

                MoviesSlideshow(movies: slideShowMovies),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: strings.nowPlaying,
                  subTitle: strings.monday20,
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: strings.comingSoon,
                  subTitle: strings.thisMonth,
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: popularMovies,
                  title: strings.popular,
                  // subTitle: '',
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: strings.topRated,
                  subTitle: strings.allTime,
                  loadNextPage: () =>
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),

                const SizedBox(height: 10),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
