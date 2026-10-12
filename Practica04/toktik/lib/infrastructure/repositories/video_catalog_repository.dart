import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/datasources/dailymotion_video_data_source.dart';
import 'package:toktik/infrastructure/datasources/direct_mp4_video_data_source.dart';
import 'package:toktik/infrastructure/datasources/video_data_source.dart';
import 'package:toktik/infrastructure/datasources/vimeo_video_data_source.dart';

class VideoCatalogRepository {
  VideoCatalogRepository({List<VideoDataSource>? dataSources})
    : _dataSources =
          dataSources ??
          [
            DirectMp4VideoDataSource(),
            DailymotionVideoDataSource(),
            VimeoVideoDataSource(),
          ];

  final List<VideoDataSource> _dataSources;

  Future<List<VideoPost>> getVideos() async {
    final videos = await Future.wait(
      _dataSources.map((dataSource) => dataSource.getVideos()),
    );
    return videos
        .expand((sourceVideos) => sourceVideos)
        .toList(growable: false);
  }
}
