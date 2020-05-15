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
    String email,
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
          website: website,
          coordinates: coordinates,
          address: address,
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
          email: email,
          website: website,
          coordinates: coordinates,
          address: address,
          admin: admin,
          bookableTimeSlots: bookableTimeSlots,
        );

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VenueDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueDetailModelToJson(this);
}
