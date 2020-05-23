import 'dart:convert';

import 'package:Reso/features/reso/data/models/handshake_model.dart';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:Reso/features/reso/data/models/venue_model.dart';
import 'package:Reso/features/reso/domain/entities/handshake.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tshake = HandshakeModel(
      id: 1,
      user: UserModel(id: 1, firstName: "Sofiane", lastName: "Larbi (Admin)"),
      venue: VenueModel(id: 1, title: "Whole Foods Battery Park City"),
      time: DateTime.parse("2020-05-11T00:31:16.505581"));

  test('should be subclass of Handshake entity', () async {
    // assert
    expect(tshake, isA<Handshake>());
  });
  group('fromJson', () {
    test('handshake.json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('handshake.json'));
      // act
      final result = HandshakeModel.fromJson(jsonMap);
      // assert
      expect(result, tshake);
    });
  });
  group('toJson', () {
    test('handshake model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "user": {
          "id": 1,
          "first_name": "Sofiane",
          "last_name": "Larbi (Admin)",
          'email': null,
          'public_id': null,
          'date_joined': null,
          'is_locked': null,
          'coordinates': null,
          'address': null
        },
        "venue": {
          "id": 1,
          "title": "Whole Foods Battery Park City",
          'type': null,
          'description': null,
          'timezone': null,
          'image': null,
          'phone': null,
          'email': null,
          'website': null,
          'coordinates': null,
          'address': null
        },
        "time": "2020-05-11T00:31:16.505581"
      };
      // act
      final result = tshake.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
