import 'package:Reso/core/errors/exceptions.dart';
import 'package:Reso/core/localizations/messages.dart';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:Reso/features/reso/data/models/venue_model.dart';
import 'package:Reso/features/reso/domain/entities/coordinates.dart';
import 'package:Reso/features/reso/domain/entities/thread.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
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
        print("Auth exception");
        return Left(AuthenticationFailure(message: Messages.INVALID_PASSWORD));
      } on ServerException {
        return Left(ServerFailure(message: Messages.SERVER_FAILURE));
      } on CacheException {
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      } catch (e) {
        return Left(AuthenticationFailure(message: Messages.UNKNOWN_ERROR));
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
      Map<String, dynamic> header = Map<String, dynamic>.from(<String, String>{
        "Authorization": "Token " + authToken.toString(),
      });
      final UserModel user = await remoteDataSource.getUser(header);
      try {
        localDataSource.cacheUser(user);
      } catch (e) {
        print(e);
      }
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, User>> login({String email, String password}) async {
    return await _getUser(() async {
      final String authToken =
          await remoteDataSource.login(email: email, password: password);
      print("trying to cache token");
      localDataSource.cacheAuthToken(authToken);
      Map<String, String> header = Map<String, String>.from(<String, String>{
        "Authorization": "Token " + authToken.toString(),
      });
      print("getting user");
      final User user = await remoteDataSource.getUser(header);
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, VenueDetail>> getVenue({@required int pk}) async {
    if (await networkInfo.isConnected) {
      try {
        String authToken = await localDataSource.getAuthToken();
        Map<String, String> headers = Map<String, String>.from(<String, String>{
          "Authorization": "Token " + authToken.toString(),
        });
        return Right(await remoteDataSource.getVenue(pk: pk, headers: headers));
      } on AuthenticationException {
        // Some error like 403
        print("Auth exception");
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } on ServerException {
        return Left(ServerFailure(message: Messages.SERVER_FAILURE));
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        return Left(AuthenticationFailure(message: Messages.UNKNOWN_ERROR));
      }
    } else {
      // No internet
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
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
      Map<String, dynamic> header = Map<String, dynamic>.from(
          {"Authorization": "Token " + authToken.toString()});
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
      } catch (e) {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Venue>>> getVenues({String search}) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        final Coordinates coordinates = await localDataSource.getCoordinates();
        Map<String, dynamic> header = Map<String, dynamic>.from({
          "Authorization": "Token " + authToken.toString(),
          "LAT": coordinates == null ? "" : coordinates.lat.toString(),
          "LNG": coordinates == null ? "" : coordinates.lng.toString()
        });
        List<VenueModel> venues =
            await remoteDataSource.getVenues(header, searchQ: search);
        try {
          localDataSource.cacheVenues(venues);
        } catch (e) {
          print(e);
        }
        return Right(venues);
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
        return Right(await localDataSource.getCachedVenues());
      } on CacheException {
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      } catch (e) {
        return Left(UnknownFailure());
      }
    }
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

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      return Right(await localDataSource.getCachedUser());
    } on CacheException {
      return Left(CacheFailure(message: Messages.NO_USER));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleLockState() async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, dynamic> header = Map<String, dynamic>.from(
            {"Authorization": "Token " + authToken.toString()});
        bool lockState = await remoteDataSource.toggleLockState(header);
        return Right(lockState);
      } on AuthenticationException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, Thread>> checkForScan() async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, dynamic> header = Map<String, dynamic>.from(
            {"Authorization": "Token " + authToken.toString()});
        Thread thread = await remoteDataSource.checkForScan(header);
        return Right(thread);
      } on NoScanException {
        return Left(NoScanFailure());
      } on AuthenticationException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmScan(Thread thread) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, dynamic> header = Map<String, dynamic>.from(
            {"Authorization": "Token " + authToken.toString()});
        bool res = await remoteDataSource.confirmThread(thread.id, header);
        return Right(res);
      } on AuthenticationException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }
}
