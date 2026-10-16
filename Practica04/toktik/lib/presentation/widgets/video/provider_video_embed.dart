import 'package:flutter/widgets.dart';
import 'package:toktik/domain/entities/video_post.dart';

import 'provider_video_embed_stub.dart'
    if (dart.library.html) 'provider_video_embed_web.dart'
    as platform;

class ProviderVideoEmbed extends StatelessWidget {
  final String videoUrl;
  final VideoSource source;
  final bool isPaused;
  final bool isMuted;
  final int playbackRequest;

  const ProviderVideoEmbed({
    super.key,
    required this.videoUrl,
    required this.source,
    required this.isPaused,
    required this.isMuted,
    required this.playbackRequest,
  });

  @override
  Widget build(BuildContext context) => platform.buildProviderVideoEmbed(
    videoUrl: videoUrl,
    source: source,
    isPaused: isPaused,
    isMuted: isMuted,
    playbackRequest: playbackRequest,
  );
}
