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
  bool _isMuted = true;
  bool _isDescriptionExpanded = false;

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
          bottom: 42,
          child: _VideoDescription(
            video: widget.video,
            isExpanded: _isDescriptionExpanded,
            onToggle: () => setState(
              () => _isDescriptionExpanded = !_isDescriptionExpanded,
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 28,
          child: VideoButtons(
            video: widget.video,
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
        Positioned(
          top: MediaQuery.paddingOf(context).top + 76,
          left: 16,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                widget.video.source.name.toUpperCase(),
                style: theme.textTheme.labelSmall,
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
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final needsExpansion = video.description.length > 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(video.author, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        if (isExpanded)
          SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: Text(video.description, style: textStyle),
            ),
          )
        else
          Text(
            video.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        if (needsExpansion)
          TextButton(
            onPressed: onToggle,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(isExpanded ? 'menos' : '... más'),
          ),
      ],
    );
  }
}
