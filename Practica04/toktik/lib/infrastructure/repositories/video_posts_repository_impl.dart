import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/infrastructure/datasources/local_preferences_datasource.dart';

class VideoPostsRepositoryImpl implements VideoPostRepository {
  final List<VideoPostDatasource> dataSources;
  final LocalPreferencesDatasource preferences;

  const VideoPostsRepositoryImpl({
    required this.dataSources,
    required this.preferences,
  });

  @override
  Future<List<VideoPost>> getVideos(VideoFeed feed) async {
    final selectedSources = switch (feed) {
      VideoFeed.discover => dataSources,
      VideoFeed.forYou => dataSources,
      VideoFeed.favorites => dataSources,
    };
    final batches = await Future.wait(
      selectedSources.map((source) => source.getVideos()),
    );
    final posts = batches.expand((batch) => batch).toList(growable: false);

    final hydrated = posts.map((post) {
      final savedLikes = preferences.savedLikeCount(post.id);
      return post.copyWith(
        likes: savedLikes ?? post.likes,
        isLiked: preferences.isLiked(post.id),
        isFavorite: preferences.isFavorite(post.id),
      );
    });

    final result = hydrated.toList(growable: false);
    if (feed == VideoFeed.favorites) {
      return result.where((post) => post.isFavorite).toList(growable: false);
    }
    if (feed == VideoFeed.forYou) {
      final recommendations = [...result];
      recommendations.sort(
        (first, second) =>
            _engagementScore(second).compareTo(_engagementScore(first)),
      );
      return recommendations;
    }
    return result;
  }

  double _engagementScore(VideoPost video) =>
      video.likes / (video.views > 0 ? video.views : 1);

  @override
  Future<VideoPost> toggleLike(VideoPost video) async {
    final isLiked = !video.isLiked;
    final likes = isLiked
        ? video.likes + 1
        : (video.likes > 0 ? video.likes - 1 : 0);
    await preferences.saveLikeState(video.id, isLiked: isLiked, likes: likes);
    return video.copyWith(likes: likes, isLiked: isLiked);
  }

  @override
  Future<VideoPost> toggleFavorite(VideoPost video) async {
    final isFavorite = !video.isFavorite;
    await preferences.saveFavoriteState(video.id, isFavorite);
    return video.copyWith(isFavorite: isFavorite);
  }
}
