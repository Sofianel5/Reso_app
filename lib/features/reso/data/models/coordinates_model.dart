import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/coordinates.dart';
import 'model.dart';

part 'coordinates_model.g.dart';
@JsonSerializable(explicitToJson: true)
class CoordinatesModel extends Coordinates implements Model {
  CoordinatesModel({
    @required double lat,
    @required double lng,
    int id,
  }) : super(lat: lat, lng: lng, id: id);
  factory CoordinatesModel.fromJson(Map<String, dynamic> json) => _$CoordinatesModelFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesModelToJson(this);
}