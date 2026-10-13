import 'package:toktik/domain/entities/video_post.dart';

abstract class VideoPostDatasource {
  VideoSource get source;

  Future<List<VideoPost>> getVideos();
}
