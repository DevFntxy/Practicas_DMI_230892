import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_feed_repository.dart';
import 'package:toktik/infrastructure/repositories/video_catalog_repository.dart';

class ForYouVideoRepository implements VideoFeedRepository {
  const ForYouVideoRepository(this._catalog);

  final VideoCatalogRepository _catalog;

  @override
  Future<List<VideoPost>> getVideos() async {
    final videos = await _catalog.getVideos();
    return videos.toList()
      ..sort((first, second) => second.views.compareTo(first.views));
  }
}
