import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class HerMessageDubble extends StatelessWidget {
  final Message message;
  const HerMessageDubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final time = TimeOfDay.fromDateTime(message.sentAt).format(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message.text, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        if (message.imageUrl != null) ...[
          const SizedBox(height: 5),
          _ImageBubble(message.imageUrl!),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final String assetPath;

  const _ImageBubble(this.assetPath);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        assetPath,
        width: size.width * 0.7,
        height: 150,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size.width * 0.7,
          height: 150,
          alignment: Alignment.center,
          color: Colors.black12,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_outlined),
              SizedBox(height: 6),
              Text('No se pudo cargar el GIF'),
            ],
          ),
        ),
      ),
    );
  }
}
