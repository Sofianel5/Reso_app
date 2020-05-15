import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/urls.dart';
import '../../domain/entities/thread.dart';
import '../../domain/entities/venue.dart';
import '../models/thread_model.dart';
import '../models/user_model.dart';
import '../models/venue_model.dart';

abstract class RemoteDataSource {
  Future<String> login({String email, String password});
  Future<String> signUp(
      {String email, String password, String firstName, String lastName});
  Future<UserModel> getUser(Map<String, dynamic> headers);
  Future<List<VenueModel>> getVenues(Map<String, dynamic> headers,
      {int n: 12, int page: 1, String searchQ});
  Future<VenueDetail> getVenue({int pk, Map<String, dynamic> headers});
  Future<bool> toggleLockState(Map<String, dynamic> headers);
  Future<Thread> checkForScan(Map<String, dynamic> headers);
  Future<bool> confirmThread(int threadId, Map<String, dynamic> headers);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  RemoteDataSourceImpl({@required this.client});

  String urlEncodeMap(Map<String, String> data) {
    return data.keys
        .map((key) =>
            "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}")
        .join("&");
  }

  Future<http.Response> _getResponse(Map<String, dynamic> data, String url,
      {Map<String, dynamic> headers, bool getMethod = false}) async {
    try {
      print("going to post");
      http.Response response;
      if (getMethod) {
        String urlParams = urlEncodeMap(data);
        response = await client.get(url + "?" + urlParams,
            headers: headers ?? <String, String>{});
      } else {
        response = await client.post(url,
            body: data, headers: headers ?? <String, String>{});
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode ~/ 100 == 4) {
        throw AuthenticationException();
      } else if (response.statusCode ~/ 100 == 5) {
        throw ServerException();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> _getJson(Map<String, dynamic> data, String url,
      {Map<String, dynamic> headers, bool useGet = true}) async {
    try {
      String responseBody =
          (await _getResponse(data, url, headers: headers, getMethod: useGet))
              .body;
      print("get body");
      Map<String, dynamic> responseJson =
          Map<String, dynamic>.from(jsonDecode(responseBody));
      return responseJson;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<String> login({String email, String password}) async {
    try {
      Map<String, String> data = <String, String>{
        "email": email,
        "password": password,
      };
      var jsonData;
      var response = await client.post(Urls.LOGIN_URL, body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        return jsonData["auth_token"];
      } else if (response.statusCode / 100 == 4) {
        throw AuthenticationException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<String> signUp(
      {String email,
      String password,
      String firstName,
      String lastName}) async {
    try {
      Map<String, String> data = {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
      };
      http.Response response = await client.post(Urls.SIGNUP_URL, body: data);
      Map<String, dynamic> responseJsonData =
          Map<String, dynamic>.from(json.decode(response.body));
      if (response.statusCode == 201) {
        String token = await login(
            email: responseJsonData["email"], password: data['password']);
        return token;
      } else {
        if (responseJsonData["password"] != null) {
          throw SignUpException(
              message:
                  "Please provide valid entries to all fields. Note your password must not be too short or common.");
        } else if (responseJsonData["email"] != null &&
            responseJsonData["email"]
                .contains("account with this Email already exists.")) {
          throw SignUpException(
              message:
                  "Please provide valid entries to all fields. Note this email is already associated with an account.");
        } else {
          throw SignUpException(
              message: "Please provide valid entries to all fields.");
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<UserModel> getUser(Map<String, dynamic> headers) async {
    try {
      final Map<String, dynamic> jsonData = Map<String, dynamic>.from(
          await _getJson(<String, String>{}, Urls.USER_URL,
              headers: Map<String, String>.from(headers)));
      return UserModel.fromJson(jsonData);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<VenueDetail> getVenue({int pk, Map<String, dynamic> headers}) async {
    try {
      final Map<String, dynamic> jsonData = Map<String, dynamic>.from(
          await _getJson(<String, String>{}, Urls.getVenueForId(pk),
              headers: Map<String, String>.from(headers)));
      return VenueDetailModel.fromJson(jsonData);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<VenueModel>> getVenues(Map<String, dynamic> headers,
      {n: 12, page: 1, String searchQ}) async {
    var response;
    if (searchQ != null) {
      response =
          await http.get(Urls.SEARCH_URL + "?q=" + searchQ, headers: headers);
    } else {
      response = await http.get(
          Urls.GET_VENUES + "?page=" + page.toString() + "&n=" + n.toString(),
          headers: headers);
    }
    var responseJson;
    print(response.body);
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      print(responseJson);
      List<VenueModel> venues = [];
      for (var venue in responseJson) {
        print(VenueModel.fromJson(venue));
        venues.add(VenueModel.fromJson(venue));
      }
      return venues;
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> toggleLockState(Map<String, dynamic> headers) async {
    var response = await http.post(
      Urls.TOGGLE_LOCK_STATE,
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson["is_locked"];
    } else {
      throw AuthenticationException();
    }
  }

  @override
  Future<Thread> checkForScan(Map<String, dynamic> headers) async {
    final response = await http.get(
                        Urls.CHECK_FOR_VENUE_SCAN,
                        headers: headers,
                    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return ThreadModel.fromJson(responseJson);
    } else if (response.statusCode == 404) {
      throw NoScanException();
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> confirmThread(int threadId, Map<String, dynamic> headers) async {
    final response = await http.post(Urls.USER_CONFIRM_ENTRY,
          headers: headers,
          body: <String,String>{'thread': threadId.toString(), 'sent_by_self': "false"});
    if (response.statusCode == 200) {
      return true;
    } else {
      throw AuthenticationException();
    }
  }
}
