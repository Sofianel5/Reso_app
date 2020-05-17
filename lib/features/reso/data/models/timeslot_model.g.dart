// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeslot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) {
  return TimeSlotModel(
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
    maxAttendees: json['max_attendees'] as int,
    numAttendees: json['num_attendees'] as int,
    id: json['id'] as int,
    current: json['current'] as bool,
    past: json['past'] as bool,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'max_attendees': instance.maxAttendees,
      'num_attendees': instance.numAttendees,
      'id': instance.id,
      'current': instance.current,
      'past': instance.past,
      'type': instance.type,
    };

TimeSlotDetailModel _$TimeSlotDetailModelFromJson(Map<String, dynamic> json) {
  return TimeSlotDetailModel(
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
    maxAttendees: json['max_attendees'] as int,
    numAttendees: json['num_attendees'] as int,
    id: json['id'] as int,
    current: json['current'] as bool,
    past: json['past'] as bool,
    venue: json['venue'] == null
        ? null
        : VenueModel.fromJson(json['venue'] as Map<String, dynamic>),
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$TimeSlotDetailModelToJson(
        TimeSlotDetailModel instance) =>
    <String, dynamic>{
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'max_attendees': instance.maxAttendees,
      'num_attendees': instance.numAttendees,
      'id': instance.id,
      'current': instance.current,
      'past': instance.past,
      'type': instance.type,
      'venue': instance.venue?.toJson(),
    };