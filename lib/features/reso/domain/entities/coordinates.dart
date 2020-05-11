import 'package:equatable/equatable.dart';

class Coordinates extends Equatable {
  final double lat;
  final double lng;
  final int id;
  Coordinates({
    this.lat,
    this.lng,
    this.id,
  });
  @override
  List<Object> get props => [lat, lng, id];
}