import 'dart:convert';

import 'package:Reso/features/reso/data/models/address_model.dart';
import 'package:Reso/features/reso/data/models/coordinates_model.dart';
import 'package:Reso/features/reso/data/models/timeslot_model.dart';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:Reso/features/reso/data/models/venue_model.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tVenue = VenueModel(
    id: 1,
    type: "Grocery",
    description: null,
    title: "Whole Foods Battery Park City",
    timezone: "America/New_York",
    image:
        "https://tracery-schedules-static.s3.amazonaws.com/media/venues/wholefoods.jpg",
    phone: null,
    email: null,
    website: null,
    coordinates: CoordinatesModel(id: 2, lat: 40.7158067, lng: -74.0118043),
    address: AddressModel(
      id: 1,
      address_1: "270 Greenwich St",
      address_2: "B4",
      postCode: "10007",
      city: "New York",
      state: "NY",
    ),
  );

  final tVenueDetail = VenueDetailModel(
    id: 1,
    admin: UserModel(
      id: 1,
      firstName: "Sofiane",
      lastName: "Larbi (Admin)",
    ),
    bookableTimeSlots: [
      TimeSlotModel(
        start: DateTime.parse("2020-05-06T02:13:24"),
        stop: DateTime.parse("2020-05-19T02:13:30"),
        maxAttendees: 100,
        numAttendees: 0,
        id: 7,
        current: true,
        past: false,
        type: "All",
      ),
    ],
    type: "Grocery",
    title: "Whole Foods Battery Park City",
    timezone: "America/New_York",
    image:
        "https://tracery-schedules-static.s3.amazonaws.com/media/venues/wholefoods.jpg",
    phone: null,
    email: null,
    website: null,
    coordinates: CoordinatesModel(lat: 40.7158067, lng: -74.0118043, id: 2),
    address: AddressModel(
        id: 1,
        address_1: "270 Greenwich St",
        address_2: "B4",
        postCode: "10007",
        city: "New York",
        state: "NY"),
  );
  test('should be subclass of Venue entity', () async {
    // assert
    expect(tVenue, isA<Venue>());
    expect(tVenueDetail, isA<Venue>());
  });
  group('fromJson', () {
    test('Venue json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('venue.json'));
      // act
      final result = VenueModel.fromJson(jsonMap);
      // assert
      expect(result, tVenue);
    });
    test('VenueDetail json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('venue_detail.json'));
      // act
      final result = VenueDetailModel.fromJson(jsonMap);
      // assert
      expect(result, tVenueDetail);
    });
  });
  group('toJson', () {
    test('Venue model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "type": "Grocery",
        "description": null,
        "title": "Whole Foods Battery Park City",
        "timezone": "America/New_York",
        "image":
            "https://tracery-schedules-static.s3.amazonaws.com/media/venues/wholefoods.jpg",
        "phone": null,
        "email": null,
        "website": null,
        "coordinates": {"id": 2, "lat": 40.7158067, "lng": -74.0118043},
        "address": {
          "id": 1,
          "address_1": "270 Greenwich St",
          "address_2": "B4",
          "post_code": "10007",
          "city": "New York",
          "state": "NY"
        }
      };
      // act
      final result = tVenue.toJson();
      // assert
      expect(result, jsonMap);
    });
    test('VenueDetail model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "admin": {
          "id": 1,
          "first_name": "Sofiane",
          "last_name": "Larbi (Admin)"
        },
        "bookable_time_slots": [
          {
            "start": "2020-05-06T02:13:24.000",
            "stop": "2020-05-19T02:13:30.000",
            "max_attendees": 100,
            "num_attendees": 0,
            "id": 7,
            "current": true,
            "past": false,
            "type": "All"
          }
        ],
        "type": "Grocery",
        "description": null,
        "title": "Whole Foods Battery Park City",
        "timezone": "America/New_York",
        "image":
            "https://tracery-schedules-static.s3.amazonaws.com/media/venues/wholefoods.jpg",
        "phone": null,
        "email": null,
        "website": null,
        "coordinates": {"id": 2, "lat": 40.7158067, "lng": -74.0118043},
        "address": {
          "id": 1,
          "address_1": "270 Greenwich St",
          "address_2": "B4",
          "post_code": "10007",
          "city": "New York",
          "state": "NY"
        }
      };
      // act
      final result = tVenueDetail.toJson();
      result['admin'].removeWhere((key, value) => value == null);
      // assert
      expect(result, jsonMap);
    });
  });
}
