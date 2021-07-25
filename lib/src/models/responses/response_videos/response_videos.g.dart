// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_videos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseVideos _$ResponseVideosFromJson(Map<String, dynamic> json) {
  return ResponseVideos(
    data: (json['data'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => Video.fromJson(e as Map<String, dynamic>))
              .toList()),
    ),
    links: PaginatedLink.fromJson(json['links'] as Map<String, dynamic>),
    meta: PaginatedMeta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResponseVideosToJson(ResponseVideos instance) =>
    <String, dynamic>{
      'data': instance.data,
      'links': instance.links,
      'meta': instance.meta,
    };
