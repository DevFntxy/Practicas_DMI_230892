import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_stream_repository.dart';
import 'package:toktik/infrastructure/datasources/dailymotion_stream_resolver.dart';

class VideoStreamRepositoryImpl implements VideoStreamRepository {
  final DailymotionStreamResolver _resolver;

  VideoStreamRepositoryImpl({DailymotionStreamResolver? resolver})
    : _resolver = resolver ?? DailymotionStreamResolver();

  @override
  Future<Uri> resolveStream(VideoPost video) {
    if (video.source != VideoSource.dailymotion) {
      throw ArgumentError.value(
        video.source,
        'video.source',
        'A stream URL is only resolved for Dailymotion videos.',
      );
    }
    return _resolver.resolve(video.videoUrl);
  }

  @override
  void dispose() => _resolver.close();
}
