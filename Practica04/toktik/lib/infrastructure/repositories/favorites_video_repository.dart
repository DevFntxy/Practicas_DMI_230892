import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_feed_repository.dart';
import 'package:toktik/infrastructure/datasources/local_preferences_data_source.dart';
import 'package:toktik/infrastructure/repositories/video_catalog_repository.dart';

class FavoritesVideoRepository implements VideoFeedRepository {
  const FavoritesVideoRepository(this._catalog, this._preferences);

  final VideoCatalogRepository _catalog;
  final LocalPreferencesDataSource _preferences;

  @override
  Future<List<VideoPost>> getVideos() async {
    final favoriteIds = await _preferences.getFavoriteIds();
    final videos = await _catalog.getVideos();
    return videos
        .where((video) => favoriteIds.contains(video.id))
        .toList(growable: false);
  }
}
