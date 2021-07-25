import 'package:json_annotation/json_annotation.dart';
import '../../paginated_link.dart';
import '../../video/youtube_video.dart';


part 'response_youtube_videos.g.dart';

@JsonSerializable()
class ResponseYoutubeVideos {
  Map<String, List<YoutubeVideo>> data = {
    "videos": []
  };

  late PaginatedLink links;
  late PaginatedMeta meta;

  @JsonKey(ignore: true)
  String? error;

  ResponseYoutubeVideos({
    required this.data,
    required this.links,
    required this.meta
  });

  ResponseYoutubeVideos.withError(this.error);

  factory ResponseYoutubeVideos.fromJson(Map<String, dynamic> json) =>
    _$ResponseYoutubeVideosFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseYoutubeVideosToJson(this);

  List<YoutubeVideo>? get videos =>
    data.containsKey("videos") 
    ? data["videos"] 
    : [];

}