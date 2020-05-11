import 'package:Reso/features/reso/domain/entities/user.dart';

abstract class RemoteDataSource {
  Future<String> login({String email, String password});
  Future<String> signUp(
      {String email, String password, String firstName, String lastName});
  Future<User> getUser(String authToken);
  Future<Map<String, dynamic>> getSession(String authToken);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<String> login({String email, String password}) {
    // TODO: implement getSession
    throw UnimplementedError();
  }

  @override
  Future<String> signUp(
      {String email, String password, String firstName, String lastName}) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUser(String authToken) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getSession(String authToken) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
