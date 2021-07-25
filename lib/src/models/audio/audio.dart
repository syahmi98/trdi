
import 'package:json_annotation/json_annotation.dart';
import '../article/article.dart';
import '../file/file.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio extends Article {
  final List<File> audios;

  Audio(
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
    this.audios
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

  factory Audio.fromJson(Map<String, dynamic> json) =>
    _$AudioFromJson(json);
}