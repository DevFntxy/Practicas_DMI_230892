import 'package:toktik/domain/entities/video_post.dart';

abstract class VideoPostRepository {
  Future<List<VideoPost>> getVideos(VideoFeed feed);

  Future<VideoPost> toggleLike(VideoPost video);

  Future<VideoPost> toggleFavorite(VideoPost video);
}
