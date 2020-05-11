import 'dart:convert';

import 'package:Reso/features/reso/data/models/address_model.dart';
import 'package:Reso/features/reso/data/models/coordinates_model.dart';
import 'package:Reso/features/reso/data/models/timeslot_model.dart';
import 'package:Reso/features/reso/data/models/venue_model.dart';
import 'package:Reso/features/reso/domain/entities/timeslot.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTslot = TimeSlotModel(
    start: DateTime.parse("2020-04-29T12:00:00"),
    stop: DateTime.parse("2020-04-29T18:00:00"),
    maxAttendees: 100,
    numAttendees: 1,
    id: 1,
    current: false,
    past: true,
    type: "All",
  );
  final tTslotDetail = TimeSlotDetailModel(
    start: DateTime.parse("2020-04-29T12:00:00"),
    stop: DateTime.parse("2020-04-29T18:00:00"),
    maxAttendees: 100,
    numAttendees: 1,
    id: 1,
    current: false,
    past: true,
    venue: VenueModel(
      id: 1,
      type: "Grocery",
      description: null,
      title: "Whole Foods Battery Park City",
      timezone: "America/New_York",
      image:
          "https://tracery-schedules-static.s3.amazonaws.com/media/venues/wholefoods.jpg",
      coordinates: CoordinatesModel(id: 2, lat: 40.7158067, lng: -74.0118043),
      address: AddressModel(
          id: 1,
          address_1: "270 Greenwich St",
          address_2: "B4",
          postCode: "10007",
          city: "New York",
          state: "NY"),
    ),
    type: "All",
  );

  test('should be subclass of TimeSlot entity', () async {
    // assert
    expect(tTslot, isA<TimeSlot>());
    expect(tTslotDetail, isA<TimeSlot>());
  });
  group('fromJson', () {
    test('timeslot json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('timeslot.json'));
      // act
      final result = TimeSlotModel.fromJson(jsonMap);
      // assert
      expect(result, tTslot);
    });
    test('timeslotdetail json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('timeslot.json'));
      // act
      final result = TimeSlotDetailModel.fromJson(jsonMap);
      // assert
      expect(result, tTslotDetail);
    });
  });
  group('toJson', () {
    test('timeslot model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "start": "2020-04-29T12:00:00.000",
        "stop": "2020-04-29T18:00:00.000",
        "max_attendees": 100,
        "num_attendees": 1,
        "id": 1,
        "current": false,
        "past": true,
        "type": "All"
      };
      // act
      final result = tTslot.toJson();
      // assert
      expect(result, jsonMap);
    });
    test('timeslot detail model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "start": "2020-04-29T12:00:00.000",
        "stop": "2020-04-29T18:00:00.000",
        "max_attendees": 100,
        "num_attendees": 1,
        "id": 1,
        "current": false,
        "past": true,
        "venue": {
          "id": 1,
          "type": "Grocery",
          "description": null,
          'phone': null,
          'email': null,
          'website': null,
          "title": "Whole Foods Battery Park City",
          "timezone": "America/New_York",
          "image":
              "https://tracery-schedules-static.s3.amazonaws.com/media/venues/wholefoods.jpg",
          "coordinates": {"id": 2, "lat": 40.7158067, "lng": -74.0118043},
          "address": {
            "id": 1,
            "address_1": "270 Greenwich St",
            "address_2": "B4",
            "post_code": "10007",
            "city": "New York",
            "state": "NY"
          }
        },
        "type": "All"
      };
      // act
      final result = tTslotDetail.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
