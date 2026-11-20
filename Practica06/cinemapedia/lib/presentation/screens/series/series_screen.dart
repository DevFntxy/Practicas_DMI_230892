import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/series/series_providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_sidebar.dart';
import 'package:cinemapedia/presentation/widgets/shared/catalog_search_button.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/series/series_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeriesScreen extends ConsumerWidget {
  static const name = 'series-screen';

  const SeriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.series),
        actions: const [CatalogSearchButton()],
      ),
      drawer: const AppSidebar(),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
      body: ListView(
        children: [
          _SeriesSection(
            title: strings.trendingSeries,
            series: ref.watch(trendingSeriesProvider),
            onRetry: () => ref.invalidate(trendingSeriesProvider),
            featured: true,
          ),
          _SeriesSection(
            title: strings.popularSeries,
            series: ref.watch(popularSeriesProvider),
            onRetry: () => ref.invalidate(popularSeriesProvider),
          ),
          _SeriesSection(
            title: strings.onTheAirSeries,
            series: ref.watch(onTheAirSeriesProvider),
            onRetry: () => ref.invalidate(onTheAirSeriesProvider),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SeriesSection extends StatelessWidget {
  final String title;
  final AsyncValue<List<TvShow>> series;
  final VoidCallback onRetry;
  final bool featured;

  const _SeriesSection({
    required this.title,
    required this.series,
    required this.onRetry,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return series.when(
      loading: () => const SizedBox(
        height: 190,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(strings.failedToLoadSeries, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: onRetry, child: Text(strings.retry)),
          ],
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(strings.noSeriesAvailable, textAlign: TextAlign.center),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featured) ...[
              _FeaturedSeries(series: items.take(5).toList()),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) => SizedBox(
                  width: 170,
                  child: SeriesPosterCard(series: items[index]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeaturedSeries extends StatelessWidget {
  final List<TvShow> series;

  const _FeaturedSeries({required this.series});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245,
      child: PageView.builder(
        itemCount: series.length,
        itemBuilder: (context, index) {
          final show = series[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/series/${show.id}'),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      show.backdropPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(color: Colors.black26),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            show.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                show.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
