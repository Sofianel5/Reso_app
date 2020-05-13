import 'package:Reso/core/errors/exceptions.dart';
import 'package:Reso/core/localizations/messages.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/root_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';

typedef Future<Either<Failure, User>> _GetUser();
typedef Future<Either<Failure, Map<String, dynamic>>> _GetMap();

class RootRepositoryImpl implements RootRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final LocalDataSource localDataSource;

  RootRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.localDataSource,
  });

  Future<Either<Failure, User>> _getUser(_GetUser body) async {
    if (await networkInfo.isConnected) {
      try {
        return await body();
      } on AuthenticationException {
        // Some error like 403
        return Left(AuthenticationFailure(message: Messages.INVALID_PASSWORD));
      } on ServerException {
        return Left(ServerFailure(message: Messages.SERVER_FAILURE));
      } on CacheException {
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      }
    } else {
      // No internet
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    return await _getUser(() async {
      final String authToken = await localDataSource.getAuthToken();
      Map<String, dynamic> header = Map<String, dynamic>.from({
        "Authorization": "Token " + authToken.toString()
      });
      final User user = await remoteDataSource.getUser(header);
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, User>> login({String email, String password}) async {
    return await _getUser(() async {
      final String authToken =
          await remoteDataSource.login(email: email, password: password);
      localDataSource.cacheAuthToken(authToken);
      Map<String, dynamic> header = Map<String, dynamic>.from({
        "Authorization": "Token " + authToken.toString()
      });
      final User user = await remoteDataSource.getUser(header);
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, User>> signUp(
      {String email,
      String password,
      String firstName,
      String lastName}) async {
    return await _getUser(() async {
      final String authToken = await remoteDataSource.signUp(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName);
      localDataSource.cacheAuthToken(authToken);
      Map<String, dynamic> header = Map<String, dynamic>.from({
        "Authorization": "Token " + authToken.toString()
      });
      final User user = await remoteDataSource.getUser(header);
      return Right(user);
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> _getMap(
      _GetMap remote, _GetMap local) async {
    if (await networkInfo.isConnected) {
      try {
        return await remote();
      } on AuthenticationException {
        // Some error like 403
        return Left(AuthenticationFailure(message: Messages.INVALID_PASSWORD));
      } on ServerException {
        // Some server error 500
        return Left(ServerFailure(message: Messages.SERVER_FAILURE));
      } on CacheException {
        // No stored auth token
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      }
    } else {
      try {
        return await local();
      } on CacheException {
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSession() async {
    return await _getMap(() async {
      final String authToken = await localDataSource.getAuthToken();
      Map<String, dynamic> header = Map<String, dynamic>.from({
        "Authorization": "Token " + authToken.toString()
      });
      final Map<String, dynamic> session =
          await remoteDataSource.getSession(header);
      await localDataSource.cacheSession(session);
      return Right(session);
    }, () async {
      final Map<String, dynamic> session =
          await localDataSource.getCachedSession();
      return Right(session);
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearData();
      return Right(null);
    } on CacheException {
      return Left(CacheFailure(message: Messages.CACHE_WRITE_FAILURE));
    }
  }

}
