import 'package:flutter/widgets.dart';
import 'package:toktik/domain/entities/video_post.dart';

Widget buildProviderVideoEmbed({
  required String videoUrl,
  required VideoSource source,
  required bool isPaused,
  required bool isMuted,
  required int playbackRequest,
}) {
  throw UnsupportedError(
    'Provider iframe embeds are only available in a web browser.',
  );
}
