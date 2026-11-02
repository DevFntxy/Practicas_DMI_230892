import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('es', 'MX'),
    Locale('en', 'US'),
    Locale('de', 'DE'),
    Locale('ko', 'KR'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get _isEnglish => locale.languageCode == 'en';
  bool get _isGerman => locale.languageCode == 'de';
  bool get _isKorean => locale.languageCode == 'ko';

  String _localized({
    required String spanish,
    required String english,
    required String german,
    required String korean,
  }) {
    if (_isEnglish) return english;
    if (_isGerman) return german;
    if (_isKorean) return korean;
    return spanish;
  }

  String get appName => 'Cinemapedia';
  String get settings => _localized(
    spanish: 'Configuración',
    english: 'Settings',
    german: 'Einstellungen',
    korean: '설정',
  );
  String get language => _localized(
    spanish: 'Idioma',
    english: 'Language',
    german: 'Sprache',
    korean: '언어',
  );
  String get chooseLanguage => _localized(
    spanish: 'Elige el idioma de la aplicación',
    english: 'Choose the language for the app',
    german: 'Wähle die Sprache der App',
    korean: '앱에서 사용할 언어를 선택하세요',
  );
  String get spanish => 'Español';
  String get english => 'English';
  String get german => 'Deutsch';
  String get korean => '한국어';
  String get mexico => _localized(
    spanish: 'México',
    english: 'Mexico',
    german: 'Mexiko',
    korean: '멕시코',
  );
  String get unitedStates => _localized(
    spanish: 'Estados Unidos',
    english: 'United States',
    german: 'Vereinigte Staaten',
    korean: '미국',
  );
  String get germany => _localized(
    spanish: 'Alemania',
    english: 'Germany',
    german: 'Deutschland',
    korean: '독일',
  );
  String get southKorea => _localized(
    spanish: 'Corea del Sur',
    english: 'South Korea',
    german: 'Südkorea',
    korean: '대한민국',
  );
  String get search => _localized(
    spanish: 'Buscar',
    english: 'Search',
    german: 'Suchen',
    korean: '검색',
  );
  String get home => _localized(
    spanish: 'Inicio',
    english: 'Home',
    german: 'Startseite',
    korean: '홈',
  );
  String get categories => _localized(
    spanish: 'Categorías',
    english: 'Categories',
    german: 'Kategorien',
    korean: '카테고리',
  );
  String get favorites => _localized(
    spanish: 'Favoritos',
    english: 'Favorites',
    german: 'Favoriten',
    korean: '즐겨찾기',
  );
  String get nowPlaying => _localized(
    spanish: 'En cines',
    english: 'Now playing',
    german: 'Im Kino',
    korean: '현재 상영작',
  );
  String get comingSoon => _localized(
    spanish: 'Próximamente',
    english: 'Coming soon',
    german: 'Demnächst',
    korean: '개봉 예정작',
  );
  String get thisMonth => _localized(
    spanish: 'En este mes',
    english: 'This month',
    german: 'Diesen Monat',
    korean: '이번 달',
  );
  String get monday20 => _localized(
    spanish: 'Lunes 20',
    english: 'Monday 20',
    german: 'Montag, 20.',
    korean: '월요일 20일',
  );
  String get popular => _localized(
    spanish: 'Populares',
    english: 'Popular',
    german: 'Beliebt',
    korean: '인기 작품',
  );
  String get topRated => _localized(
    spanish: 'Mejor calificadas',
    english: 'Top rated',
    german: 'Bestbewertet',
    korean: '평점 높은 작품',
  );
  String get allTime => _localized(
    spanish: 'Desde siempre',
    english: 'All time',
    german: 'Aller Zeiten',
    korean: '전체 기간',
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
