// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedLink _$PaginatedLinkFromJson(Map<String, dynamic> json) {
  return PaginatedLink(
    first: json['first'] as String,
    last: json['last'] as String,
    prev: json['prev'] as String,
    next: json['next'] as String,
  );
}

Map<String, dynamic> _$PaginatedLinkToJson(PaginatedLink instance) =>
    <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };

PaginatedMeta _$PaginatedMetaFromJson(Map<String, dynamic> json) {
  return PaginatedMeta(
    currentPage: json['current_page'] as int,
    from: json['from'] as int,
    lastPage: json['last_page'] as int,
    path: json['path'] as String,
    pageItemCount: json['per_page'] as int,
    to: json['to'] as int,
    total: json['total'] as int,
  );
}

Map<String, dynamic> _$PaginatedMetaToJson(PaginatedMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'path': instance.path,
      'per_page': instance.pageItemCount,
      'to': instance.to,
      'total': instance.total,
    };
