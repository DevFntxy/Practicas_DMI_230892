# Widgets App — Práctica 05

Aplicación de Flutter para explorar widgets de Material 3, controles de
interfaz, navegación y manejo de estado con Riverpod.

[Ver diagrama de arquitectura](https://devfntxy.github.io/Practicas_DMI_230892/Practica05/diagrama/diagrama_arquitectura.html)

La captura del menú principal muestra las pantallas disponibles en la aplicación:

<img src="caps/menuPrincipal.jpg" alt="Menú principal de Widgets App" width="320">

## Funcionalidades

La pantalla principal presenta un menú para abrir las siguientes demostraciones:

- **Riverpod Counter:** contador inicializado en 5, cuyo valor se incrementa
  mediante un botón flotante.

  <img src="caps/riverPodCounter.jpg" alt="Contador Riverpod con valor inicial de 5" width="320">

- **Botones:** ejemplos de botones Elevated, Filled, Outlined, Text e Icon, así
  como un botón personalizado.

  <img src="caps/ButtonsScreen.jpg" alt="Demostración de botones Material 3" width="320">

- **Tarjetas:** distintos estilos de `Card` con niveles de elevación de 0 a 5,
  contornos y superficies rellenas. Una variante carga imágenes desde Internet.

  <img src="caps/CardsScreen.jpg" alt="Tarjetas con distintos niveles de elevación e imágenes" width="320">

- **Indicadores de progreso:** indicador circular indeterminado y versiones
  circular y lineal con progreso animado.

  <img src="caps/ProgressIndicators.jpg" alt="Indicadores circular y lineal de progreso" width="320">

- **Snackbars y diálogos:** muestra una Snackbar, un diálogo de confirmación y
  el diálogo de licencias.

  <img src="caps/SnackBarsDialogos.jpg" alt="Pantalla de snackbars y diálogos" width="320">
  <img src="caps/SnakBardialogos2.jpg" alt="Diálogo de información y licencias" width="320">

- **Animated Container:** cambia aleatoriamente el tamaño, el color y el radio
  de las esquinas con una transición animada.

  <img src="caps/AnimetedCounainer1.jpg" alt="Animated Container con forma redondeada" width="320">
  <img src="caps/AnimateCountainer2.jpg" alt="Animated Container con otra forma y color" width="320">

- **UI Controls:** ejemplos de `SwitchListTile`, `ExpansionTile`,
  `RadioListTile` y `CheckboxListTile`.

  <img src="caps/uicontrols.jpg" alt="Controles de interfaz: switch, opciones y casillas" width="320">

- **Tutorial introductorio:** carrusel de tres páginas que permite salir o
  continuar al llegar al final.

  <img src="caps/Tutorial1.png" alt="Primera pantalla del tutorial introductorio" width="320">
  <img src="caps/Tutorial2.jpeg" alt="Segunda pantalla del tutorial introductorio" width="320">
  <img src="caps/Tutorial3.jpeg" alt="Tercera pantalla del tutorial introductorio" width="320">

- **Infinite Scroll y Pull to Refresh:** lista de imágenes que agrega elementos
  al desplazarse y se actualiza al arrastrar hacia abajo.

  <img src="caps/Screenshot_2026-10-23-11-32-47-913_com.example.widgets_app.jpg" alt="Lista de imágenes en la pantalla de desplazamiento infinito" width="320">

- **Cambiar tema:** selección de color y alternancia entre modo claro y oscuro.

  <img src="caps/CmbiartemaClaro.png" alt="Selector de tema en modo claro" width="320">
  <img src="caps/CambiarTemaVerde.png" alt="Selector de tema con color verde" width="320">
  <img src="caps/CambiarTemaObscuro.jpeg" alt="Selector de tema en modo oscuro" width="320">

## Tecnologías

- Flutter y Material 3
- `go_router` para la navegación entre pantallas
- `flutter_riverpod` para el estado del contador y del tema
- `animate_do` para animaciones del tutorial y la lista

El selector de tema mantiene su estado en memoria mientras la aplicación está
abierta. Las demostraciones de tarjetas y de desplazamiento infinito descargan
imágenes desde Internet.

## Estructura del proyecto

```text
lib/
├── config/
│   ├── menu/       # Elementos del menú principal
│   ├── router/     # Rutas de la aplicación
│   └── theme/      # Colores y configuración del tema
└── presentation/
    ├── providers/  # Estado con Riverpod
    ├── screens/    # Pantallas de las demostraciones
    └── widgets/    # Componentes compartidos
```

## Requisitos y ejecución

Se requiere tener instalado Flutter y un dispositivo o emulador disponible.
Desde la carpeta `Practica05/widgets_app`, ejecuta:

```sh
flutter pub get
flutter run
```

Para ejecutar las pruebas del proyecto:

```sh
flutter test
```
