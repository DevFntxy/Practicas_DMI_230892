import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/infrastructure/datasources/isar_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('series favorites persist and can be removed', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPreferencesDatasource();
    final series = TvShow(
      id: 42,
      name: 'Serie de prueba',
      overview: 'Descripción',
      posterPath: 'https://image.tmdb.org/t/p/w500/poster.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w500/backdrop.jpg',
      genres: const ['Drama'],
      firstAirDate: DateTime(2024, 1, 2),
      voteAverage: 8.5,
      numberOfSeasons: 2,
      numberOfEpisodes: 16,
    );

    await storage.toggleFavoriteSeries(series);

    final stored = await storage.loadFavoriteSeries();
    expect(stored, hasLength(1));
    expect(stored.single.toJson(), series.toJson());

    await storage.toggleFavoriteSeries(series);
    expect(await storage.loadFavoriteSeries(), isEmpty);
  });
}
