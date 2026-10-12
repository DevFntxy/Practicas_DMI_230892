import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final String description;
  final VideoSource source;
  final bool isActive;
  final bool isMuted;

  const FullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    this.description = '',
    required this.source,
    required this.isActive,
    required this.isMuted,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  VideoPlayerController? _directController;
  WebViewController? _webViewController;
  bool _directLoading = false;
  String? _playerError;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.source != widget.source) {
      final oldController = _directController;
      _directController = null;
      if (oldController != null) {
        unawaited(oldController.dispose());
      }
      _webViewController = null;
      _playerError = null;
      _initializePlayer();
      return;
    }

    if (widget.source == VideoSource.directMp4) {
      final controller = _directController;
      if (controller != null &&
          (oldWidget.isActive != widget.isActive ||
              oldWidget.isMuted != widget.isMuted)) {
        unawaited(_syncDirectVideo(controller));
      }
    } else if (oldWidget.isActive != widget.isActive ||
        oldWidget.isMuted != widget.isMuted) {
      _loadEmbeddedVideo();
    }
  }

  void _initializePlayer() {
    if (widget.source == VideoSource.directMp4) {
      _directLoading = true;
      unawaited(_initializeDirectVideo());
    } else {
      _directLoading = false;
      _loadEmbeddedVideo();
    }
  }

  Future<void> _initializeDirectVideo() async {
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null || !uri.hasScheme) {
      _setPlayerError('La URL del video MP4 no es válida.');
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);
    _directController = controller;
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(widget.isMuted ? 0 : 1);
      if (widget.isActive) {
        await controller.play();
      }
      if (!mounted || !identical(_directController, controller)) return;
      setState(() => _directLoading = false);
    } catch (error) {
      await controller.dispose();
      if (!mounted || !identical(_directController, controller)) return;
      _directController = null;
      setState(() {
        _directLoading = false;
        _playerError = 'No se pudo cargar el video MP4: $error';
      });
    }
  }

  Future<void> _syncDirectVideo(VideoPlayerController controller) async {
    if (!controller.value.isInitialized) return;
    try {
      await controller.setVolume(widget.isMuted ? 0 : 1);
      if (widget.isActive) {
        await controller.play();
      } else {
        await controller.pause();
      }
    } catch (error) {
      _setPlayerError('No se pudo actualizar la reproducción: $error');
    }
  }

  void _loadEmbeddedVideo() {
    final uri = _embeddedVideoUri(
      widget.videoUrl,
      isActive: widget.isActive,
      isMuted: widget.isMuted,
    );
    if (uri == null) {
      _webViewController = null;
      _playerError =
          'La URL debe corresponder a un video de Dailymotion o Vimeo.';
      return;
    }

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame != true) return;
            setState(() => _playerError = error.description);
          },
        ),
      )
      ..loadRequest(uri);
  }

  void _setPlayerError(String error) {
    if (!mounted) {
      _playerError = error;
      return;
    }
    setState(() => _playerError = error);
  }

  @override
  void dispose() {
    final controller = _directController;
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final directController = _directController;
    final webViewController = _webViewController;
    final player = switch (widget.source) {
      VideoSource.directMp4 => _buildDirectPlayer(directController),
      VideoSource.dailymotion || VideoSource.vimeo =>
        webViewController == null || _playerError != null
            ? _buildPlayerMessage()
            : WebViewWidget(controller: webViewController),
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        player,
        VideoBackground(stops: const [0.68, 1.0]),
        Positioned(
          bottom: 12,
          left: 16,
          child: _VideoCaption(
            caption: widget.caption,
            description: widget.description,
          ),
        ),
      ],
    );
  }

  Widget _buildDirectPlayer(VideoPlayerController? controller) {
    if (_playerError != null) return _buildPlayerMessage();
    if (controller == null ||
        _directLoading ||
        !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = controller.value.size;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(controller),
      ),
    );
  }

  Widget _buildPlayerMessage() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        _playerError ?? 'No se pudo cargar el video.',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Uri? _embeddedVideoUri(
  String url, {
  required bool isActive,
  required bool isMuted,
}) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  if (['dailymotion.com', 'www.dailymotion.com', 'dai.ly'].contains(uri.host)) {
    final videoIndex = uri.pathSegments.indexOf('video');
    final videoId = uri.host == 'dai.ly'
        ? uri.pathSegments.firstOrNull
        : videoIndex >= 0 && videoIndex + 1 < uri.pathSegments.length
        ? uri.pathSegments[videoIndex + 1]
        : null;
    if (videoId == null || !RegExp(r'^[A-Za-z0-9]+$').hasMatch(videoId)) {
      return null;
    }
    return Uri.https('www.dailymotion.com', '/embed/video/$videoId', {
      'autoplay': isActive ? '1' : '0',
      'mute': isMuted ? '1' : '0',
      'controls': '0',
    });
  }

  if (['vimeo.com', 'www.vimeo.com', 'player.vimeo.com'].contains(uri.host)) {
    final videoId = uri.pathSegments.lastOrNull;
    if (videoId == null || !RegExp(r'^\d+$').hasMatch(videoId)) return null;
    return Uri.https('player.vimeo.com', '/video/$videoId', {
      'autoplay': isActive ? '1' : '0',
      'muted': isMuted ? '1' : '0',
      'loop': '1',
      'title': '0',
      'byline': '0',
      'portrait': '0',
    });
  }
  return null;
}

class _VideoCaption extends StatefulWidget {
  const _VideoCaption({required this.caption, required this.description});

  final String caption;
  final String description;

  @override
  State<_VideoCaption> createState() => _VideoCaptionState();
}

class _VideoCaptionState extends State<_VideoCaption> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width * 0.66;
    final titleStyle = Theme.of(context).textTheme.titleMedium
        ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white);
    final descriptionStyle = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Colors.white);
    final descriptionPainter = TextPainter(
      text: TextSpan(text: widget.description, style: descriptionStyle),
      maxLines: 3,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: width);
    final hasMore = descriptionPainter.didExceedMaxLines;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          if (widget.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: _expanded ? 132 : 64),
              child: SingleChildScrollView(
                child: Text(
                  widget.description,
                  maxLines: _expanded ? null : 3,
                  overflow: _expanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: descriptionStyle,
                ),
              ),
            ),
            if (hasMore)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  foregroundColor: Colors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(_expanded ? 'menos' : '... más'),
              ),
          ],
        ],
      ),
    );
  }
}
