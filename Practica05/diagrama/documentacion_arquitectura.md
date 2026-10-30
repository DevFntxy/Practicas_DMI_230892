# Documentación de arquitectura — Widgets App

## Resumen

Widgets App es una aplicación Flutter de demostración de componentes Material 3. Su arquitectura está centrada en presentación: `main.dart` crea el ámbito de Riverpod y `MaterialApp.router`; GoRouter resuelve las pantallas; las pantallas implementan localmente las interacciones. El estado compartido está limitado al contador y al tema.

## Capas y responsabilidades

### Presentación

- `lib/main.dart`: entrada de la aplicación, `ProviderScope`, `MainApp` y configuración de `MaterialApp.router`.
- `lib/config/router/app_router.dart`: rutas declarativas (`/`, `/buttons`, `/cards`, `/progress`, `/snackbars`, `/animated`, `/ui-controls`, `/tutorial`, `/infinite`, `/counter-river`, `/theme-changer`).
- `lib/config/menu/menu_items.dart`, `lib/presentation/screens/home/home_screen.dart` y `lib/presentation/widgets/side_menu.dart`: catálogo del menú, pantalla inicial y navegación mediante `context.push`.
- `lib/presentation/screens/`: demos de contador, botones, tarjetas, indicadores de progreso, SnackBars/diálogos, contenedor animado, controles, tutorial, scroll infinito y selector de tema.
- `lib/presentation/screens/screens.dart`: exportación agregada de las pantallas para el router.

### Estado y lógica de interfaz

- `lib/presentation/providers/counter_provider.dart`: `counterProvider`, `StateProvider<int>` inicializado en 5; `CounterScreen` observa e incrementa su estado.
- `lib/presentation/providers/theme_provider.dart`: `themeNotifierProvider` (`StateNotifierProvider`) gestiona el `AppTheme`; `ThemeNotifier` cambia modo y color.
- `lib/config/theme/app_theme.dart`: lista de colores, modelo inmutable `AppTheme`, `copyWith` y producción de `ThemeData` Material 3.
- El estado de pantallas como UI Controls, Animated Container, tutorial e Infinite Scroll reside en sus `StatefulWidget`/`State`; no hay casos de uso ni controladores de dominio separados.
- El provider legado `isDarkmodeProvider` también aparece en `CounterScreen`; no es el estado que `MainApp` observa para crear el tema global.

### Datos e integraciones

No hay capa de repositorios, modelos de dominio, base de datos, almacenamiento local, autenticación ni API de negocio implementados. `CardsScreen` y `InfiniteScrollScreen` construyen `NetworkImage` directamente con URLs `https://picsum.photos/...`; las imágenes son contenido externo de muestra, no un backend de la aplicación. Infinite Scroll agrega IDs localmente y simula espera con `Future.delayed`; no pagina desde un servidor. El placeholder de la lista se carga desde `assets/images/jar-loading.gif`.

### Infraestructura

El proyecto incluye scaffolding Flutter para Android, iOS, Web, Linux, macOS y Windows. `pubspec.yaml` declara Flutter/Dart, Material Design y los paquetes descritos en `analisis_proyecto.md`. No se observa configuración de CI/CD ni infraestructura de backend en la estructura inspeccionada.

## Flujo principal

1. `main()` ejecuta `runApp(ProviderScope(child: MainApp()))`.
2. `MainApp` lee `themeNotifierProvider` y configura `MaterialApp.router` con `appRouter` y el tema derivado de `AppTheme`.
3. GoRouter construye `HomeScreen` en `/`. El menú lee `appMenuItems` y navega usando `context.push(path)`.
4. Las pantallas muestran widgets Material; aquellas conectadas a Riverpod observan estado y leen sus notifiers para actualizarlo.
5. Las demos de tarjetas/scroll descargan imágenes directamente de Picsum por HTTPS. No hay intermediario de servicio o repositorio dentro de la app.

## Interacciones y límites

- **Navegación:** `HomeScreen`/`SideMenu` → GoRouter → pantallas.
- **Tema:** `ThemeChangerScreen` → `ThemeNotifier` → `AppTheme` → `MainApp` → `ThemeData`.
- **Contador:** `CounterScreen` → `counterProvider` (estado en memoria).
- **Imágenes:** `CardsScreen`/`InfiniteScrollScreen` → Picsum Photos (externo).
- **Persistencia:** inexistente; el estado se pierde al terminar el proceso.
- **Servicios de negocio/API/backend:** inexistentes.

## Visualización

`diagrama_arquitectura.html` es el artefacto Archify interactivo, con selección de componentes, controles de navegación/zoom, vistas y leyenda. El preset blueprint aporta el tratamiento técnico futurista. El contenido está en español; la interfaz fija del visor Archify permanece en inglés porque la versión disponible no ofrece locale español.


### Abrir el codigo fuente

Al seleccionar un componente en el diagrama, el panel de detalle muestra sus archivos relacionados como enlaces **Abrir en GitHub**. Cada vinculo apunta a la revision fijada 407803242d3e47742de1e38454843770819b1f24, para que el codigo abierto corresponda a la version usada en el analisis. Se verificaron 20 referencias de archivo contra esa revision local.
