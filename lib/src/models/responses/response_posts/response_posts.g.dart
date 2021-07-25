// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_posts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsePosts _$ResponsePostsFromJson(Map<String, dynamic> json) {
  return ResponsePosts(
    data: (json['data'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList()),
    ),
    links: PaginatedLink.fromJson(json['links'] as Map<String, dynamic>),
    meta: PaginatedMeta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResponsePostsToJson(ResponsePosts instance) =>
    <String, dynamic>{
      'data': instance.data,
      'links': instance.links,
      'meta': instance.meta,
    };
