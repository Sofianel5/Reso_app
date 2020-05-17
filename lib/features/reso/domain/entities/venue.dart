import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'address.dart';
import 'coordinates.dart';
import 'timeslot.dart';
import 'user.dart';

class Venue extends Equatable {
  int id;
  String type;
  String description;
  String title;
  String timezone;
  String image;
  String phone;
  String email;
  String website;
  Coordinates coordinates;
  Address address;
  Venue({
    @required this.id,
    @required this.type,
    @required this.description,
    @required this.title,
    this.timezone,
    this.image,
    this.phone,
    this.email,
    this.website,
    this.coordinates,
    this.address,
  });

  @override
  List<Object> get props => [id];
  static const types = <String>[
    "All",
    "Resturaunt",
    "Grocery",
    "Coffee",
    "Gym",
    "Gas",
    "Mail",
    "Repair",
    "Beauty",
    "Education"
  ];
}

class VenueDetail extends Venue {
  final List<TimeSlot> bookableTimeSlots;
  final User admin;
  VenueDetail({
    int id,
    String type,
    String description,
    String title,
    String timezone,
    String image,
    String phone,
    String email,
    String website,
    Coordinates coordinates,
    Address address,
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
        );
}
