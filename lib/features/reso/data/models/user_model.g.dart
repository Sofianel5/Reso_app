// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as int,
    email: json['email'] as String,
    publicId: json['public_id'] as String,
    dateJoined: json['date_joined'] == null
        ? null
        : DateTime.parse(json['date_joined'] as String),
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    isLocked: json['is_locked'] as bool,
    coordinates: json['coordinates'] == null
        ? null
        : CoordinatesModel.fromJson(
            json['coordinates'] as Map<String, dynamic>),
    address: json['address'] == null
        ? null
        : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'public_id': instance.publicId,
      'date_joined': instance.dateJoined?.toIso8601String(),
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_locked': instance.isLocked,
      'coordinates': instance.coordinates?.toJson(),
      'address': instance.address?.toJson(),
    };