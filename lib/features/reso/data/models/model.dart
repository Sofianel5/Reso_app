import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
abstract class Model {
  Model.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
