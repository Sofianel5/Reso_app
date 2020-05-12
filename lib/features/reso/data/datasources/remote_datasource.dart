import 'dart:convert';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:Reso/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../../core/network/urls.dart';
import '../../domain/entities/user.dart';

abstract class RemoteDataSource {
  Future<String> login({String email, String password});
  Future<String> signUp(
      {String email, String password, String firstName, String lastName});
  Future<User> getUser(Map<String, dynamic> headers);
  Future<Map<String, dynamic>> getSession(Map<String, dynamic> headers);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  RemoteDataSourceImpl({@required this.client});

  Future<http.Response> _getResponse(Map<String, dynamic> data, String url,
      {Map<String, dynamic> headers}) async {
    try {
      final response = await client.post(url, body: data, headers: headers ?? {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode / 100 == 4) {
        throw AuthenticationException();
      } else if (response.statusCode / 100 == 5) {
        throw ServerException();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> _getJson(Map<String, dynamic> data, String url,
      {Map<String, dynamic> headers}) async {
    try {
      String responseBody = (await _getResponse(data, url, headers: headers)).body;
      return json.decode(responseBody);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> login({String email, String password}) async {
    try {
      Map data = {
        "email": email,
        "password": password,
      };
      var jsonData;
      var response = await client.post(Urls.LOGIN_URL, body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        return jsonData["auth_token"];
      } else if (response.statusCode/100 == 4){
        throw AuthenticationException();
      } else {
        throw ServerException();
      }
    } catch (e) {
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
      Map data = {
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
  Future<User> getUser(Map<String, dynamic> headers) async {
    try {
      final Map<String, dynamic> jsonData = Map<String, dynamic>.from(
          await _getJson({}, Urls.USER_URL, headers: headers));
      return UserModel.fromJson(jsonData);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>> getSession(Map<String, dynamic> headers) {
    return null;
  }
}
