// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadModel _$ThreadModelFromJson(Map<String, dynamic> json) {
  return ThreadModel(
    id: json['id'] as int,
    venue: json['venue'] == null
        ? null
        : VenueModel.fromJson(json['venue'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    fromConfirmed: json['from_confirmed'] as bool,
    toConfirmed: json['to_confirmed'] as bool,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    threadId: json['thread_id'] as String,
  );
}

Map<String, dynamic> _$ThreadModelToJson(ThreadModel instance) =>
    <String, dynamic>{
      'thread_id': instance.threadId,
      'id': instance.id,
      'time': instance.time?.toIso8601String(),
      'from_confirmed': instance.fromConfirmed,
      'to_confirmed': instance.toConfirmed,
      'venue': instance.venue?.toJson(),
      'user': instance.user?.toJson(),
    };