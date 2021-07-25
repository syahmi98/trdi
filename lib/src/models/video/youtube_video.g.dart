// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YoutubeVideo _$YoutubeVideoFromJson(Map<String, dynamic> json) {
  return YoutubeVideo(
    id: json['id'] as int,
    videoId: json['v_id'] as String,
    videoDate: json['v_last_update'] as String,
    videoTitle: json['v_title'] as String,
    videoCategory: json['v_ctg'] as String,
    videoThumbnail: json['v_thumbnails'] as String,
  );
}

Map<String, dynamic> _$YoutubeVideoToJson(YoutubeVideo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'v_id': instance.videoId,
      'v_last_update': instance.videoDate,
      'v_title': instance.videoTitle,
      'v_ctg': instance.videoCategory,
      'v_thumbnails': instance.videoThumbnail,
    };
