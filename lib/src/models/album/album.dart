import 'package:json_annotation/json_annotation.dart';
import '../article/article.dart';
import '../file/file.dart';

part 'album.g.dart';

@JsonSerializable()
class Album extends Article {
  final List<File> images;

  Album(
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
    this.images
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

  factory Album.fromJson(Map<String, dynamic> json) =>
    _$AlbumFromJson(json);
}