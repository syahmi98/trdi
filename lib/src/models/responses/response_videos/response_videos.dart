import 'package:json_annotation/json_annotation.dart';
import '../../paginated_link.dart';
import '../../video/video.dart';


part 'response_videos.g.dart';

@JsonSerializable()
class ResponseVideos {
  Map<String, List<Video>> data = {
    "videos": []
  };

  late PaginatedLink links;
  late PaginatedMeta meta;

  @JsonKey(ignore: true)
  String? error;

  ResponseVideos({
    required this.data,
    required this.links,
    required this.meta
  });

  ResponseVideos.withError(this.error);

  factory ResponseVideos.fromJson(Map<String, dynamic> json) =>
    _$ResponseVideosFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseVideosToJson(this);

  List<Video>? get videos =>
    data.containsKey("videos") 
      ? data["videos"] 
      : [];

}