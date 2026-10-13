import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';

class YouTubeVideoDatasource implements VideoPostDatasource {
  const YouTubeVideoDatasource();

  static const _videos = [
    {
      'id': 'A3ltMaM6noM',
      'name': 'Ideas que inspiran',
      'description':
          'Un video para descubrir nuevas ideas y disfrutar de una pausa. '
          'Toca “más” para leer la descripción completa.',
      'author': '@youtube',
      'videoUrl': 'https://www.youtube.com/watch?v=A3ltMaM6noM',
      'likes': 1560,
      'views': 53600,
    },
  ];

  @override
  VideoSource get source => VideoSource.youtube;

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
