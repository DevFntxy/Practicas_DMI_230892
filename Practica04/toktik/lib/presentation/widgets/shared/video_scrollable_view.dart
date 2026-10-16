import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:toktik/presentation/widgets/video/fullscreen_player.dart';

class VideoScrollableView extends StatefulWidget {
  final VideoFeed feed;

  const VideoScrollableView({super.key, required this.feed});

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DiscoverProvider>().loadFeed(widget.feed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscoverProvider>();
    if (provider.isLoading(widget.feed)) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final error = provider.errors[widget.feed];
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(error, textAlign: TextAlign.center),
            ),
            FilledButton(
              onPressed: () =>
                  provider.loadFeed(widget.feed, force: true),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final videos = provider.videosFor(widget.feed);
    if (videos.isEmpty) {
      return Center(
        child: Text(
          widget.feed == VideoFeed.favorites
              ? 'Aún no tienes videos favoritos.'
              : 'No hay videos disponibles en este momento.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) => _VideoPage(
        key: ValueKey(videos[index].id),
        video: videos[index],
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  final VideoPost video;

  const _VideoPage({super.key, required this.video});

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  bool _isDescriptionExpanded = false;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DiscoverProvider>();
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        FullScreenPlayer(
          video: widget.video,
          isMuted: _isMuted,
          onMuteChanged: (isMuted) => setState(() => _isMuted = isMuted),
        ),
        Positioned(
          left: 16,
          right: 92,
          bottom: 32,
          child: _VideoDescription(
            video: widget.video,
            isExpanded: _isDescriptionExpanded,
            onToggle: () => setState(
              () => _isDescriptionExpanded = !_isDescriptionExpanded,
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: VideoButtons(
                video: widget.video,
                isMuted: _isMuted,
                onToggleMute: () => setState(() => _isMuted = !_isMuted),
                onLike: () => _runMutation(
                  context,
                  () => provider.toggleLike(widget.video),
                ),
                onFavorite: () => _runMutation(
                  context,
                  () => provider.toggleFavorite(widget.video),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 76,
          left: 16,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    switch (widget.video.source) {
                      VideoSource.local => Icons.video_library_outlined,
                      VideoSource.youtube => Icons.smart_display_outlined,
                      VideoSource.vimeo => Icons.play_circle_outline,
                      VideoSource.dailymotion => Icons.movie_outlined,
                    },
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.video.source.name.toUpperCase(),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runMutation(
    BuildContext context,
    Future<void> Function() mutation,
  ) async {
    try {
      await mutation();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el cambio: $error')),
      );
    }
  }
}

class _VideoDescription extends StatelessWidget {
  final VideoPost video;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _VideoDescription({
    required this.video,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final needsExpansion = video.description.length > 100;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.72),
            Colors.black.withValues(alpha: 0.36),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              video.caption,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              video.author,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            if (isExpanded)
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  child: Text(
                    video.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
            else
              Text(
                video.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            if (needsExpansion)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onToggle,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(top: 4, bottom: 2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(isExpanded ? 'Ver menos' : '... más'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
