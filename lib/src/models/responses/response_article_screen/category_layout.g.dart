// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLayout _$CategoryLayoutFromJson(Map<String, dynamic> json) {
  return CategoryLayout(
    Category.fromJson(json['category'] as Map<String, dynamic>),
    json['layout'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$CategoryLayoutToJson(CategoryLayout instance) =>
    <String, dynamic>{
      'category': instance.category,
      'layout': instance.layout,
    };
