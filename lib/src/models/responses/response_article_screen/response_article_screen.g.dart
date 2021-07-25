// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_article_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseArticleScreen _$ResponseArticleScreenFromJson(
    Map<String, dynamic> json) {
  return ResponseArticleScreen(
    (json['pinned'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList()),
    ),
    (json['latest'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList()),
    ),
    (json['categories'] as List<dynamic>)
        .map((e) => CategoryLayout.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ResponseArticleScreenToJson(
        ResponseArticleScreen instance) =>
    <String, dynamic>{
      'pinned': instance.pinnedPostsData,
      'latest': instance.latestPostsData,
      'categories': instance.categories,
    };
