import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';

class DailymotionVideoDatasource implements VideoPostDatasource {
  const DailymotionVideoDatasource();

  static const _videos = [
    {
      'id': 'x7tgad0',
      'name': 'Un momento para descubrir',
      'description':
          'Contenido recomendado de Dailymotion. Puedes activar el sonido, '
          'dar me gusta y guardar este video.',
      'author': '@dailymotion',
      'videoUrl': 'https://www.dailymotion.com/video/x7tgad0',
      'likes': 820,
      'views': 18400,
    },
  ];

  @override
  VideoSource get source => VideoSource.dailymotion;

  @override
  Future<List<VideoPost>> getVideos() async => _videos
      .map(
        (video) => LocalVideoModel.fromJson(
          video,
          source: source.name,
        ).toVideoPostEntity(source),
      )
      .toList(growable: false);
}
