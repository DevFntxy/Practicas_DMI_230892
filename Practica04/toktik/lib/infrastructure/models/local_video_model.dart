import 'package:toktik/domain/entities/video_post.dart';

class LocalVideoModel {
  final String id;
  final String name;
  final String description;
  final String author;
  final String videoUrl;
  final int likes;
  final int views;

  const LocalVideoModel({
    required this.id,
    required this.name,
    required this.description,
    required this.author,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });

  factory LocalVideoModel.fromJson(
    Map<String, dynamic> json, {
    required String source,
  }) {
    return LocalVideoModel(
      id: '$source:${json['id']}',
      name: json['name'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      videoUrl: json['videoUrl'] as String,
      likes: json['likes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
    );
  }

  VideoPost toVideoPostEntity(VideoSource source) {
    return VideoPost(
      id: id,
      caption: name,
      description: description,
      author: author,
      videoUrl: videoUrl,
      source: source,
      likes: likes,
      views: views,
    );
  }
}
