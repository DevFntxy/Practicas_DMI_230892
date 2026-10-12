import 'package:toktik/domain/entities/video_post.dart';

abstract interface class VideoDataSource {
  VideoSource get source;

  Future<List<VideoPost>> getVideos();
}
