import 'package:cinemapedia/config/localization/app_localizations.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/series/favorite_series_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteSeriesButton extends ConsumerWidget {
  final TvShow series;

  const FavoriteSeriesButton({super.key, required this.series});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref
        .watch(favoriteSeriesProvider)
        .any((favorite) => favorite.id == series.id);
    final strings = AppLocalizations.of(context);

    return IconButton.filledTonal(
      tooltip: isFavorite ? strings.removeFavorite : strings.addFavorite,
      onPressed: () =>
          ref.read(favoriteSeriesProvider.notifier).toggleFavorite(series),
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
    );
  }
}
