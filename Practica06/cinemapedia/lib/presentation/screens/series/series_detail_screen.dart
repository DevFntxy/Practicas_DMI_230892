import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/series/series_providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SeriesDetailScreen extends ConsumerWidget {
  static const name = 'series-detail-screen';

  final String seriesId;

  const SeriesDetailScreen({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = ref.watch(seriesByIdProvider(seriesId));
    final strings = AppLocalizations.of(context);

    return Scaffold(
      body: series.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.failedToLoadSeries),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(seriesByIdProvider(seriesId)),
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
        data: (show) => _SeriesDetails(series: show),
      ),
    );
  }
}

class _SeriesDetails extends StatelessWidget {
  final TvShow series;

  const _SeriesDetails({required this.series});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final styles = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);
    final date = series.firstAirDate;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              series.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            background: Image.network(
              series.backdropPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: Colors.black12),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverList.list(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        series.posterPath,
                        width: size.width * 0.3,
                        errorBuilder: (context, error, stackTrace) =>
                            SizedBox(
                              width: size.width * 0.3,
                              height: size.width * 0.45,
                              child: const Icon(Icons.live_tv_outlined),
                            ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(series.name, style: styles.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            series.overview.isEmpty
                                ? strings.descriptionUnavailable
                                : series.overview,
                            maxLines: 8,
                            overflow: TextOverflow.ellipsis,
                            style: styles.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          MovieRating(voteAverage: series.voteAverage),
                          if (date != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Text(
                                    strings.firstAirDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      DateFormat.yMMMd(
                                        Localizations.localeOf(
                                          context,
                                        ).toLanguageTag(),
                                      ).format(date),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (series.numberOfSeasons > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                strings.seasonsAndEpisodes(
                                  series.numberOfSeasons,
                                  series.numberOfEpisodes,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (series.genres.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: series.genres
                      .map((genre) => Chip(label: Text(genre)))
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              ActorsBySeries(seriesId: series.id.toString()),
              VideosFromSeries(seriesId: series.id),
              SimilarSeries(seriesId: series.id),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
