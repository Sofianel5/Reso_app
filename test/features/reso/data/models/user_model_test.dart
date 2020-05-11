import 'dart:convert';

import 'package:Reso/features/reso/data/models/address_model.dart';
import 'package:Reso/features/reso/data/models/coordinates_model.dart';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:Reso/features/reso/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final userExternal = UserModel(
    id: 1,
    firstName: "Sofiane",
    lastName: "Larbi (Admin)",
  );
  final userInternal = UserModel(
    id: 1,
    email: "sofiane@tracery.us",
    publicId: "f4e7bb07-f125-41ed-8f99-4418b4ac67d3",
    dateJoined: DateTime.parse("2020-04-26T23:50:16.074202"),
    firstName: "Sofiane",
    lastName: "Larbi (Admin)",
    isLocked: true,
    coordinates: CoordinatesModel(id: 1, lat: 40.712776, lng: -74.005974),
    address: AddressModel(
      id: 1,
      address_1: "270 Greenwich St",
      address_2: "B4",
      postCode: "10007",
      city: "New York",
      state: "NY",
    ),
  );

  test('should be subclass of User entity', () async {
    // assert
    expect(userExternal, isA<User>());
  });

  group('fromJson', () {
    test('internal user json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('user_internal.json'));
      // act
      final result = UserModel.fromJson(jsonMap);
      // assert
      expect(result, userInternal);
      expect(result.isLocked, true);
    });
    test('external user json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('user_external.json'));
      // act
      final result = UserModel.fromJson(jsonMap);
      // assert
      expect(result, userExternal);
    });
  });
  group('toJson', () {
    test('internal user model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "email": "sofiane@tracery.us",
        "public_id": "f4e7bb07-f125-41ed-8f99-4418b4ac67d3",
        "date_joined": "2020-04-26T23:50:16.074202",
        "first_name": "Sofiane",
        "last_name": "Larbi (Admin)",
        "is_locked": true,
        "coordinates": {"id": 1, "lat": 40.712776, "lng": -74.005974},
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
      final result = userInternal.toJson();
      // assert
      expect(result, jsonMap);
    });
    test('external user model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        'email': null,
        'public_id': null,
        'date_joined': null,
        "first_name": "Sofiane",
        "last_name": "Larbi (Admin)",
        'is_locked': null,
        'coordinates': null,
        'address': null
      };
      // act
      final result = userExternal.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
