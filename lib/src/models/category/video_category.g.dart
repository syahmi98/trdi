// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoCategory _$VideoCategoryFromJson(Map<String, dynamic> json) {
  return VideoCategory(
    json['id'] as int,
    json['title'] as String,
    json['slug'] as String,
    json['post_count'] as int,
    (json['videos'] as List<dynamic>)
        .map((e) => Video.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$VideoCategoryToJson(VideoCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'post_count': instance.totalPostCount,
      'videos': instance.videos,
    };
