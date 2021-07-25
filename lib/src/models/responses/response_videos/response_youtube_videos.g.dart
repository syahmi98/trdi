// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_youtube_videos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseYoutubeVideos _$ResponseYoutubeVideosFromJson(
    Map<String, dynamic> json) {
  return ResponseYoutubeVideos(
    data: (json['data'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => YoutubeVideo.fromJson(e as Map<String, dynamic>))
              .toList()),
    ),
    links: PaginatedLink.fromJson(json['links'] as Map<String, dynamic>),
    meta: PaginatedMeta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResponseYoutubeVideosToJson(
        ResponseYoutubeVideos instance) =>
    <String, dynamic>{
      'data': instance.data,
      'links': instance.links,
      'meta': instance.meta,
    };
