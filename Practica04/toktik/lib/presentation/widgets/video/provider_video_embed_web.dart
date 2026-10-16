import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:web/web.dart' as web;

Widget buildProviderVideoEmbed({
  required String videoUrl,
  required VideoSource source,
  required bool isPaused,
  required bool isMuted,
  required int playbackRequest,
}) {
  return _ProviderVideoEmbed(
    videoUrl: videoUrl,
    source: source,
    isPaused: isPaused,
    isMuted: isMuted,
    playbackRequest: playbackRequest,
  );
}

class _ProviderVideoEmbed extends StatefulWidget {
  final String videoUrl;
  final VideoSource source;
  final bool isPaused;
  final bool isMuted;
  final int playbackRequest;

  const _ProviderVideoEmbed({
    required this.videoUrl,
    required this.source,
    required this.isPaused,
    required this.isMuted,
    required this.playbackRequest,
  });

  @override
  State<_ProviderVideoEmbed> createState() => _ProviderVideoEmbedState();
}

class _ProviderVideoEmbedState extends State<_ProviderVideoEmbed> {
  static int _nextViewId = 0;

  late final String _viewType;
  late final web.HTMLIFrameElement _iframe;

  @override
  void initState() {
    super.initState();
    _viewType = 'toktik-provider-video-${_nextViewId++}';
    _iframe = web.HTMLIFrameElement()
      ..src = _embedUrl()
      ..allow = 'autoplay; fullscreen; picture-in-picture; encrypted-media'
      ..allowFullscreen = true
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.pointerEvents = 'none';
    ui.platformViewRegistry.registerViewFactory(_viewType, (_) => _iframe);
  }

  @override
  void didUpdateWidget(covariant _ProviderVideoEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused ||
        oldWidget.isMuted != widget.isMuted ||
        oldWidget.playbackRequest != widget.playbackRequest) {
      _sendPlayerState();
    }
  }

  String _embedUrl() {
    final sourceUrl = Uri.parse(widget.videoUrl);
    final id = switch (widget.source) {
      VideoSource.youtube =>
        sourceUrl.queryParameters['v'] ??
            (sourceUrl.pathSegments.isEmpty ? '' : sourceUrl.pathSegments.last),
      VideoSource.vimeo || VideoSource.dailymotion =>
        sourceUrl.pathSegments.isEmpty ? '' : sourceUrl.pathSegments.last,
      VideoSource.local => '',
    };
    if (id.isEmpty) {
      throw FormatException(
        'No se pudo obtener el ID del video: ${widget.videoUrl}',
      );
    }

    final (host, path, parameters) = switch (widget.source) {
      VideoSource.youtube => (
        'www.youtube-nocookie.com',
        '/embed/$id',
        <String, String>{
          'autoplay': widget.isPaused ? '0' : '1',
          'controls': '0',
          'playsinline': '1',
          'mute': '0',
          'enablejsapi': '1',
          'origin': Uri.base.origin,
        },
      ),
      VideoSource.vimeo => (
        'player.vimeo.com',
        '/video/$id',
        <String, String>{
          'autoplay': widget.isPaused ? '0' : '1',
          'muted': '0',
          'controls': '0',
          'playsinline': '1',
          'api': '1',
        },
      ),
      VideoSource.dailymotion => (
        'www.dailymotion.com',
        '/embed/video/$id',
        <String, String>{
          'autoplay': widget.isPaused ? '0' : '1',
          'mute': '0',
          'controls': '0',
          'api': 'postMessage',
        },
      ),
      VideoSource.local => throw StateError(
        'Los videos locales no usan un reproductor embebido.',
      ),
    };
    return Uri.https(host, path, parameters).toString();
  }

  void _sendPlayerState() {
    final commands = switch (widget.source) {
      VideoSource.youtube => [
        {
          'event': 'command',
          'func': widget.isPaused ? 'pauseVideo' : 'playVideo',
          'args': <Object>[],
        },
        {
          'event': 'command',
          'func': widget.isMuted ? 'mute' : 'unMute',
          'args': <Object>[],
        },
      ],
      VideoSource.vimeo => [
        {'method': widget.isPaused ? 'pause' : 'play'},
        {
          'method': 'setVolume',
          'value': widget.isMuted ? 0 : 1,
        },
      ],
      VideoSource.dailymotion => [
        {'command': widget.isPaused ? 'pause' : 'play'},
        {
          'command': 'setVolume',
          'parameters': [widget.isMuted ? 0 : 1],
        },
      ],
      VideoSource.local => const <Map<String, Object>>[],
    };
    for (final command in commands) {
      _iframe.contentWindow?.postMessage(
        jsonEncode(command).toJS,
        '*'.toJS,
      );
    }
  }

  @override
  void dispose() {
    _iframe.contentWindow?.postMessage(
      jsonEncode({'command': 'pause'}).toJS,
      '*'.toJS,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
