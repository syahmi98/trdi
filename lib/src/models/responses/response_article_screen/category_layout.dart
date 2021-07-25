import 'package:trdi/src/models/category/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_layout.g.dart';

enum LayoutStyle {
  HorizontalScroll,
  VerticalScroll,
  LeftImageVerticalScroll,
  GridView,
  PageView
}

enum LayoutTheme {
  Light,
  Dark
}

@JsonSerializable()
class CategoryLayout {
  final Category category;
  Map<String, dynamic> layout = {
    'name': "VerticalScroll",
    'theme': "light"
  };

  CategoryLayout(
    this.category,
    this.layout
  );

  factory CategoryLayout.fromJson(Map<String, dynamic> json) =>
    _$CategoryLayoutFromJson(json);

  LayoutTheme get layoutTheme {
    final theme = layout['theme'] ?? "light";

    if(theme.toString().toLowerCase() == "dark")
      return LayoutTheme.Dark;

    return LayoutTheme.Light;
  }

  LayoutStyle get layoutStyle {
    final style = layout['name'] ?? "VerticalScroll";

    switch(style.toString().toLowerCase()) {
      case "horizontalscroll":
        return LayoutStyle.HorizontalScroll;
      case "gridview":
        return LayoutStyle.GridView;
      case "pageview":
        return LayoutStyle.PageView;
      case "leftimageverticalscroll":
        return LayoutStyle.LeftImageVerticalScroll;
      default:
        return LayoutStyle.VerticalScroll;
        

    }

  }
}