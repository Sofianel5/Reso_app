import 'dart:convert';

import 'package:Reso/features/reso/data/models/thread_model.dart';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:Reso/features/reso/data/models/venue_model.dart';
import 'package:Reso/features/reso/domain/entities/thread.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tThread = ThreadModel(
    id: 1,
    venue: VenueModel(id: 1, title: "Whole Foods Battery Park City"),
    user: UserModel(id: 2, firstName: "Sofiane", lastName: "Larbi"),
    fromConfirmed: false,
    toConfirmed: false,
    time: DateTime.parse("2020-04-30T01:45:05.392469"),
    threadId: "affd0e61-a645-476e-8c4a-2d36e5ce1861",
  );
  test('should be subclass of Thread entity', () async {
    // assert
    expect(tThread, isA<Thread>());
  });
  group('fromJson', () {
    test('Thread json should return valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('thread.json'));
      // act
      final result = ThreadModel.fromJson(jsonMap);
      // assert
      expect(result, tThread);
    });
  });
  group('toJson', () {
    test('Thread model should return valid json', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "venue": {"id": 1, "title": "Whole Foods Battery Park City"},
        "user": {"id": 2, "first_name": "Sofiane", "last_name": "Larbi"},
        "from_confirmed": false,
        "to_confirmed": false,
        "time": "2020-04-30T01:45:05.392469",
        "thread_id": "affd0e61-a645-476e-8c4a-2d36e5ce1861"
      };
      // act
      final result = tThread.toJson();
      result.removeWhere((key, value) => value == null);
      result['venue'].removeWhere((key, value) => value == null);
      result['user'].removeWhere((key, value) => value == null);
      // assert
      expect(result, jsonMap);
    });
  });
}
