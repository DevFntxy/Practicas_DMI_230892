import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/series/series_providers.dart';
import 'package:cinemapedia/presentation/widgets/series/series_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimilarSeries extends ConsumerWidget {
  final int seriesId;

  const SimilarSeries({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = ref.watch(similarSeriesProvider(seriesId));

    return series.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(AppLocalizations.of(context).failedToLoadRecommendations),
      ),
      data: (items) => items.isEmpty
          ? const SizedBox.shrink()
          : _SimilarSeriesList(series: items),
    );
  }
}

class _SimilarSeriesList extends StatelessWidget {
  final List<TvShow> series;

  const _SimilarSeriesList({required this.series});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            AppLocalizations.of(context).recommendations,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: series.length,
            itemBuilder: (context, index) => SizedBox(
              width: 165,
              child: SeriesPosterCard(series: series[index]),
            ),
          ),
        ),
      ],
    );
  }
}
