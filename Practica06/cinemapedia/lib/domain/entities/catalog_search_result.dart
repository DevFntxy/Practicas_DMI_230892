class CatalogSearchResult {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final bool isSeries;

  const CatalogSearchResult({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.isSeries,
  });

  factory CatalogSearchResult.fromJson(Map<String, dynamic> json) {
    final isSeries = json['media_type'] == 'tv';
    final poster = json['poster_path'] as String?;

    return CatalogSearchResult(
      id: json['id'] as int,
      title: (isSeries ? json['name'] : json['title']) as String? ?? 'Sin título',
      overview: json['overview'] as String? ?? '',
      posterPath: poster == null || poster.isEmpty
          ? 'https://www.movienewz.com/img/films/poster-holder.jpg'
          : 'https://image.tmdb.org/t/p/w500$poster',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      isSeries: isSeries,
    );
  }
}
