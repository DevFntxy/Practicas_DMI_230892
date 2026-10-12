import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/domain/entities/video_post.dart';

class LocalPreferencesDataSource {
  static const _favoriteIdsKey = 'toktik.favorite_video_ids';
  static const _likePrefix = 'toktik.likes.';
  static const _likedPrefix = 'toktik.liked.';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  Future<int> getLikeCount(VideoPost video) async {
    final preferences = await _preferences;
    return preferences.getInt('$_likePrefix${video.id}') ?? video.likes;
  }

  Future<bool> isLiked(VideoPost video) async {
    final preferences = await _preferences;
    return preferences.getBool('$_likedPrefix${video.id}') ?? false;
  }

  Future<void> saveLikeState({
    required VideoPost video,
    required bool isLiked,
    required int likeCount,
  }) async {
    final preferences = await _preferences;
    await preferences.setBool('$_likedPrefix${video.id}', isLiked);
    await preferences.setInt('$_likePrefix${video.id}', likeCount);
  }

  Future<Set<String>> getFavoriteIds() async {
    final preferences = await _preferences;
    return (preferences.getStringList(_favoriteIdsKey) ?? const []).toSet();
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    final preferences = await _preferences;
    await preferences.setStringList(_favoriteIdsKey, ids.toList());
  }
}
