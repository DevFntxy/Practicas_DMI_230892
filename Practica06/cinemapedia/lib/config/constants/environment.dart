import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static bool get hasMovieDbKey => dotenv.env['THE_MOVIEDB_KEY'] != null && dotenv.env['THE_MOVIEDB_KEY']!.isNotEmpty;

  static String get theMovieDbKey => dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';
}