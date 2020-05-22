import 'dart:convert';

import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/coordinates.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/venue.dart';
import '../models/coordinates_model.dart';
import '../models/user_model.dart';
import '../models/venue_model.dart';

abstract class LocalDataSource {
  Future<String> getAuthToken() {}
  Future<void> cacheAuthToken(String token) {}
  Future<void> clearData() {}
  Future<Coordinates> getCoordinates() {}
  Future<void> cacheVenues(List<VenueModel> venues) {}
  Future<List<Venue>> getCachedVenues() {}
  Future<void> cacheUser(UserModel user) {}
  Future<User> getCachedUser() {}
}

const String AUTH_TOKEN_KEY = "authtoken";
const String VENUES_KEY = "venues";
const String USER_KEY = "user";

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  LocalDataSourceImpl(this.sharedPreferences);

  Future<String> _getString(String key) {
    final String str = sharedPreferences.getString(key);
    if (str != null) {
      return Future.value(str);
    } else {
      throw CacheException();
    }
  }

  Future<Map<String, dynamic>> _getJson(String key) async {
    try {
      String result = await _getString(key);
      return json.decode(result);
    } on CacheException {
      throw CacheException();
    }
  }

  Future<void> _setString(String key, String value) async {
    try {
      sharedPreferences.setString(key, value);
      return;
    } on Exception {
      throw CacheException();
    }
  }

  Future<void> _setJson(String key, Map<String, dynamic> data) async {
    try {
      final String str = json.encode(data);
      return await _setString(key, str);
    } on CacheException {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheVenues(List<VenueModel> venues) async {
    List<Map<String, dynamic>> venueJson = [];
    for (var venue in venues) {
      venueJson.add(venue.toJson());
    }
    String encoded = json.encode(venueJson);
    return await _setString(VENUES_KEY, encoded);
  }

  @override
  Future<List<Venue>> getCachedVenues() async {
    String venueJsonEncode = await _getString(VENUES_KEY);
    List<Map<String, dynamic>> venueJson = json.decode(venueJsonEncode);
    List<Venue> venues = [];
    for (var venueMap in venueJson) {
      venues.add(VenueModel.fromJson(venueMap));
    }
    return venues;
  }

  @override
  Future<String> getAuthToken() {
    return _getString(AUTH_TOKEN_KEY);
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    return await _setString(AUTH_TOKEN_KEY, token);
  }

  @override
  Future<void> clearData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
      return;
    } catch (e) {
      throw CacheException();
    }
  }

  Future<Coordinates> getCoordinates() async {
    try {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

     geo.Position position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.low);
      print("location");
      Map<String, double> coordinates = {
        "lat": position.latitude,
        "lng": position.longitude
      };
      final coords = CoordinatesModel.fromJson(coordinates);
      return coords;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    Map<String, dynamic> userJson = user.toJson();
    return await _setJson(USER_KEY, userJson);
  }

  @override
  Future<User> getCachedUser() async {
    Map<String, dynamic> userJson = await _getJson(USER_KEY);
    return UserModel.fromJson(userJson);
  }
}
