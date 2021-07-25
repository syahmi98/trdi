import 'package:json_annotation/json_annotation.dart';

part 'youtube_video.g.dart';

@JsonSerializable()
class YoutubeVideo {
  final int id;

  @JsonKey(name: "v_id")
  final String videoId;

  @JsonKey(name: "v_last_update")
  final String videoDate;

  @JsonKey(name: "v_title")
  final String videoTitle;
  
  @JsonKey(name: "v_ctg")
  final String videoCategory;

  @JsonKey(name: "v_thumbnails")
  final String videoThumbnail;
  
  YoutubeVideo({
    required this.id,
    required this.videoId,
    required this.videoDate,
    required this.videoTitle,
    required this.videoCategory,
    required this.videoThumbnail,
  });

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) =>
    _$YoutubeVideoFromJson(json);

  Map<String, dynamic> toJson() => _$YoutubeVideoToJson(this);

}