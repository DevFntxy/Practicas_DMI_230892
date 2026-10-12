import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/season_theme.dart';

class SeasonalThemeProvider extends ChangeNotifier {
  static const _themeKey = 'toktik.season_theme';
  static const _soundKey = 'toktik.season_sounds_enabled';

  SeasonTheme? _manualTheme;
  bool _soundsEnabled = true;
  AudioPlayer? _audioPlayer;
  bool _themeMusicIsPlaying = false;
  String? soundError;

  SeasonTheme get currentTheme => _manualTheme ?? _themeForDate(DateTime.now());
  SeasonTheme? get manualTheme => _manualTheme;
  bool get soundsEnabled => _soundsEnabled;
  bool get isThemeMusicPlaying => _themeMusicIsPlaying;

  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final savedTheme = preferences.getString(_themeKey);
    _manualTheme = SeasonTheme.values
        .where((theme) => theme.name == savedTheme)
        .firstOrNull;
    _soundsEnabled = preferences.getBool(_soundKey) ?? true;
    notifyListeners();
  }

  Future<void> setTheme(SeasonTheme? theme) async {
    final preferences = await SharedPreferences.getInstance();
    if (theme == null) {
      await preferences.remove(_themeKey);
    } else {
      await preferences.setString(_themeKey, theme.name);
    }
    _manualTheme = theme;
    notifyListeners();
  }

  Future<void> setSoundsEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundKey, enabled);
    _soundsEnabled = enabled;
    if (!enabled) {
      await stopThemeMusic();
    }
    notifyListeners();
  }

  Future<void> playThemeMusic() async {
    if (!_soundsEnabled) return;
    final musicAsset = switch (currentTheme) {
      SeasonTheme.normal => 'audio/music_normal.wav',
      SeasonTheme.halloween => 'audio/music_halloween.wav',
      SeasonTheme.christmas => 'audio/music_christmas.wav',
      SeasonTheme.valentines => 'audio/music_valentines.wav',
    };
    try {
      final player = _audioPlayer ??= AudioPlayer();
      await player.stop();
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource(musicAsset));
      _themeMusicIsPlaying = true;
      soundError = null;
    } catch (error) {
      _themeMusicIsPlaying = false;
      soundError = 'No se pudo reproducir la música de inicio: $error';
    }
    notifyListeners();
  }

  Future<void> stopThemeMusic() async {
    if (!_themeMusicIsPlaying) return;
    final player = _audioPlayer;
    if (player == null) return;
    try {
      await player.stop();
      _themeMusicIsPlaying = false;
    } catch (error) {
      soundError = 'No se pudo detener la música de inicio: $error';
    }
    notifyListeners();
  }

  Future<void> playThemeSound() async {
    if (!_soundsEnabled) return;
    final soundAsset = switch (currentTheme) {
      SeasonTheme.normal => 'audio/theme_normal.wav',
      SeasonTheme.halloween => 'audio/theme_halloween.wav',
      SeasonTheme.christmas => 'audio/theme_christmas.wav',
      SeasonTheme.valentines => 'audio/theme_valentines.wav',
    };
    try {
      final player = _audioPlayer ??= AudioPlayer();
      if (_themeMusicIsPlaying) {
        await player.stop();
        _themeMusicIsPlaying = false;
      }
      await player.setReleaseMode(ReleaseMode.release);
      await player.play(AssetSource(soundAsset));
      soundError = null;
    } catch (error) {
      soundError = 'No se pudo reproducir el sonido de temporada: $error';
    }
    notifyListeners();
  }

  void clearSoundError() {
    soundError = null;
    notifyListeners();
  }

  static SeasonTheme _themeForDate(DateTime date) {
    if (date.month == DateTime.october) return SeasonTheme.halloween;
    if (date.month == DateTime.december) return SeasonTheme.christmas;
    if (date.month == DateTime.february && date.day <= 14) {
      return SeasonTheme.valentines;
    }
    return SeasonTheme.normal;
  }

  @override
  void dispose() {
    final player = _audioPlayer;
    if (player != null) {
      unawaited(player.dispose());
    }
    super.dispose();
  }
}
