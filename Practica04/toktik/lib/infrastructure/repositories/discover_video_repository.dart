import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_feed_repository.dart';
import 'package:toktik/infrastructure/repositories/video_catalog_repository.dart';

class DiscoverVideoRepository implements VideoFeedRepository {
  const DiscoverVideoRepository(this._catalog);

  final VideoCatalogRepository _catalog;

  @override
  Future<List<VideoPost>> getVideos() => _catalog.getVideos();
}
