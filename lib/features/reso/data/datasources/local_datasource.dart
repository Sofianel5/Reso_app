import 'dart:convert';

import 'package:Reso/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> getAuthToken() {}
  Future<void> cacheAuthToken(String token) {}
  Future<Map<String, dynamic>> getCachedSession() {}
  Future<void> cacheSession(Map<String, dynamic> session) {}
  Future<void> clearData() {}
}
const String AUTH_TOKEN_KEY = "authtoken";
const String SESSION_KEY = "sessionKey";

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
  Future<String> getAuthToken() {
    return _getString(AUTH_TOKEN_KEY);
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    return await _setString(AUTH_TOKEN_KEY, token);
  }


  @override
  Future<void> cacheSession(Map<String, dynamic> session) async {
    return await _setJson(SESSION_KEY, session);
  }

  @override
  Future<Map<String, dynamic>> getCachedSession() async {
    return await _getJson(SESSION_KEY);
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
}
