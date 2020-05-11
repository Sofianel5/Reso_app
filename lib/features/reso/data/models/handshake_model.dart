import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/handshake.dart';
import 'model.dart';
import 'user_model.dart';
import 'venue_model.dart';

part 'handshake_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HandshakeModel extends Handshake implements Model {
  final VenueModel venue;
  final UserModel user;
  HandshakeModel({
    this.venue,
    this.user,
    @required int id,
    DateTime time,
  }) : super(
          venue: venue,
          user: user,
          time: time,
          id: id,
        );
  factory HandshakeModel.fromJson(Map<String, dynamic> json) =>
      _$HandshakeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HandshakeModelToJson(this);
}
