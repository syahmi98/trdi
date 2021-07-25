// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
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
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
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
    };
