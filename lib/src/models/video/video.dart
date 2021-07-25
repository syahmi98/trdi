import 'package:trdi/src/models/article/article.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video extends Article {
  @JsonKey(name: "video_link")
  String link;

  Video(
    int id,
    String slug,
    String title,
    String keywords,
    String metaDescriptions,
    String imageName,
    String imageExtension,
    int visibilityDateInSeconds,
    String author,
    int views,
    String description,
    String content,
    this.link
  ) : super(
    id,
    slug,
    title,
    keywords,
    metaDescriptions,
    imageName,
    imageExtension,
    visibilityDateInSeconds,
    author,
    views,
    description,
    content
  );

  factory Video.fromJson(Map<String, dynamic> json) =>
    _$VideoFromJson(json);
}