# Práctica 03 - Yes No App

Aplicación Flutter que simula un chat con respuestas aleatorias de tipo sí/no/tal vez, mostrando un mensaje del bot y una imagen GIF relacionada.

## Descripción

Esta app consume la API pública de YesNo WTF para obtener una respuesta aleatoria y luego muestra el resultado en una interfaz tipo chat. El flujo principal es:

1. El usuario escribe un mensaje.
2. La app genera una respuesta automática.
3. Se consulta la API de `yesno.wtf`.
4. Se interpreta la respuesta.
5. Se muestra el texto en el chat junto con un GIF aleatorio o asociado a la respuesta.

## Funcionalidades

- Interfaz tipo chat con mensajes propios y del bot.
- Respuestas aleatorias: `yes`, `no` o `maybe`.
- Consumo de API con `Dio`.
- Manejo de estado con `Provider`.
- Visualización de GIFs desde URL web o assets locales.
- Estructura basada en arquitectura simple por capas.

## Stack tecnológico

- Flutter
- Dart
- Provider
- Dio
- Material Design
- API Yes/No de `yesno.wtf`

## Evidencia visual

Estas capturas muestran el comportamiento de la aplicación en ejecución:

<div align="center">
  <img src="assets/caps/Screenshot_2026-09-29-12-53-06-034_com.example.yes_no_app.jpg" alt="Pantalla 1" width="220" />
  <img src="assets/caps/Screenshot_2026-09-29-12-53-13-819_com.example.yes_no_app.jpg" alt="Pantalla 2" width="220" />
</div>

<div align="center">
  <img src="assets/caps/Screenshot_2026-09-29-12-53-37-064_com.example.yes_no_app.jpg" alt="Pantalla 3" width="220" />
  <img src="assets/caps/Screenshot_2026-09-29-12-54-23-769_com.example.yes_no_app.jpg" alt="Pantalla 4" width="220" />
</div>

## Estructura del proyecto

```text
lib/
├── config/
│   ├── helpers/
│   └── theme/
├── domain/
│   └── entities/
├── infrastructure/
│   ├── models/
│   └── repositories (si se extiende en el futuro)
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
├── main.dart
└── ...
```

## Archivos clave

- `lib/main.dart`: punto de entrada de la aplicación.
- `lib/config/helpers/get_yes_no_answer.dart`: servicio que llama a la API y obtiene la respuesta.
- `lib/infrastructure/models/yes_no_model.dart`: modelo que transforma la respuesta de la API.
- `lib/presentation/providers/chat_provider.dart`: lógica del chat.
- `lib/presentation/screens/chat/chat_screen.dart`: pantalla principal del chat.
- `lib/presentation/widgets/chat/her_message_dubble.dart`: visualización de mensajes del bot con GIF.

## Requisitos

- Flutter SDK instalado.
- Un emulador o dispositivo físico.
- Conexión a internet para consultar la API externa.

## Cómo ejecutar

Desde la raíz del proyecto:

```bash
flutter pub get
flutter run
```

Si quieres ejecutar una versión específica de dispositivo, puedes usar:

```bash
flutter devices
flutter run -d <device_id>
```

## Cómo funciona la lógica de la respuesta

El helper `GetYesNoAnswer` elige aleatoriamente una respuesta del conjunto:

```dart
['yes', 'yes', 'no', 'no', 'maybe']
```

Luego hace una petición a la API:

```dart
https://yesno.wtf/api?force=answer
```

La respuesta se convierte en un modelo `YesNoModel` y después se transforma en una entidad `Message`, que incluye:

- texto: `Sí`, `No` o `Tal Vez`
- `fromwho`: quién envió el mensaje
- `imageUrl`: URL del GIF relacionado

## Consideraciones

- La API de `yesno.wtf` puede variar en la estructura exacta de sus respuestas, por lo que conviene revisar la respuesta si se cambian versiones o endpoints.
- En la versión actual, los GIFs se manejan principalmente desde URLs web, y la vista los renderiza con `Image.network` cuando corresponde.
- La app está pensada como base para ampliar funcionalidad de chat, historial y más respuestas.

- Capturas adicionales:
  - Respuestas "Sí" y "Tal vez": [Screenshot_2026-09-28-14-53-15-256_com.example.yes_no_app.jpg](assets/caps-practica03/Screenshot_2026-09-28-14-53-15-256_com.example.yes_no_app.jpg)
  - Respuesta "No": [Screenshot_2026-09-28-14-53-20-067_com.example.yes_no_app.jpg](assets/caps-practica03/Screenshot_2026-09-28-14-53-20-067_com.example.yes_no_app.jpg)
