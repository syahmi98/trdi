import 'package:json_annotation/json_annotation.dart';
import '../../utils/utils.dart';
import '../file/file.dart';
import '../post/post.dart';

part 'magazine.g.dart';

@JsonSerializable()
class Magazine extends Post {
  final File pdf;

  const Magazine(
    int id,
    String slug,
    String title,
    String keywords,
    String metaDescriptions,
    String imageName,
    String imageExtension,
    int visibilityDateInSeconds,
    String author,
    int views,
    this.pdf,
  ) : super(
    id,
    slug,
    title,
    keywords,
    metaDescriptions,
    imageName,
    imageExtension,
    visibilityDateInSeconds,
    author,
    views
  );

  factory Magazine.fromJson(Map<String, dynamic> json) => 
    _$MagazineFromJson(json);

  Map<String, dynamic> toJson() => _$MagazineToJson(this);

  String? get pdfUrl {
    if(pdf == null || pdf.fileName == null) return null;
    return "$FILE_UPLOAD_URL/${pdf.fileName}.${pdf.fileExtension}";
  }

}