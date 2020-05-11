import 'package:Reso/core/errors/exceptions.dart';
import 'package:Reso/core/errors/failures.dart';
import 'package:Reso/core/network/network_info.dart';
import 'package:Reso/features/reso/data/datasources/local_datasource.dart';
import 'package:Reso/features/reso/data/datasources/remote_datasource.dart';
import 'package:Reso/features/reso/data/models/user_model.dart';
import 'package:Reso/features/reso/data/repositories/root_repository_imp.dart';
import 'package:Reso/features/reso/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  RootRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RootRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  String email = "sofiane@tracery.us";
  String password = "214596983";
  String firstName = "Sofiane";
  String lastName = "Larbi";
  int id = 1;
  String authToken = "HI";
  UserModel tUserModel = UserModel(
    email: email,
    id: id,
    firstName: firstName,
    lastName: lastName,
  );
  Map<String, dynamic> session = {"HI": "hi"};
  final User user = tUserModel;

  void runTestsOnline(Function body) {
    group("Tests online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group("Tests offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("getUser", () {
    test("should check if device has internet", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.login(email: email, password: password);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'getUser should return remote data when call to remote data source is successful and token available',
          () async {
        // arrange
        when(mockLocalDataSource.getAuthToken())
            .thenAnswer((_) async => authToken);
        when(mockRemoteDataSource.getUser(authToken))
            .thenAnswer((_) async => user);
        // act
        final result = await repository.getUser();
        // assert
        verify(mockRemoteDataSource.getUser(authToken));
        expect(result, Right(user));
      });

      test(
          'getUser should return AuthenticationFailure when call to local auth token unsuccessful',
          () async {
        // arrange
        when(mockLocalDataSource.getAuthToken()).thenThrow(CacheException());
        when(mockRemoteDataSource.getUser(authToken))
            .thenAnswer((_) async => user);
        // act
        final result = await repository.getUser();
        // assert
        verify(mockLocalDataSource.getAuthToken());
        expect(result, Left(AuthenticationFailure()));
      });
      test(
          'getUser should return ServerFailure when call to remote data source unsuccessful 500',
          () async {
        // arrange
        when(mockLocalDataSource.getAuthToken())
            .thenAnswer((_) async => authToken);
        when(mockRemoteDataSource.getUser(any)).thenThrow(ServerException());
        // act
        final result = await repository.getUser();
        // assert
        verify(mockLocalDataSource.getAuthToken());
        expect(result, Left(ServerFailure()));
      });

      test(
          'getUser should return AuthenticationFailure when call to remote data source unsuccessful 403',
          () async {
        // arrange
        when(mockLocalDataSource.getAuthToken())
            .thenAnswer((_) async => authToken);
        when(mockRemoteDataSource.getUser(any))
            .thenThrow(AuthenticationException());
        // act
        final result = await repository.getUser();
        // assert
        verify(mockLocalDataSource.getAuthToken());
        expect(result, Left(AuthenticationFailure()));
      });
    });
    runTestsOffline(() {
      test(
          'getUser should return ConnectionFailure when call to remote data source unsuccessful',
          () async {
        // arrange
        // act
        final result = await repository.getUser();
        // assert
        expect(result, Left(ConnectionFailure()));
      });
    });
  });
  group('login', () {
    test("should check if device has internet", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.login(email: email, password: password);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'login should return remote data when call to remote data source is successful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.login(
            email: anyNamed("email"),
            password: anyNamed("password"),
          ),
        ).thenAnswer((_) async => authToken);
        when(mockRemoteDataSource.getUser(authToken))
            .thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.login(email: email, password: password);
        // assert
        verify(
          mockRemoteDataSource.login(
            email: anyNamed("email"),
            password: anyNamed("password"),
          ),
        );
        expect(result, Right(user));
      });
      test(
          'login should cache data locally when call to remote data source is successful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.login(
            email: anyNamed("email"),
            password: anyNamed("password"),
          ),
        ).thenAnswer((_) async => authToken);
        // act
        await repository.login(email: email, password: password);
        // assert
        verify(
          mockRemoteDataSource.login(
            email: anyNamed("email"),
            password: anyNamed("password"),
          ),
        );
        verify(mockLocalDataSource.cacheAuthToken(any));
      });

      test(
          'login should return server failure when call to remote data source is unsuccessful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.login(
            email: anyNamed("email"),
            password: anyNamed("password"),
          ),
        ).thenThrow(ServerException());
        // act
        final result = await repository.login(email: email, password: password);
        // assert
        verify(
          mockRemoteDataSource.login(
            email: anyNamed("email"),
            password: anyNamed("password"),
          ),
        );
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test(
          'login should return connection failure when internet connection is unavailable',
          () async {
        // arrange
        // act
        final result = await repository.login(email: email, password: password);
        // assert
        expect(result, Left(ConnectionFailure()));
      });

      test(
          'getSession should return local cache data when internet connection is unavailable',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedSession())
            .thenAnswer((realInvocation) async => session);
        // act
        final result = await repository.getSession();

        // assert
        expect(result, Right(session));
      });

      test(
          'getSession should return AuthenticationFailure when internet connection is unavailable and no previous caches',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedSession())
            .thenThrow(CacheException());
        // act
        final result = await repository.getSession();
        // assert
        expect(result, Left(AuthenticationFailure()));
      });
    });
  });

  group("getSession", () {
    test("should check if device has internet", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.login(email: email, password: password);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return remote data when call to remote data source is successful',
          () async {
        // arrange
        when(mockLocalDataSource.getAuthToken()).thenAnswer((_) async => authToken);
        when(
          mockRemoteDataSource.getSession(authToken),
        ).thenAnswer((_) async => session);
        // act
        final result = await repository.getSession();
        // assert
        verify(mockLocalDataSource.getAuthToken());
        verify(
          mockRemoteDataSource.getSession(
            authToken
          ),
        );
        expect(result, Right(session));
      });

      test(
          'should cache data locally when call to remote data source is successful',
          () async {
        // arrange
        when(
          mockLocalDataSource.getAuthToken(),
        ).thenAnswer((_) async => authToken);
        when(
          mockRemoteDataSource.getSession(authToken),
        ).thenAnswer((_) async => session);
        // act
        await repository.getSession();
        // assert
        verify(
          mockLocalDataSource.getAuthToken()
        );
        verify(mockRemoteDataSource.getSession(authToken));
        verify(mockLocalDataSource.cacheSession(session));
      });
      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.getSession(any),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getSession();
        // assert
        verify(
          mockRemoteDataSource.getSession(any),
        );
        expect(result, Left(ServerFailure()));
      });
    });
  });
  group("signup", () {
    test("should check if device has internet", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.login(email: email, password: password);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when call to remote data source is successful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          ),
        ).thenAnswer((_) async => authToken);
        when(mockRemoteDataSource.getUser(authToken))
            .thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName);
        // assert
        verify(
          mockRemoteDataSource.getUser(
            authToken
          ),
        );
        expect(result, Right(user));
      });

      test(
          'should cache data locally when call to remote data source is successful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          ),
        ).thenAnswer((_) async => authToken);
        // act
        await repository.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName);
        // assert
        verify(
          mockRemoteDataSource.getUser(authToken)
        );
        verify(mockLocalDataSource.cacheAuthToken(authToken));
      });
      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        // arrange
        when(
          mockRemoteDataSource.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          ),
        ).thenThrow(ServerException());
        // act
        final result = await repository.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName);
        // assert
        verify(
          mockRemoteDataSource.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          ),
        );
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'should return connection failure when internet connection is unavailable',
          () async {
        // arrange
        // act
        final result = await repository.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName);
        // assert
        expect(result, Left(ConnectionFailure()));
      });
    });
  });
}
