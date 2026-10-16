import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';
import 'package:toktik/shared/data/local_video_posts.dart';

class LocalVideoDatasource implements VideoPostDatasource {
  const LocalVideoDatasource();

  @override
  VideoSource get source => VideoSource.local;

  @override
  Future<List<VideoPost>> getVideos() async => videoPosts
      .map(
        (video) => LocalVideoModel.fromJson(
          video,
          source: source.name,
        ).toVideoPostEntity(source),
      )
      .toList(growable: false);
}
