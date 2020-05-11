import 'package:Reso/core/errors/exceptions.dart';
import 'package:Reso/features/reso/data/datasources/local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalDataSourceImpl localDataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = LocalDataSourceImpl(mockSharedPreferences);
  });
  final String authToken = "HI :)";
  final String authTokenKey = "authtoken";
  group('getAuthToken', () {
    test("should return auth token when it is stored", () async {
      // arrange 
      when(mockSharedPreferences.getString(AUTH_TOKEN_KEY)).thenReturn(authToken);
      // act 
      final result = await localDataSource.getAuthToken();
      // assert 
      verify(mockSharedPreferences.getString(AUTH_TOKEN_KEY));
      expect(result, authToken);
    });
    test("should return CacheException when it is not stored", () async {
      // arrange 
      when(mockSharedPreferences.getString(AUTH_TOKEN_KEY)).thenReturn(null);
      final call = localDataSource.getAuthToken;
      // act 
      // assert 
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      verify(mockSharedPreferences.getString(authTokenKey));
    });
  });

  group("cacheAuthToken", () {
    test("should call SharedPreferences to cache the data", () async {
      // arrange 
      // act 
      localDataSource.cacheAuthToken(authToken);
      // assert 
      verify(mockSharedPreferences.setString(AUTH_TOKEN_KEY, authToken));
    });
  });
}