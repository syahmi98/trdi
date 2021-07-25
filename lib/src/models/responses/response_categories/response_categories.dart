import 'package:json_annotation/json_annotation.dart';
import '../../category/category.dart';

part 'response_categories.g.dart';

@JsonSerializable()
class ResponseCategories {
  late List<Category> categories;

  @JsonKey(ignore: true)
  String? error;

  ResponseCategories({required this.categories});
  ResponseCategories.withError(this.error);

  factory ResponseCategories.fromJson(Map<String, dynamic> json) =>
      _$ResponseCategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseCategoriesToJson(this);
}
