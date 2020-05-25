import 'dart:convert';


import 'package:Reso/features/reso/data/models/coordinates_model.dart';

import 'package:Reso/features/reso/domain/entities/coordinates.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tcoords = CoordinatesModel(id: 1, lat: 40.712776, lng: -74.005974);

  test('should be subclass of Coordinates entity', () async {
    // assert
    expect(tcoords, isA<Coordinates>());
  });
  group('fromJson', () {
    test('coordinates json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('coordinates.json'));
      // act
      final result = CoordinatesModel.fromJson(jsonMap);
      // assert
      expect(result, tcoords);
    });
  });
  group('toJson', () {
    test('coodinates model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "lat": 40.712776,
        "lng": -74.005974
      };
      // act
      final result = tcoords.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
