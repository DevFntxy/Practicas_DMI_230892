import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/domain/repositories/video_stream_repository.dart';
import 'package:toktik/infrastructure/datasources/dailymotion_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/vimeo_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/youtube_video_datasource.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/infrastructure/repositories/seasonal_theme_preferences_repository_impl.dart';
import 'package:toktik/infrastructure/repositories/video_stream_repository_impl.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/screens/splash/startup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = LocalPreferencesDatasource(
    await SharedPreferences.getInstance(),
  );
  runApp(MyApp(preferences: preferences));
}

class MyApp extends StatelessWidget {
  final LocalPreferencesDatasource preferences;

  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    final videoRepository = VideoPostsRepositoryImpl(
      dataSources: const [
        LocalVideoDatasource(),
        YouTubeVideoDatasource(),
        VimeoVideoDatasource(),
        DailymotionVideoDatasource(),
      ],
      preferences: preferences,
    );
    final themePreferencesRepository =
        SeasonalThemePreferencesRepositoryImpl(preferences);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DiscoverProvider(videosRepository: videoRepository),
        ),
        Provider<VideoStreamRepository>(
          create: (_) => VideoStreamRepositoryImpl(),
          dispose: (_, repository) => repository.dispose(),
        ),
        ChangeNotifierProvider(
          create: (_) => SeasonalThemeProvider(
            preferences: themePreferencesRepository,
          ),
        ),
      ],
      child: Consumer<SeasonalThemeProvider>(
        builder: (context, seasonalProvider, _) {
          return MaterialApp(
            title: 'TokTik',
            debugShowCheckedModeBanner: false,
            theme: AppTheme(seasonalProvider.activeTheme).getTheme(),
            home: const StartupScreen(),
          );
        },
      ),
    );
  }
}
