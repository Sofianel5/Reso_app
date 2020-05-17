// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handshake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandshakeModel _$HandshakeModelFromJson(Map<String, dynamic> json) {
  return HandshakeModel(
    venue: json['venue'] == null
        ? null
        : VenueModel.fromJson(json['venue'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    id: json['id'] as int,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
  );
}

Map<String, dynamic> _$HandshakeModelToJson(HandshakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time?.toIso8601String(),
      'venue': instance.venue?.toJson(),
      'user': instance.user?.toJson(),
    };