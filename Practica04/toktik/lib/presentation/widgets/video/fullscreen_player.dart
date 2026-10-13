import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_stream_repository.dart';
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

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
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

  Future<void> _toggleMute() async {
    final muted = !widget.isMuted;
    if (widget.video.source == VideoSource.local ||
        widget.video.source == VideoSource.dailymotion) {
      await _videoController?.setVolume(muted ? 0 : 1);
    } else if (muted) {
      await _podController?.mute();
    } else {
      await _podController?.unMute();
    }
    if (mounted) widget.onMuteChanged(muted);
  }

  @override
  void dispose() {
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
            if (_videoController != null)
              GestureDetector(
                onTap: () {
                  final controller = _videoController!;
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                },
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
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
            Positioned(
              right: 16,
              bottom: 310,
              child: IconButton(
                tooltip: widget.isMuted ? 'Activar sonido' : 'Silenciar video',
                onPressed: _toggleMute,
                icon: Icon(
                  widget.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
