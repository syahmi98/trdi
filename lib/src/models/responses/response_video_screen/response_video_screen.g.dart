// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_video_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseVideoScreen _$ResponseVideoScreenFromJson(Map<String, dynamic> json) {
  return ResponseVideoScreen(
    json['livestream'] as Map<String, dynamic>,
    (json['categories'] as List<dynamic>)
        .map((e) => VideoCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ResponseVideoScreenToJson(
        ResponseVideoScreen instance) =>
    <String, dynamic>{
      'livestream': instance.livestream,
      'categories': instance.categories,
    };
