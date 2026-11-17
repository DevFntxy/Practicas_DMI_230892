import 'package:cinemapedia/domain/entities/movie_genre.dart';

class GenreMovieDB {
  final int id;
  final String name;

  const GenreMovieDB({required this.id, required this.name});

  factory GenreMovieDB.fromJson(Map<String, dynamic> json) =>
      GenreMovieDB(id: json['id'] as int, name: json['name'] as String);

  MovieGenre toEntity() => MovieGenre(id: id, name: name);
}
