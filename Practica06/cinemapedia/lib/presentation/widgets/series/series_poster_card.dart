import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/widgets/series/favorite_series_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeriesPosterCard extends StatelessWidget {
  final TvShow series;

  const SeriesPosterCard({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/series/${series.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InkWell(
                    onTap: () => context.push('/series/${series.id}'),
                    child: Image.network(
                      series.posterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.live_tv_outlined, size: 40),
                          ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: FavoriteSeriesButton(series: series),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Text(
                series.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, size: 16, color: Colors.amber[700]),
                  const SizedBox(width: 4),
                  Text(series.voteAverage.toStringAsFixed(1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
