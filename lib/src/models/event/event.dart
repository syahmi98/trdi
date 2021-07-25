import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils/utils.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends EventInterface with EquatableMixin {
  final int id;
  final String title, slug, keywords;

  @JsonKey(name: "short_text")
  final String description;

  @JsonKey(name: "more_text")
  final String content;

  @JsonKey(name: "meta_description")
  final String metaDescriptions;

  @JsonKey(name: "name_file")
  final String imageName;

  @JsonKey(name: "extension_file")
  final String imageExtension;

  @JsonKey(name: "view")
  final int views;

  @JsonKey(name: "datefrom")
  final int dateStartInSeconds;

  @JsonKey(name: "dateto")
  final int dateEndInSeconds;

  Event(
    this.id,
    this.title,
    this.slug,
    this.keywords,
    this.description,
    this.content,
    this.metaDescriptions,
    this.imageName,
    this.imageExtension,
    this.views,
    this.dateStartInSeconds,
    this.dateEndInSeconds,
  );

  factory Event.fromJson(Map<String, dynamic> json) =>
    _$EventFromJson(json);

  String? get imageUrl => "$IMAGE_UPLOAD_URL/$imageName.$imageExtension";

  DateTime get dateStart =>
    DateTime.fromMillisecondsSinceEpoch(dateStartInSeconds * 1000);

  DateTime get dateEnd =>
    DateTime.fromMillisecondsSinceEpoch(dateEndInSeconds * 1000);

  @override
  DateTime getDate() => dateStart;

  @override
  Widget getDot() => eventIcon;

  @override
  Widget? getIcon() => null;

  @override
  String getTitle() => title;

  @override
  List<Object> get props => [id, title, slug];

  @override
  int? getId() {
    throw UnimplementedError();
  }

}