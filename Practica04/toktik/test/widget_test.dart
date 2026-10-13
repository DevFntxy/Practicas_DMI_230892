import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/domain/repositories/seasonal_theme_preferences_repository.dart';
import 'package:toktik/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:toktik/infrastructure/datasources/dailymotion_stream_resolver.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/dailymotion_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/vimeo_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/youtube_video_datasource.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';
import 'package:toktik/presentation/screens/splash/startup_screen.dart';

void main() {
  group('SeasonalTheme.forDate', () {
    test('selects each seasonal theme and the normal fallback', () {
      expect(
        SeasonalTheme.forDate(DateTime(2026, 2, 14)).season,
        Season.valentines,
      );
      expect(
        SeasonalTheme.forDate(DateTime(2026, 10, 31)).season,
        Season.halloween,
      );
      expect(
        SeasonalTheme.forDate(DateTime(2026, 12, 25)).season,
        Season.christmas,
      );
      expect(SeasonalTheme.forDate(DateTime(2026, 3, 1)).season, Season.normal);
    });
  });

  group('video preferences', () {
    late VideoPostRepository repository;
    late LocalPreferencesDatasource preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = LocalPreferencesDatasource(
        await SharedPreferences.getInstance(),
      );
      repository = VideoPostsRepositoryImpl(
        dataSources: [
          _FakeVideoDatasource(VideoSource.local),
          _FakeVideoDatasource(VideoSource.youtube),
          _FakeVideoDatasource(VideoSource.vimeo),
          _FakeVideoDatasource(VideoSource.dailymotion),
        ],
        preferences: preferences,
      );
    });

    test('feeds select their own provider sets', () async {
      final discover = await repository.getVideos(VideoFeed.discover);
      final forYou = await repository.getVideos(VideoFeed.forYou);

      expect(discover.map((video) => video.source).toSet(), {
        VideoSource.youtube,
        VideoSource.vimeo,
        VideoSource.dailymotion,
        VideoSource.local,
      });
      expect(forYou, hasLength(4));
    });

    test('loads every bundled video asset into local feed posts', () async {
      final videos = await const LocalVideoDatasource().getVideos();

      expect(videos, hasLength(8));
      expect(
        videos.every((video) => video.source == VideoSource.local),
        isTrue,
      );
      expect(
        videos.map((video) => video.videoUrl),
        contains('assets/videos/1.mp4'),
      );
    });

    test(
      'Discover combines local assets with one post from each provider',
      () async {
        SharedPreferences.setMockInitialValues({});
        final repository = VideoPostsRepositoryImpl(
          dataSources: const [
            LocalVideoDatasource(),
            YouTubeVideoDatasource(),
            VimeoVideoDatasource(),
            DailymotionVideoDatasource(),
          ],
          preferences: LocalPreferencesDatasource(
            await SharedPreferences.getInstance(),
          ),
        );

        final posts = await repository.getVideos(VideoFeed.discover);
        expect(posts, hasLength(11));
        expect(
          posts.where((post) => post.source == VideoSource.local),
          hasLength(8),
        );
        for (final source in [
          VideoSource.youtube,
          VideoSource.vimeo,
          VideoSource.dailymotion,
        ]) {
          expect(posts.where((post) => post.source == source), hasLength(1));
        }
      },
    );

    test('persists like state and increments/decrements the count', () async {
      final original = (await repository.getVideos(VideoFeed.discover)).first;

      final liked = await repository.toggleLike(original);
      expect(liked.isLiked, isTrue);
      expect(liked.likes, original.likes + 1);

      final restored = (await repository.getVideos(VideoFeed.discover)).first;
      expect(restored.isLiked, isTrue);
      expect(restored.likes, original.likes + 1);

      final unliked = await repository.toggleLike(restored);
      expect(unliked.isLiked, isFalse);
      expect(unliked.likes, original.likes);
    });

    test(
      'adds and removes videos from the persistent favorites feed',
      () async {
        final video = (await repository.getVideos(VideoFeed.discover)).first;

        await repository.toggleFavorite(video);
        expect(await repository.getVideos(VideoFeed.favorites), hasLength(1));

        final favorite = (await repository.getVideos(VideoFeed.favorites))
            .first;
        await repository.toggleFavorite(favorite);
        expect(await repository.getVideos(VideoFeed.favorites), isEmpty);
      },
    );

    test('persists a simulated date and clears the override', () async {
      final date = DateTime(2026, 10, 31);
      await preferences.setSimulatedDate(date);
      expect(preferences.simulatedDate, date);

      await preferences.setSimulatedDate(null);
      expect(preferences.simulatedDate, isNull);
    });
  });

  test(
    'resolves a playable Dailymotion stream from provider metadata',
    () async {
      late Uri requestedUri;
      final resolver = DailymotionStreamResolver(
        client: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            jsonEncode({
              'qualities': {
                'auto': [
                  {'url': 'https://cdn.example/video.m3u8'},
                ],
              },
            }),
            200,
          );
        }),
      );

      final stream = await resolver.resolve(
        'https://www.dailymotion.com/video/x123',
      );
      resolver.close();

      expect(requestedUri.path, '/player/metadata/video/x123');
      expect(stream, Uri.parse('https://cdn.example/video.m3u8'));
    },
  );

  testWidgets('startup leaves the loading screen and opens Discover', (
    tester,
  ) async {
    final videoRepository = _BlockingVideoRepository();
    final discoverProvider = DiscoverProvider(
      videosRepository: videoRepository,
    );
    final themeProvider = SeasonalThemeProvider(
      preferences: _FakeThemePreferences(),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: discoverProvider),
          ChangeNotifierProvider.value(value: themeProvider),
        ],
        child: const MaterialApp(home: StartupScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(StartupScreen), findsNothing);
    expect(find.byType(DiscoverScreen), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(videoRepository.requestsStarted.isCompleted, isTrue);

    videoRepository.complete([]);
    await tester.pump();
  });
}

class _FakeThemePreferences implements SeasonalThemePreferencesRepository {
  @override
  DateTime? simulatedDate;

  @override
  Future<void> saveSimulatedDate(DateTime? date) async {
    simulatedDate = date;
  }
}

class _BlockingVideoRepository implements VideoPostRepository {
  final requestsStarted = Completer<void>();
  final _result = Completer<List<VideoPost>>();

  void complete(List<VideoPost> videos) => _result.complete(videos);

  @override
  Future<List<VideoPost>> getVideos(VideoFeed feed) {
    if (!requestsStarted.isCompleted) requestsStarted.complete();
    return _result.future;
  }

  @override
  Future<VideoPost> toggleFavorite(VideoPost video) async => video;

  @override
  Future<VideoPost> toggleLike(VideoPost video) async => video;
}

class _FakeVideoDatasource implements VideoPostDatasource {
  @override
  final VideoSource source;

  const _FakeVideoDatasource(this.source);

  @override
  Future<List<VideoPost>> getVideos() async => [
    VideoPost(
      id: '${source.name}:test',
      caption: 'Test video',
      description: 'A test video description.',
      author: '@test',
      videoUrl: 'https://example.com/video',
      source: source,
      likes: 10,
      views: 100,
    ),
  ];
}
