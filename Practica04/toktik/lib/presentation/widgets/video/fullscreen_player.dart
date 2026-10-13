import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_stream_repository.dart';
import 'package:toktik/presentation/widgets/video/provider_video_embed.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';

class FullScreenPlayer extends StatefulWidget {
  final VideoPost video;
  final bool isMuted;
  final ValueChanged<bool> onMuteChanged;

  const FullScreenPlayer({
    super.key,
    required this.video,
    required this.isMuted,
    required this.onMuteChanged,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late Future<void> _initialization;
  PodPlayerController? _podController;
  VideoPlayerController? _videoController;
  Timer? _controlsHideTimer;
  bool _areControlsVisible = false;
  bool _isPlaying = true;
  int _playbackRequest = 0;

  @override
  void initState() {
    super.initState();
    _isPlaying = true;
    _initialization = _initialize();
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMuted != widget.isMuted) {
      unawaited(_applyMute(widget.isMuted));
    }
  }

  Future<void> _initialize() async {
    if (kIsWeb && widget.video.source != VideoSource.local) return;

    if (widget.video.source == VideoSource.local) {
      final controller = VideoPlayerController.asset(widget.video.videoUrl);
      _videoController = controller;
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(widget.isMuted ? 0 : 1);
      await controller.play();
      return;
    }

    if (widget.video.source == VideoSource.dailymotion) {
      final streamUrl = await context
          .read<VideoStreamRepository>()
          .resolveStream(widget.video);
      if (!mounted) return;
      final controller = VideoPlayerController.networkUrl(streamUrl);
      _videoController = controller;
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(widget.isMuted ? 0 : 1);
      await controller.play();
      return;
    }

    final playVideoFrom = switch (widget.video.source) {
      VideoSource.local => throw StateError(
          'Los videos locales se reproducen mediante VideoPlayer.',
        ),
      VideoSource.youtube => PlayVideoFrom.youtube(widget.video.videoUrl),
      VideoSource.vimeo => PlayVideoFrom.vimeo(
        _vimeoVideoId(widget.video.videoUrl),
      ),
      VideoSource.dailymotion => throw StateError(
        'Dailymotion se reproduce mediante su transmisión directa.',
      ),
    };
    final controller = PodPlayerController(
      playVideoFrom: playVideoFrom,
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: true,
        isLooping: true,
        videoQualityPriority: [720, 480, 360],
      ),
    );
    _podController = controller;
    await controller.initialise();
    if (widget.isMuted) await controller.mute();
  }

  String _vimeoVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.pathSegments.isEmpty) {
      throw const FormatException('La URL de Vimeo no contiene un ID.');
    }
    return uri.pathSegments.last;
  }

  Future<void> _togglePlayback() async {
    try {
      final shouldPlay = !_isPlaying;
      final videoController = _videoController;
      if (videoController != null) {
        if (shouldPlay) {
          await videoController.play();
        } else {
          await videoController.pause();
        }
        if (mounted) setState(() => _isPlaying = shouldPlay);
        return;
      }

      final podController = _podController;
      if (kIsWeb && widget.video.source != VideoSource.local) {
        setState(() => _isPlaying = shouldPlay);
        return;
      }
      if (podController == null) return;
      if (shouldPlay) {
        podController.play();
      } else {
        podController.pause();
      }
      if (mounted) setState(() => _isPlaying = shouldPlay);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cambiar la reproducción: $error')),
      );
    }
  }

  Future<void> _applyMute(bool isMuted) async {
    try {
      final videoController = _videoController;
      if (videoController != null) {
        await videoController.setVolume(isMuted ? 0 : 1);
      } else if (_podController case final controller?) {
        if (isMuted) await controller.mute();
        if (!isMuted) await controller.unMute();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cambiar el audio: $error')),
      );
    }
  }

  void _showControls() {
    _controlsHideTimer?.cancel();
    setState(() {
      _areControlsVisible = true;
      _playbackRequest++;
    });

    final controller = _videoController;
    if (_isPlaying && controller != null && !controller.value.isPlaying) {
      controller.play();
    }

    _controlsHideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _areControlsVisible = false);
    });
  }

  @override
  void dispose() {
    _controlsHideTimer?.cancel();
    _podController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No se pudo reproducir este video.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            if (kIsWeb && widget.video.source != VideoSource.local)
              ProviderVideoEmbed(
                videoUrl: widget.video.videoUrl,
                source: widget.video.source,
                isPaused: !_isPlaying,
                isMuted: widget.isMuted,
                playbackRequest: _playbackRequest,
              )
            else if (_videoController != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              )
            else
              PodVideoPlayer(
                controller: _podController!,
                frameAspectRatio: 9 / 16,
                videoAspectRatio: 16 / 9,
                matchFrameAspectRatioToVideo: false,
                alwaysShowProgressBar: false,
              ),
            VideoBackground(stops: const [0.35, 1.0]),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _showControls,
              child: SizedBox.expand(
                child: _areControlsVisible
                    ? Stack(
                        children: [
                          Center(
                            child: _PlayerControlButton(
                              tooltip: _isPlaying
                                  ? 'Pausar video'
                                  : 'Reproducir video',
                              icon: _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 66,
                              onPressed: _togglePlayback,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.expand(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayerControlButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const _PlayerControlButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.58),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        iconSize: size * 0.55,
        padding: EdgeInsets.all(size * 0.22),
        constraints: BoxConstraints.tightFor(width: size, height: size),
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
