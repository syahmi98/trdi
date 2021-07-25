import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../utils/utils.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int id;
  final String slug, title, keywords;

  @JsonKey(name: "meta_description")
  final String metaDescriptions;

  @JsonKey(name: "name_file")
  final String imageName;

  @JsonKey(name: "extension_file")
  final String imageExtension;

  @JsonKey(name: "visiblity_date_seconds")
  final int visibilityDateInSeconds;

  @JsonKey(name: "created_by")
  final String author;

  @JsonKey(name: "view")
  final int views;

  const Post(
    this.id,
    this.slug,
    this.title,
    this.keywords,
    this.metaDescriptions,
    this.imageName,
    this.imageExtension,
    this.visibilityDateInSeconds,
    this.author,
    this.views
  );

  factory Post.fromJson(Map<String, dynamic> json) =>
    _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  String? get imageUrl =>
    imageName == null ? null : "$IMAGE_UPLOAD_URL/$imageName.$imageExtension";

  DateTime get visibleDate =>
    DateTime.fromMillisecondsSinceEpoch(visibilityDateInSeconds * 1000);

  String get formattedDate {
    if(DateTime.now().difference(visibleDate).inDays >= 1)
      return DateFormat.yMd().format(visibleDate);

    return timeago.format(visibleDate);
  }
    
}
