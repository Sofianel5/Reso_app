import 'dart:convert';

import 'package:Reso/features/reso/data/models/address_model.dart';
import 'package:Reso/features/reso/domain/entities/address.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final taddy = AddressModel(id: 1, address_1: "270 Greenwich St", address_2: "B4", postCode: "10007", city: "New York", state: "NY");

  test('should be subclass of Address entity', () async {
    // assert
    expect(taddy, isA<Address>());
  });
  group('fromJson', () {
    test('address json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('address.json'));
      // act
      final result = AddressModel.fromJson(jsonMap);
      // assert
      expect(result, taddy);
    });
  });
  group('toJson', () {
    test('address model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "address_1": "270 Greenwich St",
        "address_2": "B4",
        "post_code": "10007",
        "city": "New York",
        "state": "NY"
      };
      // act
      final result = taddy.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
