import 'package:json_annotation/json_annotation.dart';
import '../post/post.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Post {

  @JsonKey(name: "short_text")
  final String description;

  @JsonKey(name: "more_text")
  final String content;

  const Article(
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
    this.description,
    this.content,
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
    views
  );

  factory Article.fromJson(Map<String, dynamic> json) => 
    _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}