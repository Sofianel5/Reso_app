
import 'package:Reso/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfoImpl;
  
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group("isConnected", () {
    test("should forward call to DataConnectionChecker.hasConnection", () async {
      // arrange 
      final hasConnFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => hasConnFuture);
      // act
      final result = networkInfoImpl.isConnected;
      // assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, hasConnFuture);
    });
  });
}