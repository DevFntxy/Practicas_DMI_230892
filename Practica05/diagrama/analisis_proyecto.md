# Análisis del proyecto — Widgets App

## Identidad y propósito

- **Paquete:** `widgets_app` (`pubspec.yaml`)
- **Versión declarada:** `0.1.0`
- **Descripción del README:** Práctica 05 para explorar widgets Material 3, navegación y manejo de estado con Riverpod.
- **Punto de entrada:** `lib/main.dart`

## Tecnologías y dependencias

| Paquete | Declaración | Uso observado |
|---|---:|---|
| Flutter SDK | SDK de Flutter | UI, Material y ejecución multiplataforma |
| Dart | `>=2.19.2 <3.0.0` | Lenguaje de la aplicación |
| `flutter_riverpod` | `^2.2.0` | Estado reactivo del contador y el tema |
| `go_router` | `^6.0.7` | Enrutamiento declarativo |
| `animate_do` | `^3.0.2` | Efectos en tutorial/lista y animación de carga |
| `flutter_lints` | `^2.0.0` (dev) | Reglas de análisis estático |
| `flutter_test` | SDK (dev) | Infraestructura de pruebas Flutter |

`uses-material-design: true`; el paquete declara `assets/images/` como assets Flutter.

## Estructura inspeccionada

```text
lib/
├── main.dart
├── config/
│   ├── menu/menu_items.dart
│   ├── router/app_router.dart
│   └── theme/app_theme.dart
└── presentation/
    ├── providers/{counter_provider,theme_provider}.dart
    ├── screens/
    │   ├── animated/animated_screen.dart
    │   ├── app_tutorial/app_tutorial_screen.dart
    │   ├── buttons/buttons_screen.dart
    │   ├── cards/cards_screen.dart
    │   ├── counter/counter_screen.dart
    │   ├── home/home_screen.dart
    │   ├── infinite_scroll/infinite_scroll_screen.dart
    │   ├── progress/progress_screen.dart
    │   ├── snackbar/snackbar_screen.dart
    │   ├── theme_changer/theme_changer_screen.dart
    │   ├── ui_controls/ui_controls_screen.dart
    │   └── screens.dart
    └── widgets/side_menu.dart
```

El repositorio también contiene scaffolding de Android, iOS, Web, Linux, macOS y Windows, `test/widget_test.dart`, capturas en `caps/` e imágenes locales en `assets/images/`.

## Pantallas, navegación y componentes

`app_router.dart` declara 11 rutas: `/` (inicio) y diez demostraciones: botones, tarjetas, progreso, SnackBars/diálogos, animación, controles UI, tutorial, scroll infinito, contador Riverpod y cambio de tema. La pantalla inicial genera el menú desde `appMenuItems`. `SideMenu` reutiliza el mismo catálogo como NavigationDrawer. También existen subcomponentes locales como `_CustomListTile`, `CustomButton`, variantes de tarjeta, `_Slide` y vistas internas.

## Administración del estado

- `counterProvider`: `StateProvider<int>` con valor inicial 5.
- `themeNotifierProvider`: `StateNotifierProvider<ThemeNotifier, AppTheme>`, cambios de modo claro/oscuro y color seleccionado.
- `colorListProvider`: expone la paleta definida en `app_theme.dart`.
- `isDarkmodeProvider` y `selectedColorProvider` están declarados en `theme_provider.dart`; el flujo actual del selector de tema usa `themeNotifierProvider`. `CounterScreen` todavía observa `isDarkmodeProvider`.
- Infinite Scroll y otros ejemplos mantienen variables en estado local de widgets. No hay BLoC, GetX ni Riverpod code generation.

## Datos, red y servicios

- No se identificaron modelos de datos de dominio, repositorios, servicios HTTP propios, API REST de negocio, backend, login, Firebase, base de datos ni persistencia local.
- `cards_screen.dart` solicita imágenes con `NetworkImage('https://picsum.photos/id/...')`.
- `infinite_scroll_screen.dart` también solicita imágenes de Picsum; la lista extiende IDs localmente en grupos de cinco y usa retardos artificiales para carga/refresh.
- `assets/images/jar-loading.gif` se usa como placeholder local de carga.

## Infraestructura y configuración

- Directorios de plataformas presentes: `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`.
- `analysis_options.yaml` configura el análisis Dart/Flutter.
- `pubspec.lock` fija las versiones resueltas localmente.
- No se encontró pipeline CI/CD ni despliegue de servicios backend en los archivos del proyecto inspeccionados.

## Limites del analisis

El analisis describe el codigo fuente y la configuracion registrados en la revision 407803242d3e47742de1e38454843770819b1f24 del repositorio. El HTML enlaza 20 rutas verificadas de componentes directamente a sus archivos en GitHub y fija los enlaces a ese commit para conservar la trazabilidad del analisis.
