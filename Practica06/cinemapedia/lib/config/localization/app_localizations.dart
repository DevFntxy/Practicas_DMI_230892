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
    Locale('fr', 'FR'),
    Locale('ja', 'JP'),
    Locale('pt', 'BR'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get _isEnglish => locale.languageCode == 'en';
  bool get _isGerman => locale.languageCode == 'de';
  bool get _isKorean => locale.languageCode == 'ko';
  bool get _isFrench => locale.languageCode == 'fr';
  bool get _isJapanese => locale.languageCode == 'ja';
  bool get _isPortuguese => locale.languageCode == 'pt';

  String _localized({
    required String spanish,
    required String english,
    required String german,
    required String korean,
    required String french,
    required String japanese,
    required String portuguese,
  }) {
    if (_isEnglish) return english;
    if (_isGerman) return german;
    if (_isKorean) return korean;
    if (_isFrench) return french;
    if (_isJapanese) return japanese;
    if (_isPortuguese) return portuguese;
    return spanish;
  }

  String get appName => 'Cinemapedia';
  String get settings => _localized(
    spanish: 'Configuración',
    english: 'Settings',
    german: 'Einstellungen',
    korean: '설정',
    french: 'Paramètres',
    japanese: '設定',
    portuguese: 'Configurações',
  );
  String get language => _localized(
    spanish: 'Idioma',
    english: 'Language',
    german: 'Sprache',
    korean: '언어',
    french: 'Langue',
    japanese: '言語',
    portuguese: 'Idioma',
  );
  String get chooseLanguage => _localized(
    spanish: 'Elige el idioma de la aplicación',
    english: 'Choose the language for the app',
    german: 'Wähle die Sprache der App',
    korean: '앱에서 사용할 언어를 선택하세요',
    french: 'Choisissez la langue de l’application',
    japanese: 'アプリの言語を選択してください',
    portuguese: 'Escolha o idioma do aplicativo',
  );
  String get spanish => 'Español';
  String get english => 'English';
  String get german => 'Deutsch';
  String get korean => '한국어';
  String get french => 'Français';
  String get japanese => '日本語';
  String get portuguese => 'Português';
  String get mexico => _localized(
    spanish: 'México',
    english: 'Mexico',
    german: 'Mexiko',
    korean: '멕시코',
    french: 'Mexique',
    japanese: 'メキシコ',
    portuguese: 'México',
  );
  String get unitedStates => _localized(
    spanish: 'Estados Unidos',
    english: 'United States',
    german: 'Vereinigte Staaten',
    korean: '미국',
    french: 'États-Unis',
    japanese: 'アメリカ合衆国',
    portuguese: 'Estados Unidos',
  );
  String get germany => _localized(
    spanish: 'Alemania',
    english: 'Germany',
    german: 'Deutschland',
    korean: '독일',
    french: 'Allemagne',
    japanese: 'ドイツ',
    portuguese: 'Alemanha',
  );
  String get southKorea => _localized(
    spanish: 'Corea del Sur',
    english: 'South Korea',
    german: 'Südkorea',
    korean: '대한민국',
    french: 'Corée du Sud',
    japanese: '韓国',
    portuguese: 'Coreia do Sul',
  );
  String get france => _localized(
    spanish: 'Francia',
    english: 'France',
    german: 'Frankreich',
    korean: '프랑스',
    french: 'France',
    japanese: 'フランス',
    portuguese: 'França',
  );
  String get japan => _localized(
    spanish: 'Japón',
    english: 'Japan',
    german: 'Japan',
    korean: '일본',
    french: 'Japon',
    japanese: '日本',
    portuguese: 'Japão',
  );
  String get brazil => _localized(
    spanish: 'Brasil',
    english: 'Brazil',
    german: 'Brasilien',
    korean: '브라질',
    french: 'Brésil',
    japanese: 'ブラジル',
    portuguese: 'Brasil',
  );
  String get search => _localized(
    spanish: 'Buscar',
    english: 'Search',
    german: 'Suchen',
    korean: '검색',
    french: 'Rechercher',
    japanese: '検索',
    portuguese: 'Buscar',
  );
  String get home => _localized(
    spanish: 'Inicio',
    english: 'Home',
    german: 'Startseite',
    korean: '홈',
    french: 'Accueil',
    japanese: 'ホーム',
    portuguese: 'Início',
  );
  String get categories => _localized(
    spanish: 'Categorías',
    english: 'Categories',
    german: 'Kategorien',
    korean: '카테고리',
    french: 'Catégories',
    japanese: 'カテゴリー',
    portuguese: 'Categorias',
  );
  String get favorites => _localized(
    spanish: 'Favoritos',
    english: 'Favorites',
    german: 'Favoriten',
    korean: '즐겨찾기',
    french: 'Favoris',
    japanese: 'お気に入り',
    portuguese: 'Favoritos',
  );
  String get nowPlaying => _localized(
    spanish: 'En cines',
    english: 'Now playing',
    german: 'Im Kino',
    korean: '현재 상영작',
    french: 'À l’affiche',
    japanese: '上映中',
    portuguese: 'Em cartaz',
  );
  String get comingSoon => _localized(
    spanish: 'Próximamente',
    english: 'Coming soon',
    german: 'Demnächst',
    korean: '개봉 예정작',
    french: 'À venir',
    japanese: '近日公開',
    portuguese: 'Em breve',
  );
  String get thisMonth => _localized(
    spanish: 'En este mes',
    english: 'This month',
    german: 'Diesen Monat',
    korean: '이번 달',
    french: 'Ce mois-ci',
    japanese: '今月',
    portuguese: 'Este mês',
  );
  String get monday20 => _localized(
    spanish: 'Lunes 20',
    english: 'Monday 20',
    german: 'Montag, 20.',
    korean: '월요일 20일',
    french: 'Lundi 20',
    japanese: '月曜日 20日',
    portuguese: 'Segunda-feira, 20',
  );
  String get popular => _localized(
    spanish: 'Populares',
    english: 'Popular',
    german: 'Beliebt',
    korean: '인기 작품',
    french: 'Populaires',
    japanese: '人気作品',
    portuguese: 'Populares',
  );
  String get topRated => _localized(
    spanish: 'Mejor calificadas',
    english: 'Top rated',
    german: 'Bestbewertet',
    korean: '평점 높은 작품',
    french: 'Les mieux notés',
    japanese: '高評価',
    portuguese: 'Mais bem avaliados',
  );
  String get allTime => _localized(
    spanish: 'Desde siempre',
    english: 'All time',
    german: 'Aller Zeiten',
    korean: '전체 기간',
    french: 'De tous les temps',
    japanese: '歴代',
    portuguese: 'De todos os tempos',
  );
  String get pleaseWait => _localized(
    spanish: 'Espere por favor',
    english: 'Please wait',
    german: 'Bitte warten',
    korean: '잠시만 기다려 주세요',
    french: 'Veuillez patienter',
    japanese: 'お待ちください',
    portuguese: 'Aguarde, por favor',
  );
  String get loading => _localized(
    spanish: 'Cargando...',
    english: 'Loading...',
    german: 'Wird geladen...',
    korean: '불러오는 중...',
    french: 'Chargement...',
    japanese: '読み込み中...',
    portuguese: 'Carregando...',
  );

  List<String> get loadingMessages => switch (locale.languageCode) {
    'en' => const [
      'Loading movies',
      'Getting the popcorn',
      'Loading popular movies',
      'Calling my girlfriend',
      'Almost there...',
      'This is taking longer than expected :(',
    ],
    'de' => const [
      'Filme werden geladen',
      'Popcorn wird geholt',
      'Beliebte Filme werden geladen',
      'Ich rufe meine Freundin an',
      'Gleich geschafft...',
      'Das dauert länger als erwartet :(',
    ],
    'ko' => const [
      '영화를 불러오는 중',
      '팝콘을 준비하는 중',
      '인기 영화를 불러오는 중',
      '여자친구에게 전화하는 중',
      '거의 다 됐어요...',
      '예상보다 오래 걸리고 있어요 :(',
    ],
    'fr' => const [
      'Chargement des films',
      'Préparation du popcorn',
      'Chargement des films populaires',
      'J’appelle ma copine',
      'Presque terminé...',
      'Cela prend plus de temps que prévu :(',
    ],
    'ja' => const [
      '映画を読み込み中',
      'ポップコーンを用意中',
      '人気映画を読み込み中',
      '彼女に電話中',
      'もうすぐです...',
      '予想より時間がかかっています :(',
    ],
    'pt' => const [
      'Carregando filmes',
      'Preparando a pipoca',
      'Carregando filmes populares',
      'Ligando para minha namorada',
      'Quase lá...',
      'Está demorando mais do que o esperado :(',
    ],
    _ => const [
      'Cargando películas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'Llamando a mi novia',
      'Ya mero...',
      'Esto está tardando más de lo esperado :(',
    ],
  };
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
