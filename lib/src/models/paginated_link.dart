import 'package:json_annotation/json_annotation.dart';

part 'paginated_link.g.dart';

@JsonSerializable()
class PaginatedLink {
  final String 
      first, 
      last, 
      prev, 
      next;

  PaginatedLink({
    required this.first,
    required this.last,
    required this.prev,
    required this.next
  });

  factory PaginatedLink.fromJson(Map<String, dynamic> json) =>
    _$PaginatedLinkFromJson(json);
}

@JsonSerializable()
class PaginatedMeta {
  @JsonKey(name: "current_page")
  final int currentPage;

  final int from;

  @JsonKey(name: "last_page")
  final int lastPage;

  final String path;

  @JsonKey(name: "per_page")
  final int pageItemCount;

  final int to;

  final int total;

  PaginatedMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.pageItemCount,
    required this.to,
    required this.total
  });

  factory PaginatedMeta.fromJson(Map<String, dynamic> json) =>
    _$PaginatedMetaFromJson(json);

}