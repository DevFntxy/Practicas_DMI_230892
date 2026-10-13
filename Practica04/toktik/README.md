# TokTik

TokTik is a Flutter short-video feed with seasonal styling, persistent likes
and favorites, and Discover, For You, and Favorites sections.

## Run

From this directory:

```sh
flutter pub get
flutter run
```

At startup, the seasonal splash screen shows the corresponding logo and plays
the active theme sound. The video feeds begin loading after Discover opens.

The app needs internet access to play YouTube, Vimeo, and Dailymotion videos.
Web builds use each provider's official embedded player to avoid browser CORS
restrictions when resolving direct streams. Tap a video to reveal the app's
play/pause and volume controls; audio starts enabled and remains enabled until
you mute it. Browser autoplay policies may require that first tap before sound
can play.
The provider adapters live in `lib/infrastructure/datasources/`; feed and
preference contracts are in `lib/domain/`.

## Seasonal themes

The theme uses the device date: February 1–14 selects Valentine's Day, October
selects Halloween, December selects Christmas, and other dates use the normal
theme. The logo, palette, typography, and seasonal sound change with the theme.

Use the calendar icon in the app header to choose a simulated date. The date is
saved in local preferences and remains active after restarting the app. Choose
**Use device date** to remove the override. Available seasonal sound files are
under `assets/audios/`; normal and Valentine's Day play generated tone cues.

## Feeds and saved state

- Swipe vertically to move between videos and horizontally to switch feeds.
- Discover and For You include the eight bundled videos in `assets/videos/` and
  one video each from YouTube, Vimeo, and Dailymotion.
- For You orders the same available videos by engagement; Discover keeps the
  source order.
- Likes, like counts, and favorites are stored in device preferences.
- Expand long descriptions with **... más**; expanded text can be scrolled.
- Video audio starts enabled. Tap the video to reveal pause/play and mute
  controls.
