// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseCategories _$ResponseCategoriesFromJson(Map<String, dynamic> json) {
  return ResponseCategories(
    categories: (json['categories'] as List<dynamic>)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ResponseCategoriesToJson(ResponseCategories instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };
