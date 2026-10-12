class VideoPost {
  final String id;
  final String caption;
  final String description;
  final String videoUrl;
  final int likes;
  final int views;
  final VideoSource source;

  VideoPost({
    String? id,
    required this.caption,
    this.description = '',
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
    this.source = VideoSource.directMp4,
  }) : id = id ?? videoUrl;
}

enum VideoSource { directMp4, dailymotion, vimeo }
