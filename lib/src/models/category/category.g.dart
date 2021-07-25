// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    title: json['title'] as String,
    slug: json['slug'] as String,
    totalPostCount: json['post_count'] as int,
    posts: (json['posts'] as List<dynamic>?)
        ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'post_count': instance.totalPostCount,
      'posts': instance.posts,
    };
