import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/datasources/video_data_source.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';

class VimeoVideoDataSource implements VideoDataSource {
  static const _videos = [
    {
      'name': 'Vimeo: creatividad en movimiento',
      'description': 'Una selección de Vimeo reproducida directamente desde su reproductor embebido.',
      'videoUrl': 'https://vimeo.com/76979871',
      'likes': 1560,
      'views': 53600,
    },
    {
      'name': 'Vimeo: historias visuales',
      'description': 'Descubre una historia visual desde Vimeo; el reproductor permite activar o silenciar audio.',
      'videoUrl': 'https://vimeo.com/22439234',
      'likes': 968,
      'views': 21800,
    },
  ];

  @override
  VideoSource get source => VideoSource.vimeo;

  @override
  Future<List<VideoPost>> getVideos() async => _videos
      .map(
        (video) =>
            LocalVideoModel.fromJson(video, source: source).toVideoPostEntity(),
      )
      .toList(growable: false);
}
