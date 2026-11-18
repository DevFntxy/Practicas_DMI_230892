import 'package:cinemapedia/domain/entities/catalog_search_result.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvShow', () {
    test('parses list and detail responses from TMDB', () {
      final show = TvShow.fromJson({
        'id': 42,
        'name': 'Example series',
        'overview': 'A story',
        'poster_path': '/poster.jpg',
        'backdrop_path': '/backdrop.jpg',
        'genre_ids': [18, 10765],
        'first_air_date': '2024-01-02',
        'vote_average': 8.25,
      });

      expect(show.id, 42);
      expect(show.name, 'Example series');
      expect(show.posterPath, 'https://image.tmdb.org/t/p/w500/poster.jpg');
      expect(show.genres, ['18', '10765']);
      expect(show.firstAirDate, DateTime(2024, 1, 2));
      expect(show.numberOfSeasons, 0);
    });

    test('uses available series details when parsing a detail response', () {
      final show = TvShow.fromJson({
        'id': 42,
        'name': 'Example series',
        'genres': [
          {'id': 18, 'name': 'Drama'},
        ],
        'number_of_seasons': 3,
        'number_of_episodes': 24,
      });

      expect(show.genres, ['Drama']);
      expect(show.numberOfSeasons, 3);
      expect(show.numberOfEpisodes, 24);
      expect(show.firstAirDate, isNull);
    });
  });

  test('search result distinguishes TV shows from movies', () {
    final showResult = CatalogSearchResult.fromJson({
      'id': 42,
      'media_type': 'tv',
      'name': 'Example series',
      'vote_average': 8,
    });
    final movieResult = CatalogSearchResult.fromJson({
      'id': 43,
      'media_type': 'movie',
      'title': 'Example movie',
    });

    expect(showResult.isSeries, isTrue);
    expect(showResult.title, 'Example series');
    expect(movieResult.isSeries, isFalse);
    expect(movieResult.title, 'Example movie');
  });
}
