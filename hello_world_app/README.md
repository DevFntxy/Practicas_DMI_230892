# Hello World App

Una aplicación Flutter simple para practicar el uso de widgets, estado y lógica de contador.

## Descripción

Este proyecto representa una app base de Flutter con una pantalla principal donde el usuario puede:

- incrementar el contador
- reiniciarlo a cero
- disminuir el valor
- observar cambios de color según el estado del número

La aplicación sirve como ejemplo de estructura básica de Flutter, organización por carpetas y manejo de estado con `setState()`.

## Tecnologías

- Flutter
- Dart
- Material Design

## Estructura del proyecto

```text
hello_world_app/
├── android/            # configuración de Android
├── ios/                # configuración de iOS
├── lib/                # código fuente principal
│   ├── main.dart
│   └── presentation/
│       └── screens/
│           └── counter/
│               ├── counter_screen.dart
│               └── counter_functions_screen.dart
├── test/               # pruebas
├── web/                # configuración web
├── windows/            # configuración Windows
├── linux/              # configuración Linux
├── macos/              # configuración macOS
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
└── ...
```

## Requisitos

- Flutter SDK instalado
- Editor compatible: VS Code o Android Studio
- Dispositivo emulador o dispositivo físico

## Instalación y ejecución

1. Clona el proyecto o entra a la carpeta.
2. Asegúrate de tener Flutter instalado y configurado.
3. Ejecuta:

```bash
flutter pub get
flutter run
```

## Funcionalidades principales

- contador con valor inicial en cero
- botones para sumar, restablecer y restar
- cambio de color del número:
  - positivo: verde
  - negativo: rojo
  - cero: azul
- interfaz organizada por componentes y pantallas

## Diagrama del proyecto

Puedes consultar el diagrama del proyecto y su contexto visual en la siguiente ruta:

- [Diagrama interactivo](./diagrams/counter_context_diagram.html)

## Sitio del diagrama

Agrega aquí el enlace del sitio o despliegue del diagrama, por ejemplo:

```text
https://tu-sitio.com/diagrama-counter-app
```


