import 'package:toktik/domain/entities/video_post.dart';

abstract class VideoStreamRepository {
  Future<Uri> resolveStream(VideoPost video);

  void dispose();
}
