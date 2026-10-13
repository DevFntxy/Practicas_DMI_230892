import 'package:flutter/foundation.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class DiscoverProvider extends ChangeNotifier {
  final VideoPostRepository videosRepository;

  final Map<VideoFeed, List<VideoPost>> _videos = {};
  final Set<VideoFeed> _loadedFeeds = {};
  final Set<VideoFeed> _loadingFeeds = {};
  final Map<VideoFeed, String> errors = {};

  DiscoverProvider({required this.videosRepository});

  List<VideoPost> videosFor(VideoFeed feed) =>
      _videos[feed] ?? const <VideoPost>[];

  bool isLoading(VideoFeed feed) => _loadingFeeds.contains(feed);

  Future<void> loadFeed(VideoFeed feed, {bool force = false}) async {
    if (_loadingFeeds.contains(feed) ||
        (_loadedFeeds.contains(feed) && !force)) {
      return;
    }

    _loadingFeeds.add(feed);
    errors.remove(feed);
    notifyListeners();
    try {
      _videos[feed] = await videosRepository
          .getVideos(feed)
          .timeout(const Duration(seconds: 10));
      _loadedFeeds.add(feed);
    } catch (error) {
      errors[feed] = 'No se pudieron cargar los videos: $error';
    } finally {
      _loadingFeeds.remove(feed);
      notifyListeners();
    }
  }

  Future<void> toggleLike(VideoPost video) async {
    final updated = await videosRepository.toggleLike(video);
    _updatePost(updated);
  }

  Future<void> toggleFavorite(VideoPost video) async {
    final updated = await videosRepository.toggleFavorite(video);
    _updatePost(updated);
    if (_loadedFeeds.contains(VideoFeed.favorites)) {
      _videos[VideoFeed.favorites] = await videosRepository.getVideos(
        VideoFeed.favorites,
      );
      notifyListeners();
    }
  }

  void updatePost(VideoPost updated) => _updatePost(updated);

  void _updatePost(VideoPost updated) {
    for (final feed in VideoFeed.values) {
      final posts = _videos[feed];
      if (posts == null) continue;
      final index = posts.indexWhere((post) => post.id == updated.id);
      if (index < 0) continue;
      final nextPosts = [...posts];
      if (feed == VideoFeed.favorites && !updated.isFavorite) {
        nextPosts.removeAt(index);
      } else {
        nextPosts[index] = updated;
      }
      _videos[feed] = nextPosts;
    }
    notifyListeners();
  }
}
