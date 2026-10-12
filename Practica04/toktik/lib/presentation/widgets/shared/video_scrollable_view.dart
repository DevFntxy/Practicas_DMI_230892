import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/seasonal_theme_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:toktik/presentation/widgets/video/fullscreen_player.dart';

class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;
  final DiscoverProvider discoverProvider;

  const VideoScrollableView({
    super.key,
    required this.videos,
    required this.discoverProvider,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  int _currentIndex = 0;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        final VideoPost videoPost = widget.videos[index];

        return Stack(
          children: [
            SizedBox.expand(
              child: FullScreenPlayer(
                key: ValueKey(videoPost.id),
                caption: videoPost.caption,
                description: videoPost.description,
                videoUrl: videoPost.videoUrl,
                source: videoPost.source,
                isActive: index == _currentIndex,
                isMuted: _isMuted,
              ),
            ),
            Positioned(
              bottom: 24,
              right: 12,
              child: VideoButtons(
                video: videoPost,
                likeCount: widget.discoverProvider.likesFor(videoPost),
                isLiked: widget.discoverProvider.isLiked(videoPost),
                isFavorite: widget.discoverProvider.isFavorite(videoPost),
                isMuted: _isMuted,
                onLikePressed: () {
                  unawaited(widget.discoverProvider.toggleLike(videoPost));
                  unawaited(
                    context.read<SeasonalThemeProvider>().playThemeSound(),
                  );
                },
                onFavoritePressed: () {
                  unawaited(widget.discoverProvider.toggleFavorite(videoPost));
                  unawaited(
                    context.read<SeasonalThemeProvider>().playThemeSound(),
                  );
                },
                onMutePressed: () {
                  setState(() => _isMuted = !_isMuted);
                  unawaited(
                    context.read<SeasonalThemeProvider>().playThemeSound(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
