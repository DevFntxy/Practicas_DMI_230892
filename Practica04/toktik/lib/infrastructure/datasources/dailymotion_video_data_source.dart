import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/datasources/video_data_source.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';

class DailymotionVideoDataSource implements VideoDataSource {
  static const _videos = [
    {
      'name': 'Dailymotion: video destacado',
      'description': 'Video servido desde Dailymotion; abre el reproductor integrado para ver el contenido.',
      'videoUrl': 'https://www.dailymotion.com/video/x7tgad0',
      'likes': 820,
      'views': 18400,
    },
    {
      'name': 'Dailymotion: historias para descubrir',
      'description': 'Explora contenido de Dailymotion con controles de reproducción y sonido integrados.',
      'videoUrl': 'https://www.dailymotion.com/video/x84sh87',
      'likes': 1240,
      'views': 42700,
    },
  ];

  @override
  VideoSource get source => VideoSource.dailymotion;

  @override
  Future<List<VideoPost>> getVideos() async => _videos
      .map(
        (video) =>
            LocalVideoModel.fromJson(video, source: source).toVideoPostEntity(),
      )
      .toList(growable: false);
}
