import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post.dart';

class VideoButtons extends StatelessWidget {
  final VideoPost video;
  final VoidCallback onLike;
  final VoidCallback onFavorite;

  const VideoButtons({
    super.key,
    required this.video,
    required this.onLike,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CustomIconButton(
          value: video.likes,
          color: video.isLiked ? Colors.redAccent : Colors.white,
          iconData: video.isLiked ? Icons.favorite : Icons.favorite_border,
          tooltip: video.isLiked ? 'Quitar me gusta' : 'Me gusta',
          onPressed: onLike,
        ),
        const SizedBox(height: 16),
        _CustomIconButton(
          value: video.views,
          iconData: Icons.remove_red_eye_outlined,
          tooltip: 'Visualizaciones',
        ),
        const SizedBox(height: 16),
        _CustomIconButton(
          value: 0,
          color: video.isFavorite ? Colors.amber : Colors.white,
          iconData: video.isFavorite ? Icons.bookmark : Icons.bookmark_border,
          tooltip: video.isFavorite ? 'Quitar de favoritos' : 'Guardar favorito',
          onPressed: onFavorite,
        ),
        const SizedBox(height: 16),
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: const _CustomIconButton(
            value: 0,
            iconData: Icons.play_circle_outline,
            tooltip: 'TokTik',
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color? color;
  final String tooltip;
  final VoidCallback? onPressed;

  const _CustomIconButton({
    required this.value,
    required this.iconData,
    required this.tooltip,
    this.color = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(iconData, color: color, size: 30),
        ),
        if (value > 0)
          Text(HumanFormats.humanReadableNumber(value.toDouble())),
      ],
    );
  }
}
