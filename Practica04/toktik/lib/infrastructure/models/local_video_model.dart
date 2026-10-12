import 'package:toktik/domain/entities/video_post.dart';

class LocalVideoModel {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final int likes;
  final int views;
  final VideoSource source;

  LocalVideoModel({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.source,
    this.likes = 0,
    this.views = 0,
  });

  factory LocalVideoModel.fromJson(
    Map<String, dynamic> json, {
    required VideoSource source,
  }) {
    final videoUrl = json['videoUrl'] as String;
    return LocalVideoModel(
      id: json['id'] as String? ?? videoUrl,
      name: json['name'] as String? ?? 'Sin título',
      description: json['description'] as String? ?? '',
      videoUrl: videoUrl,
      source: source,
      likes: json['likes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
    );
  }

  VideoPost toVideoPostEntity() => VideoPost(
    id: id,
    caption: name,
    description: description,
    videoUrl: videoUrl,
    likes: likes,
    views: views,
    source: source,
  );
}
