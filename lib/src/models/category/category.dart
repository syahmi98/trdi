import 'package:trdi/src/models/post/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int? id;
  final String title;
  final String slug;
  
  @JsonKey(name: "post_count")
  final int? totalPostCount;

  final List<Post>? posts;

  const Category({
    this.id,
    required this.title,
    required this.slug,
    this.totalPostCount,
    this.posts,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
    _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

}