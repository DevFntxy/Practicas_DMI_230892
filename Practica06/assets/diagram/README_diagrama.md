# Diagrama de arquitectura – Practica06

Aplicación analizada: `Practica06/cinemapedia`, Flutter/Dart. El diagrama interactivo está en [`diagrama_arquitectura.html`](diagrama_arquitectura.html); al seleccionar una tarjeta se muestran sus fuentes y los marcadores **SRC** permiten abrir el archivo en GitHub.

## Revisión y enlaces

El remoto configurado es [DevFntxy/Practicas_DMI_230892](https://github.com/DevFntxy/Practicas_DMI_230892). La rama local activa al generar el artefacto era `Practica06`; el HTML enlaza al commit verificado `ea3f78579de370558df1ab0ef7110db87cb7dc5c`, para que los enlaces no cambien si la rama avanza. Los 23 enlaces de fuente fueron comprobados contra ese commit localmente.

`lib/presentation/screens/movies/movie_screen.dart` tenía cambios locales sin commit durante el análisis. Por ello, su enlace Git muestra el archivo de la revisión indicada, que puede diferir de la copia de trabajo usada para describir la pantalla.

## Arquitectura representada

- **Presentación:** `main.dart` crea `ProviderScope` y configura `MaterialApp.router`, tema y localización. `app_router.dart` declara las rutas `/splash`, `/`, `/movie/:id` y `/settings/language`. Las pantallas principales son Splash, Home, Movie y Language Settings; Home compone widgets de listas, slideshow, navegación y sidebar.
- **Gestión de estado:** Riverpod (`flutter_riverpod`). Los providers de películas usan `StateNotifier` para paginar listas; providers adicionales exponen búsqueda, detalle, actores, carga inicial e idioma.
- **Lógica y contratos:** los contratos `MoviesRepository` y `ActorsRepository` separan las pantallas/providers de sus fuentes de datos. Sus implementaciones delegan en los data sources de infraestructura.
- **Datos:** `MoviedbDatasource` y `ActorMovieDbDatasource` usan Dio. Los mappers convierten los modelos de respuesta TMDB en las entidades `Movie` y `Actor`.
- **Servicio externo:** The Movie Database, REST sobre HTTPS (`https://api.themoviedb.org/3`). Se consultan listas de películas, detalle, búsqueda y créditos/reparto. La clave se lee mediante `flutter_dotenv` desde `.env` (`THE_MOVIEDB_KEY`).
- **Configuración:** `pubspec.yaml` declara `go_router`, `flutter_dotenv`, `dio`, `flutter_riverpod`, `card_swiper` y `animate_do`, además de Flutter localization.

## Plataformas

El proyecto incluye runners Flutter para Android (`android/app/src/main/kotlin/com/example/cinemapedia/MainActivity.kt`), iOS (`ios/Runner/AppDelegate.swift` y `ios/Runner/SceneDelegate.swift`), Web (`web/index.html`), Windows (`windows/runner/`), macOS (`macos/Runner/`) y Linux (`linux/runner/`). Se omiten del lienzo para mantener el foco en el flujo de la aplicación; no se identificó lógica de negocio nativa específica.

## Alcance observado

No se encontraron autenticación, base de datos local, persistencia remota propia ni un backend propio en los archivos revisados. La comunicación de datos identificada es con TMDB. La selección de idioma se conserva en estado Riverpod en memoria; no se observó almacenamiento persistente para esa preferencia.

## Archivos

- `diagrama_arquitectura.html`: visor Archify autocontenido con selección, enlaces Git, zoom, desplazamiento, temas y vistas guiadas.
- `diagrama_arquitectura.png`: captura estática del lienzo y su leyenda, exportada desde la captura del navegador a 1440 × 900.
- `diagrama_arquitectura.architecture.json`: especificación fuente del diagrama.
- `diagrama_arquitectura.visual-check.json`: evidencia de navegador asociada al SHA-256 del HTML.

## Validación

Archify `validate` y `deliver`: 9/9 verificaciones showcase, cero errores y cero advertencias. `visual-check` en Chrome pasó medidas de contención para 1440×900, 1600×1000, 1920×1080 y 2048×1320, en tema claro y oscuro para las capturas. El PNG es una imagen estática y no conserva la interactividad del HTML. La interfaz fija del visor Archify está en inglés; los textos propios del diagrama están en español.
