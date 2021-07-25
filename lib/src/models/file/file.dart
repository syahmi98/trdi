import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../utils/utils.dart';

part 'file.g.dart';

@JsonSerializable()
class File {
  int id, order,
      size;

  String name, description;

  @JsonKey(name: "file_name")
  String fileName;

  @JsonKey(name: "file_extension")
  String fileExtension;

  double duration;

  File({
    required this.id,
    required this.order,
    required this.size,
    required this.name,
    required this.description,
    required this.fileName,
    required this.fileExtension,
    required this.duration,
  });

  factory File.fromJson(Map<String, dynamic> json) =>
    _$FileFromJson(json);

  String? get url {
    if(fileName == null || fileExtension == null) return null;
    return "$FILE_UPLOAD_URL/$fileName.$fileExtension";
  }

  @override
  List<Object> get props => [id, order, size, name, description, fileName, fileExtension];

  
}