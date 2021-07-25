import 'package:trdi/src/models/post/post.dart';
import 'package:trdi/src/models/responses/response_article_screen/category_layout.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_article_screen.g.dart';

@JsonSerializable()
class ResponseArticleScreen {
  @JsonKey(name: "pinned")
  Map<String, List<Post>> pinnedPostsData = {
    "posts": []
  };

  @JsonKey(name: "latest")
  Map<String, List<Post>> latestPostsData = {
    "posts": []
  };

  final List<CategoryLayout> categories;

  ResponseArticleScreen(
    this.pinnedPostsData,
    this.latestPostsData,
    this.categories
  );

  factory ResponseArticleScreen.fromJson(Map<String, dynamic> json) =>
    _$ResponseArticleScreenFromJson(json);

  List<Post>? get pinnedPosts =>
    pinnedPostsData.containsKey("posts")
      ? pinnedPostsData["posts"]
      : [];

  List<Post>? get latestPosts =>
    latestPostsData.containsKey("posts")
      ? latestPostsData["posts"]
      : [];
}