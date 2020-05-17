// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return AddressModel(
    id: json['id'] as int,
    address_1: json['address_1'] as String,
    address_2: json['address_2'] as String,
    postCode: json['post_code'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
  );
}

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'address_1': instance.address_1,
      'address_2': instance.address_2,
      'post_code': instance.postCode,
      'city': instance.city,
      'state': instance.state,
      'id': instance.id,
    };