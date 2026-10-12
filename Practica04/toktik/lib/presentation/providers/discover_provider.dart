import 'package:flutter/foundation.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/datasources/local_preferences_data_source.dart';
import 'package:toktik/infrastructure/repositories/discover_video_repository.dart';
import 'package:toktik/infrastructure/repositories/favorites_video_repository.dart';
import 'package:toktik/infrastructure/repositories/for_you_video_repository.dart';
import 'package:toktik/infrastructure/repositories/video_catalog_repository.dart';

class DiscoverProvider extends ChangeNotifier {
  DiscoverProvider({
    VideoCatalogRepository? catalog,
    LocalPreferencesDataSource? preferences,
  }) : _catalog = catalog ?? VideoCatalogRepository(),
       _preferences = preferences ?? LocalPreferencesDataSource() {
    _discoverRepository = DiscoverVideoRepository(_catalog);
    _forYouRepository = ForYouVideoRepository(_catalog);
    _favoritesRepository = FavoritesVideoRepository(_catalog, _preferences);
  }

  final VideoCatalogRepository _catalog;
  final LocalPreferencesDataSource _preferences;
  late final DiscoverVideoRepository _discoverRepository;
  late final ForYouVideoRepository _forYouRepository;
  late final FavoritesVideoRepository _favoritesRepository;

  List<VideoPost> _discoverVideos = [];
  List<VideoPost> _forYouVideos = [];
  List<VideoPost> _favoritesVideos = [];
  final Map<String, int> _likeCounts = {};
  final Set<String> _likedVideoIds = {};
  final Set<String> _favoriteVideoIds = {};

  bool initialLoading = true;
  String? loadError;
  String? actionError;

  List<VideoPost> get videos => discoverVideos;
  List<VideoPost> get discoverVideos => List.unmodifiable(_discoverVideos);
  List<VideoPost> get forYouVideos => List.unmodifiable(_forYouVideos);
  List<VideoPost> get favoritesVideos => List.unmodifiable(_favoritesVideos);

  int likesFor(VideoPost video) => _likeCounts[video.id] ?? video.likes;
  bool isLiked(VideoPost video) => _likedVideoIds.contains(video.id);
  bool isFavorite(VideoPost video) => _favoriteVideoIds.contains(video.id);

  Future<void> loadNextPage() async {
    initialLoading = true;
    loadError = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _discoverRepository.getVideos(),
        _forYouRepository.getVideos(),
        _favoritesRepository.getVideos(),
      ]);
      final allVideos = results.first;
      final storedLikes = await Future.wait(
        allVideos.map(
          (video) async => (
            video: video,
            count: await _preferences.getLikeCount(video),
            liked: await _preferences.isLiked(video),
          ),
        ),
      );

      _likeCounts
        ..clear()
        ..addEntries(
          storedLikes.map((state) => MapEntry(state.video.id, state.count)),
        );
      _likedVideoIds
        ..clear()
        ..addAll(
          storedLikes
              .where((state) => state.liked)
              .map((state) => state.video.id),
        );
      _favoriteVideoIds
        ..clear()
        ..addAll(await _preferences.getFavoriteIds());

      _discoverVideos = results[0];
      _forYouVideos = results[1];
      _favoritesVideos = results[2];
      initialLoading = false;
    } catch (error) {
      loadError = 'No se pudieron cargar los videos: $error';
      initialLoading = false;
    }
    notifyListeners();
  }

  Future<void> toggleLike(VideoPost video) async {
    final liked = !isLiked(video);
    final count = (likesFor(video) + (liked ? 1 : -1)).clamp(0, 0x7fffffff);
    try {
      await _preferences.saveLikeState(
        video: video,
        isLiked: liked,
        likeCount: count,
      );
      _likeCounts[video.id] = count;
      if (liked) {
        _likedVideoIds.add(video.id);
      } else {
        _likedVideoIds.remove(video.id);
      }
      actionError = null;
    } catch (error) {
      actionError = 'No se pudo guardar el me gusta: $error';
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(VideoPost video) async {
    final updatedIds = Set<String>.from(_favoriteVideoIds);
    if (!updatedIds.add(video.id)) {
      updatedIds.remove(video.id);
    }
    try {
      await _preferences.saveFavoriteIds(updatedIds);
      _favoriteVideoIds
        ..clear()
        ..addAll(updatedIds);
      _favoritesVideos = _discoverVideos
          .where((item) => _favoriteVideoIds.contains(item.id))
          .toList(growable: false);
      actionError = null;
    } catch (error) {
      actionError = 'No se pudo guardar el favorito: $error';
    }
    notifyListeners();
  }

  void clearActionError() {
    actionError = null;
    notifyListeners();
  }
}
