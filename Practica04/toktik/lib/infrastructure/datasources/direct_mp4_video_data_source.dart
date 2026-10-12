import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/datasources/video_data_source.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';

class DirectMp4VideoDataSource implements VideoDataSource {
  static const _videos = [
    {
      'id': 'flutter-bee-mp4',
      'name': 'Abeja en vuelo',
      'description': 'Video MP4 de muestra servido directamente y reproducido con el reproductor de Flutter.',
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'likes': 820,
      'views': 18400,
    },
  ];

  @override
  VideoSource get source => VideoSource.directMp4;

  @override
  Future<List<VideoPost>> getVideos() async => _videos
      .map(
        (video) =>
            LocalVideoModel.fromJson(video, source: source).toVideoPostEntity(),
      )
      .toList(growable: false);
}
