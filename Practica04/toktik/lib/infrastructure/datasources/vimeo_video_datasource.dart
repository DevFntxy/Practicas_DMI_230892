import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';

class VimeoVideoDatasource implements VideoPostDatasource {
  const VimeoVideoDatasource();

  static const _videos = [
    {
      'id': '76979871',
      'name': 'Historias en movimiento',
      'description':
          'Una historia visual seleccionada de Vimeo. Explora el video y '
          'guarda tus favoritos para volver a verlos.',
      'author': '@vimeo',
      'videoUrl': 'https://vimeo.com/76979871',
      'likes': 1560,
      'views': 53600,
    },
  ];

  @override
  VideoSource get source => VideoSource.vimeo;

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
