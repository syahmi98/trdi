// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

File _$FileFromJson(Map<String, dynamic> json) {
  return File(
    id: json['id'] as int,
    order: json['order'] as int,
    size: json['size'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    fileName: json['file_name'] as String,
    fileExtension: json['file_extension'] as String,
    duration: (json['duration'] as num).toDouble(),
  );
}

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'size': instance.size,
      'name': instance.name,
      'description': instance.description,
      'file_name': instance.fileName,
      'file_extension': instance.fileExtension,
      'duration': instance.duration,
    };
