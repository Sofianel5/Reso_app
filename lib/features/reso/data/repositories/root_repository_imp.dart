import 'package:Reso/core/errors/exceptions.dart';
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
        return Left(AuthenticationFailure());
      } on ServerException {
        // Some server error 500
        return Left(ServerFailure());
      } on CacheException {
        // No stored auth token
        return Left(AuthenticationFailure());
      }
    } else {
      // No internet
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    return await _getUser(() async {
      final String authToken = await localDataSource.getAuthToken();
      final User user = await remoteDataSource.getUser(authToken);
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, User>> login({String email, String password}) async {
    return await _getUser(() async {
      final String authToken =
            await remoteDataSource.login(email: email, password: password);
        localDataSource.cacheAuthToken(authToken);
        final User user = await remoteDataSource.getUser(authToken);
        return Right(user);
    });
  }

  @override
  Future<Either<Failure, User>> signUp(
      {String email, String password, String firstName, String lastName}) async {
    return await _getUser(() async {
      final String authToken = await remoteDataSource.signUp(email: email, password: password, firstName: firstName, lastName: lastName);
        localDataSource.cacheAuthToken(authToken);
        final User user = await remoteDataSource.getUser(authToken);
        return Right(user);
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> _getMap(_GetMap remote, _GetMap local) async {
    if (await networkInfo.isConnected) {
      try {
        return await remote();
      } on AuthenticationException {
        // Some error like 403
        return Left(AuthenticationFailure());
      } on ServerException {
        // Some server error 500
        return Left(ServerFailure());
      } on CacheException {
        // No stored auth token
        return Left(AuthenticationFailure());
      }
    } else {
      try {
        return await local();
      } on CacheException {
        return Left(AuthenticationFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSession() async {
    return await _getMap(() async {
      final String authToken = await localDataSource.getAuthToken();
        final Map<String, dynamic> session = await remoteDataSource.getSession(authToken);
        await localDataSource.cacheSession(session);
        return Right(session);
    }, () async {
      final Map<String, dynamic> session = await localDataSource.getCachedSession();
      return Right(session);
    });
  }
}
