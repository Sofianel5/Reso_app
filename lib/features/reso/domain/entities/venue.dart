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
  String shareLink;
  String website;
  bool requiresForm;
  String formUrl;
  bool maskRequired;
  Coordinates coordinates;
  Address address;
  Venue({
    @required this.id,
    @required this.type,
    @required this.description,
    @required this.title,
    this.timezone,
    @required this.image,
    this.phone,
    this.email,
    this.website,
    this.coordinates,
    this.address,
    this.requiresForm,
    this.formUrl,
    this.maskRequired,
    this.shareLink
  });

  @override
  List<Object> get props => [id];
  static const types = <String>[
    "All",
    "Retail",
    "Real Estate",
    "Restaurant",
    "Grocery",
    "Coffee",
    "Gym",
    "Gas",
    "Mail",
    "Repair",
    "Beauty",
    "Education"
  ];
  static getLoadingPlaceholder(int id) {
    return Venue(id: id, type: "All", description: "Loading", title: "Loading", image: "https://tracery-schedules-static.s3.amazonaws.com/media/venues/default.jpg");
  }
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
    String shareLink,
    String website,
    Coordinates coordinates,
    bool requiresForm,
    bool maskRequired,
    String formUrl,
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
          shareLink: shareLink,
          email: email,
          website: website,
          coordinates: coordinates,
          requiresForm: requiresForm,
          formUrl: formUrl,
          address: address,
          maskRequired:maskRequired,
        );
}
