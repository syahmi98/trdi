import 'package:trdi/src/models/category/video_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_video_screen.g.dart';

@JsonSerializable()
class ResponseVideoScreen {
  final Map<String, dynamic> livestream;
  final List<VideoCategory> categories;

  const ResponseVideoScreen(
    this.livestream,
    this.categories
  );

  factory ResponseVideoScreen.fromJson(Map<String, dynamic> json) =>
    _$ResponseVideoScreenFromJson(json);
}