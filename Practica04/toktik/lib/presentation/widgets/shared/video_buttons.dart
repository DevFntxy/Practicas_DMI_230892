import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post.dart';

class VideoButtons extends StatelessWidget {
  const VideoButtons({
    required this.video,
    required this.likeCount,
    required this.isLiked,
    required this.isFavorite,
    required this.isMuted,
    required this.onLikePressed,
    required this.onFavoritePressed,
    required this.onMutePressed,
    super.key,
  });

  final VideoPost video;
  final int likeCount;
  final bool isLiked;
  final bool isFavorite;
  final bool isMuted;
  final VoidCallback onLikePressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onMutePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CustomIconButton(
          value: likeCount,
          iconData: isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.white,
          tooltip: isLiked ? 'Quitar me gusta' : 'Me gusta',
          onPressed: onLikePressed,
        ),
        const SizedBox(height: 14),
        _CustomIconButton(
          value: video.views,
          iconData: Icons.remove_red_eye_outlined,
          tooltip: 'Visualizaciones',
        ),
        const SizedBox(height: 14),
        _CustomIconButton(
          iconData: isFavorite ? Icons.bookmark : Icons.bookmark_border,
          color: isFavorite
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
          onPressed: onFavoritePressed,
        ),
        const SizedBox(height: 14),
        _CustomIconButton(
          iconData: isMuted ? Icons.volume_off : Icons.volume_up,
          tooltip: isMuted ? 'Activar sonido' : 'Silenciar video',
          onPressed: onMutePressed,
        ),
        const SizedBox(height: 14),
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: const _CustomIconButton(
            iconData: Icons.play_circle_outline,
            tooltip: 'Reproducción en curso',
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  const _CustomIconButton({
    required this.iconData,
    required this.tooltip,
    this.value,
    this.color = Colors.white,
    this.onPressed,
  });

  final int? value;
  final IconData iconData;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(iconData, color: color, size: 30),
        ),
        if (value != null && value! > 0)
          Text(HumanFormats.humanReadbleNumber(value!.toDouble())),
      ],
    );
  }
}
