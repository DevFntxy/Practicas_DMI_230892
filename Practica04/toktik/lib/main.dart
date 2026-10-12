import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/screens/splash/seasonal_splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider()..loadNextPage(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => SeasonalThemeProvider(),
        ),
      ],
      child: Consumer<SeasonalThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'TokTik',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().getTheme(themeProvider.currentTheme),
          home: const SeasonalSplashScreen(),
        ),
      ),
    );
  }
}
