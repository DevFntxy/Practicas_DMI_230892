import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesDatasource {
  static const _simulatedDateKey = 'seasonal.simulatedDate';

  final SharedPreferences _preferences;

  const LocalPreferencesDatasource(this._preferences);

  DateTime? get simulatedDate {
    final value = _preferences.getString(_simulatedDateKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> setSimulatedDate(DateTime? date) async {
    if (date == null) {
      await _preferences.remove(_simulatedDateKey);
      return;
    }
    await _preferences.setString(
      _simulatedDateKey,
      DateTime(date.year, date.month, date.day).toIso8601String(),
    );
  }

  bool isLiked(String videoId) => _preferences.getBool('like:$videoId') ?? false;

  int? savedLikeCount(String videoId) => _preferences.getInt('likes:$videoId');

  Future<void> saveLikeState(
    String videoId, {
    required bool isLiked,
    required int likes,
  }) async {
    await _preferences.setBool('like:$videoId', isLiked);
    await _preferences.setInt('likes:$videoId', likes);
  }

  bool isFavorite(String videoId) =>
      _preferences.getBool('favorite:$videoId') ?? false;

  Future<void> saveFavoriteState(String videoId, bool isFavorite) async {
    await _preferences.setBool('favorite:$videoId', isFavorite);
  }
}
