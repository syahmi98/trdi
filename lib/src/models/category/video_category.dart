import 'package:trdi/src/models/video/video.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'video_category.g.dart';

@JsonSerializable()
class VideoCategory extends Category {
  final List<Video> videos;

  const VideoCategory(
    int id,
    String title,
    String slug,
    int totalPostCount,
    this.videos
  ) : super(
    id: id,
    title: title,
    slug: slug,
    totalPostCount: totalPostCount
  );

  factory VideoCategory.fromJson(Map<String, dynamic> json) =>
    _$VideoCategoryFromJson(json);
}