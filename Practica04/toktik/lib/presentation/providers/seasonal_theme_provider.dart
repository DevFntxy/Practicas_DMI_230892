import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/repositories/seasonal_theme_preferences_repository.dart';

class SeasonalThemeProvider extends ChangeNotifier {
  static const _launcherIconChannel = MethodChannel(
    'com.example.toktik/seasonal_launcher_icon',
  );

  final SeasonalThemePreferencesRepository preferences;
  final AudioPlayer _audioPlayer;

  DateTime? simulatedDate;
  SeasonalTheme activeTheme = SeasonalTheme.forDate(DateTime.now());
  String? audioError;
  String? launcherIconError;
  bool isReady = false;
  bool _isDisposed = false;

  SeasonalThemeProvider({required this.preferences, AudioPlayer? audioPlayer})
    : _audioPlayer = audioPlayer ?? AudioPlayer();

  DateTime get effectiveDate => simulatedDate ?? DateTime.now();

  Future<void> initialize() async {
    simulatedDate = preferences.simulatedDate;
    activeTheme = SeasonalTheme.forDate(effectiveDate);
    isReady = true;
    notifyListeners();
    unawaited(_updateLauncherIcon(activeTheme));
    unawaited(_playSeasonSound(activeTheme));
  }

  Future<void> setSimulatedDate(DateTime date) async {
    simulatedDate = DateTime(date.year, date.month, date.day);
    await preferences.saveSimulatedDate(simulatedDate);
    await _applyTheme(playSound: true);
  }

  Future<void> useDeviceDate() async {
    simulatedDate = null;
    await preferences.saveSimulatedDate(null);
    await _applyTheme(playSound: true);
  }

  Future<void> _applyTheme({required bool playSound}) async {
    final nextTheme = SeasonalTheme.forDate(effectiveDate);
    final changed = nextTheme.season != activeTheme.season;
    activeTheme = nextTheme;
    audioError = null;
    notifyListeners();
    unawaited(_updateLauncherIcon(nextTheme));

    if (playSound && changed) {
      unawaited(_playSeasonSound(nextTheme));
    }
  }

  Future<void> _updateLauncherIcon(SeasonalTheme theme) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;

    try {
      await _launcherIconChannel.invokeMethod<void>(
        'setSeasonalIcon',
        {'season': theme.season.name},
      );
      launcherIconError = null;
    } on PlatformException catch (error) {
      launcherIconError =
          'No se pudo actualizar el icono de temporada: ${error.message}';
      if (!_isDisposed) notifyListeners();
    } on MissingPluginException catch (error) {
      launcherIconError =
          'No se encontró el servicio para cambiar el icono: ${error.message}';
      if (!_isDisposed) notifyListeners();
    }
  }

  Future<void> _playSeasonSound(SeasonalTheme theme) async {
    try {
      await _playSeasonSoundNow(theme);
    } catch (error) {
      audioError = 'No se pudo reproducir el sonido de temporada: $error';
      if (!_isDisposed) notifyListeners();
    }
  }

  Future<void> _playSeasonSoundNow(SeasonalTheme theme) async {
    await _audioPlayer.stop();
    await _audioPlayer.setVolume(1);
    switch (theme.season) {
      case Season.halloween:
        await _audioPlayer.play(AssetSource('audios/Sonido risa malvada.mp3'));
        break;
      case Season.christmas:
        await _audioPlayer.play(AssetSource('audios/Sonido navidad.mp3'));
        break;
      case Season.valentines:
        await _audioPlayer.play(BytesSource(_makeJingle([523, 659, 784])));
        break;
      case Season.normal:
        await _audioPlayer.play(BytesSource(_makeJingle([392, 523, 392])));
        break;
    }
  }

  Uint8List _makeJingle(List<int> notes) {
    const sampleRate = 22050;
    const samplesPerNote = sampleRate ~/ 5;
    final sampleCount = samplesPerNote * notes.length;
    final data = ByteData(44 + sampleCount * 2);
    final byteData = data.buffer.asByteData();
    final bytes = data.buffer.asUint8List();

    void writeAscii(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        bytes[offset + i] = value.codeUnitAt(i);
      }
    }

    writeAscii(0, 'RIFF');
    byteData.setUint32(4, 36 + sampleCount * 2, Endian.little);
    writeAscii(8, 'WAVEfmt ');
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);
    byteData.setUint16(22, 1, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * 2, Endian.little);
    byteData.setUint16(32, 2, Endian.little);
    byteData.setUint16(34, 16, Endian.little);
    writeAscii(36, 'data');
    byteData.setUint32(40, sampleCount * 2, Endian.little);

    var sampleIndex = 0;
    for (final frequency in notes) {
      for (var i = 0; i < samplesPerNote; i++, sampleIndex++) {
        final fade = math
            .min(i / 300, (samplesPerNote - i) / 300)
            .clamp(0.0, 1.0);
        final sample =
            math.sin(2 * math.pi * frequency * i / sampleRate) * fade * 0.22;
        byteData.setInt16(
          44 + sampleIndex * 2,
          (sample * 32767).round(),
          Endian.little,
        );
      }
    }
    return bytes;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _audioPlayer.dispose();
    super.dispose();
  }
}
