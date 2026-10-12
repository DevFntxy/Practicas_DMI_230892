import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/datasources/direct_mp4_video_data_source.dart';

class DiscoverProvider extends ChangeNotifier {
  bool initialLoading = true;
  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    videos = await DirectMp4VideoDataSource().getVideos();
    initialLoading = false;
    notifyListeners();
  }
}
