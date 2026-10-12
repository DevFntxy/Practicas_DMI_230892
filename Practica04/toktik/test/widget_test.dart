import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/screens/splash/seasonal_splash_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads videos from MP4, Dailymotion, and Vimeo', () async {
    final provider = DiscoverProvider();

    await provider.loadNextPage();

    expect(
      provider.videos.where((video) => video.source == VideoSource.directMp4),
      hasLength(1),
    );
    expect(
      provider.videos
          .singleWhere((video) => video.source == VideoSource.directMp4)
          .videoUrl
          .endsWith('.mp4'),
      isTrue,
    );
    expect(
      provider.videos.map((video) => video.source).toSet(),
      containsAll(VideoSource.values),
    );
    expect(provider.loadError, isNull);
  });

  test(
    'persists like changes and includes liked videos in Favorites',
    () async {
      final provider = DiscoverProvider();
      await provider.loadNextPage();
      final video = provider.videos.first;
      final initialLikes = provider.likesFor(video);

      await provider.toggleLike(video);
      await provider.toggleFavorite(video);

      final restoredProvider = DiscoverProvider();
      await restoredProvider.loadNextPage();

      expect(restoredProvider.likesFor(video), initialLikes + 1);
      expect(restoredProvider.isLiked(video), isTrue);
      expect(
        restoredProvider.favoritesVideos.map((favorite) => favorite.id),
        contains(video.id),
      );

      await restoredProvider.toggleLike(video);
      final updatedProvider = DiscoverProvider();
      await updatedProvider.loadNextPage();

      expect(updatedProvider.likesFor(video), initialLikes);
      expect(updatedProvider.isLiked(video), isFalse);
    },
  );

  test(
    'persists a manual seasonal theme and restores automatic mode',
    () async {
      final provider = SeasonalThemeProvider();
      await provider.initialize();

      await provider.setTheme(SeasonTheme.christmas);
      final restoredProvider = SeasonalThemeProvider();
      await restoredProvider.initialize();
      expect(restoredProvider.currentTheme, SeasonTheme.christmas);

      await restoredProvider.setTheme(null);
      expect(restoredProvider.manualTheme, isNull);
    },
  );

  testWidgets('shows the saved seasonal welcome screen', (tester) async {
    SharedPreferences.setMockInitialValues({
      'toktik.season_theme': 'christmas',
      'toktik.season_sounds_enabled': false,
    });

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SeasonalThemeProvider(),
        child: const MaterialApp(home: SeasonalSplashScreen()),
      ),
    );

    for (
      var attempt = 0;
      attempt < 10 && find.text('La magia de la Navidad').evaluate().isEmpty;
      attempt++
    ) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('La magia de la Navidad'), findsOneWidget);
    expect(find.text('Activar música'), findsOneWidget);
    expect(find.text('Entrar ahora'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
