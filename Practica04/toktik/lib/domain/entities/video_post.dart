enum VideoSource { local, youtube, vimeo, dailymotion }

enum VideoFeed { discover, forYou, favorites }

class VideoPost {
  final String id;
  final String caption;
  final String description;
  final String author;
  final String videoUrl;
  final VideoSource source;
  final int likes;
  final int views;
  final bool isLiked;
  final bool isFavorite;

  const VideoPost({
    required this.id,
    required this.caption,
    required this.description,
    required this.author,
    required this.videoUrl,
    required this.source,
    this.likes = 0,
    this.views = 0,
    this.isLiked = false,
    this.isFavorite = false,
  });

  VideoPost copyWith({
    int? likes,
    bool? isLiked,
    bool? isFavorite,
  }) {
    return VideoPost(
      id: id,
      caption: caption,
      description: description,
      author: author,
      videoUrl: videoUrl,
      source: source,
      likes: likes ?? this.likes,
      views: views,
      isLiked: isLiked ?? this.isLiked,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
