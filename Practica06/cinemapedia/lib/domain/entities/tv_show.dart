class TvShow {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final List<String> genres;
  final DateTime? firstAirDate;
  final double voteAverage;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  const TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genres,
    required this.firstAirDate,
    required this.voteAverage,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    final rawGenres =
        json['genres'] as List? ?? json['genre_ids'] as List? ?? [];
    final rawDate = json['first_air_date'] as String?;

    return TvShow(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Sin título',
      overview: json['overview'] as String? ?? '',
      posterPath: _imageUrl(json['poster_path'] as String?, poster: true),
      backdropPath: _imageUrl(json['backdrop_path'] as String?),
      genres: rawGenres
          .map(
            (genre) =>
                genre is Map ? genre['name'].toString() : genre.toString(),
          )
          .toList(),
      firstAirDate: rawDate == null || rawDate.isEmpty
          ? null
          : DateTime.tryParse(rawDate),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      numberOfSeasons: json['number_of_seasons'] as int? ?? 0,
      numberOfEpisodes: json['number_of_episodes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': _imagePath(posterPath),
    'backdrop_path': _imagePath(backdropPath),
    'genres': genres,
    'first_air_date': firstAirDate?.toIso8601String(),
    'vote_average': voteAverage,
    'number_of_seasons': numberOfSeasons,
    'number_of_episodes': numberOfEpisodes,
  };

  static String? _imagePath(String url) {
    final uri = Uri.tryParse(url);
    final segments = uri?.pathSegments;
    if (uri?.host != 'image.tmdb.org' || segments == null) return null;
    final sizeIndex = segments.indexOf('w500');
    if (sizeIndex == -1 || sizeIndex == segments.length - 1) return null;
    return '/${segments.skip(sizeIndex + 1).join('/')}';
  }

  static String _imageUrl(String? path, {bool poster = false}) {
    if (path == null || path.isEmpty) {
      return poster
          ? 'https://www.movienewz.com/img/films/poster-holder.jpg'
          : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg';
    }

    return 'https://image.tmdb.org/t/p/w500$path';
  }
}
