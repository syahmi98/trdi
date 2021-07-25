// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    json['id'] as int,
    json['slug'] as String,
    json['title'] as String,
    json['keywords'] as String,
    json['meta_description'] as String,
    json['name_file'] as String,
    json['extension_file'] as String,
    json['visiblity_date_seconds'] as int,
    json['created_by'] as String,
    json['view'] as int,
    json['short_text'] as String,
    json['more_text'] as String,
    json['video_link'] as String,
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'keywords': instance.keywords,
      'meta_description': instance.metaDescriptions,
      'name_file': instance.imageName,
      'extension_file': instance.imageExtension,
      'visiblity_date_seconds': instance.visibilityDateInSeconds,
      'created_by': instance.author,
      'view': instance.views,
      'short_text': instance.description,
      'more_text': instance.content,
      'video_link': instance.link,
    };
