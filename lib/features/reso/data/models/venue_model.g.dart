// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) {
  return VenueModel(
    id: json['id'] as int,
    type: json['type'] as String,
    description: json['description'] as String,
    title: json['title'] as String,
    timezone: json['timezone'] as String,
    image: json['image'] as String,
    phone: json['phone'] as String,
    requiresForm: json['requires_form'] as bool,
    formUrl: json['form_url'] as String,
    email: json['email'] as String,
    maskRequired: json['mask_required'] as bool,
    website: json['website'] as String,
    coordinates: json['coordinates'] == null
        ? null
        : CoordinatesModel.fromJson(
            json['coordinates'] as Map<String, dynamic>),
    address: json['address'] == null
        ? null
        : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'title': instance.title,
      'timezone': instance.timezone,
      'image': instance.image,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'requires_form': instance.requiresForm,
      'form_url': instance.formUrl,
      'mask_required': instance.maskRequired,
      'coordinates': instance.coordinates?.toJson(),
      'address': instance.address?.toJson(),
    };

VenueDetailModel _$VenueDetailModelFromJson(Map<String, dynamic> json) {
  return VenueDetailModel(
    id: json['id'] as int,
    type: json['type'] as String,
    description: json['description'] as String,
    title: json['title'] as String,
    timezone: json['timezone'] as String,
    image: json['image'] as String,
    phone: json['phone'] as String,
    maskRequired: json['mask_required'] as bool,
    requiresForm: json['requires_form'] as bool,
    email: json['email'] as String,
    website: json['website'] as String,
    coordinates: json['coordinates'] == null
        ? null
        : CoordinatesModel.fromJson(
            json['coordinates'] as Map<String, dynamic>),
    address: json['address'] == null
        ? null
        : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    admin: json['admin'] == null
        ? null
        : UserModel.fromJson(json['admin'] as Map<String, dynamic>),
    bookableTimeSlots: (json['bookable_time_slots'] as List)
        ?.map((e) => e == null
            ? null
            : TimeSlotModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..formUrl = json['form_url'] as String;
}

Map<String, dynamic> _$VenueDetailModelToJson(VenueDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'title': instance.title,
      'timezone': instance.timezone,
      'image': instance.image,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'requires_form': instance.requiresForm,
      'form_url': instance.formUrl,
      'mask_required': instance.maskRequired,
      'coordinates': instance.coordinates?.toJson(),
      'address': instance.address?.toJson(),
      'admin': instance.admin?.toJson(),
      'bookable_time_slots':
          instance.bookableTimeSlots?.map((e) => e?.toJson())?.toList(),
    };
