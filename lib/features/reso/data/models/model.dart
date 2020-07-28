import 'package:json_annotation/json_annotation.dart';

abstract class Model {
  Model.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
