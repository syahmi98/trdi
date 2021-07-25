import 'package:json_annotation/json_annotation.dart';
import '../../paginated_link.dart';
import '../../post/post.dart';

part 'response_posts.g.dart';

@JsonSerializable()
class ResponsePosts {

  Map<String, List<Post>> data = {
    "posts": [],
  };

  late PaginatedLink links;
  late PaginatedMeta meta;

  @JsonKey(ignore: true)
  String? error;

  ResponsePosts({
    required this.data,
    required this.links,
    required this.meta
  });

  List<Post>? get posts => 
    data.containsKey("posts") 
      ? data["posts"] 
      : [];

  ResponsePosts.withError(this.error);

  factory ResponsePosts.fromJson(Map<String, dynamic> json) =>
    _$ResponsePostsFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsePostsToJson(this);
}