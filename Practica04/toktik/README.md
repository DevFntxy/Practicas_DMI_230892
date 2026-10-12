# TokTik — Práctica 04

Aplicación Flutter de videos verticales con fuentes de video separadas,
persistencia local y temas visuales de temporada.

## Funcionalidades

- **Temas por temporada:** Normal, Halloween, Christmas y Valentine's Day. El
  modo automático elige según la fecha del dispositivo (octubre, diciembre y
  los primeros catorce días de febrero); desde el icono de temporada se puede
  fijar cualquier tema o volver a Automático. La selección se guarda mediante
  `SharedPreferences`. Cada tema define colores, iconografía, tipografía del
  sistema, una señal de audio y una música de inicio original guardada en
  `assets/audio/`.
- **Pantalla de inicio:** muestra una bienvenida animada con el tema activo al
  abrir la aplicación. Reproduce en bucle la música de esa temporada y entra al
  feed después de unos segundos; también permite activar/desactivar música o
  entrar inmediatamente. Si el navegador o dispositivo bloquea el audio
  automático, se puede activar desde el botón en pantalla.
- **Discover / For You / Favorites:** tres feeds con repositorios separados.
  Se cambia entre ellos deslizando horizontalmente o usando la navegación
  inferior; los videos avanzan verticalmente dentro de cada feed. For You ordena
  por visualizaciones y Favorites contiene los videos guardados con el icono de
  marcador.
- **Fuentes y reproducción:** los MP4 directos se reproducen con
  `video_player`; Vimeo y Dailymotion usan sus reproductores embebidos en
  `webview_flutter`. Cada fuente tiene su propio datasource y el catálogo las
  combina antes de que cada repositorio arme su feed. Las listas de ejemplo
  están en `lib/infrastructure/datasources/`; pueden reemplazarse por peticiones
  a las APIs correspondientes sin cambiar la presentación.
- **Me gusta persistente:** el corazón alterna su estado; al activarse suma uno
  y al desactivarse resta uno. Estado y conteo se almacenan por video en
  `SharedPreferences`.
- **Sonido y descripción:** el control de volumen silencia o activa el video.
  Las descripciones largas muestran `... más`; al expandirlas se pueden
  desplazar verticalmente. Los sonidos breves asociados a las acciones cambian
  según el tema y se pueden desactivar desde el icono de volumen superior.

## Ejecutar y probar

Desde `Practica04/toktik`:

```sh
flutter pub get
flutter run
flutter test
```
