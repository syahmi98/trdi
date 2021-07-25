// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    json['id'] as int,
    json['title'] as String,
    json['slug'] as String,
    json['keywords'] as String,
    json['short_text'] as String,
    json['more_text'] as String,
    json['meta_description'] as String,
    json['name_file'] as String,
    json['extension_file'] as String,
    json['view'] as int,
    json['datefrom'] as int,
    json['dateto'] as int,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'keywords': instance.keywords,
      'short_text': instance.description,
      'more_text': instance.content,
      'meta_description': instance.metaDescriptions,
      'name_file': instance.imageName,
      'extension_file': instance.imageExtension,
      'view': instance.views,
      'datefrom': instance.dateStartInSeconds,
      'dateto': instance.dateEndInSeconds,
    };
