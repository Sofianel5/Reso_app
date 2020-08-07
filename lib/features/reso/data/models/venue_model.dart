import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/venue.dart';
import 'address_model.dart';
import 'coordinates_model.dart';
import 'model.dart';
import 'timeslot_model.dart';
import 'user_model.dart';

part 'venue_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class VenueModel extends Venue implements Model {
  final CoordinatesModel coordinates;
  final AddressModel address;
  VenueModel({
    @required int id,
    String type,
    String description,
    @required String title,
    String timezone,
    String image,
    String phone,
    bool requiresForm,
    String formUrl,
    String email,
    String shareLink,
    bool maskRequired,
    String website,
    this.coordinates,
    this.address,
  }) : super(
          id: id,
          type: type,
          description: description,
          title: title,
          timezone: timezone,
          image: image,
          phone: phone,
          email: email,
          shareLink: shareLink,
          maskRequired: maskRequired,
          website: website,
          coordinates: coordinates,
          address: address,
          requiresForm: requiresForm,
          formUrl: formUrl
        );
    

  factory VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class VenueDetailModel extends VenueDetail {
  final CoordinatesModel coordinates;
  final AddressModel address;
  final UserModel admin;
  List<TimeSlotModel> bookableTimeSlots;
  VenueDetailModel({
    @required int id,
    String type,
    String description,
    @required String title,
    String timezone,
    String image,
    String phone,
    bool maskRequired,
    String shareLink,
    bool requiresForm,
    String email,
    String website,
    this.coordinates,
    this.address,
    this.admin,
    this.bookableTimeSlots,
  }) : super(
          id: id,
          type: type,
          description: description,
          title: title,
          timezone: timezone,
          image: image,
          phone: phone,
          maskRequired: maskRequired,
          shareLink: shareLink,
          email: email,
          website: website,
          coordinates: coordinates,
          address: address,
          admin: admin,
          requiresForm: requiresForm,
          bookableTimeSlots: bookableTimeSlots,
        );

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VenueDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueDetailModelToJson(this);
}
