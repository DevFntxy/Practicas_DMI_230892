import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/series/series_providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_sidebar.dart';
import 'package:cinemapedia/presentation/widgets/shared/catalog_search_button.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/series/series_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeriesScreen extends ConsumerWidget {
  static const name = 'series-screen';

  const SeriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final trending = ref.watch(trendingSeriesProvider);
    final popular = ref.watch(popularSeriesProvider);
    final onTheAir = ref.watch(onTheAirSeriesProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.series),
          actions: const [CatalogSearchButton()],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: strings.trendingSeries),
              Tab(text: strings.popularSeries),
              Tab(text: strings.onTheAirSeries),
            ],
          ),
        ),
        drawer: const AppSidebar(),
        bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
        body: TabBarView(
          children: [
            _SeriesTab(
              series: trending,
              onRetry: () => ref.invalidate(trendingSeriesProvider),
            ),
            _SeriesTab(
              series: popular,
              onRetry: () => ref.invalidate(popularSeriesProvider),
            ),
            _SeriesTab(
              series: onTheAir,
              onRetry: () => ref.invalidate(onTheAirSeriesProvider),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeriesTab extends StatelessWidget {
  final AsyncValue<List<TvShow>> series;
  final VoidCallback onRetry;

  const _SeriesTab({required this.series, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return series.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.failedToLoadSeries, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                strings.noSeriesAvailable,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = (constraints.maxWidth / 190).floor().clamp(2, 6);
            return GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  SeriesPosterCard(series: items[index]),
            );
          },
        );
      },
    );
  }
}
