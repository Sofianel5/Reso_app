import 'package:Reso/features/reso/domain/entities/user.dart';
import 'package:Reso/features/reso/domain/repositories/root_repository.dart';
import 'package:Reso/features/reso/domain/usecases/login.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRootRepository extends Mock implements RootRepository {}

void main() {
  Login usecase;
  MockRootRepository mockRootRepository;

  setUp(() {
    mockRootRepository = MockRootRepository();
    usecase = Login(mockRootRepository);
  });
  final tUser = User();
  test('should login properly', () async {
    // arrange
    when(mockRootRepository.login(email: anyNamed("email"), password: anyNamed("password"))).thenAnswer((_) async => Right(tUser));
    // act 
    final result = await usecase(LoginParams(email: "slarbi10@stuy.edu", password: "214596983"));
    // asset
    expect(result, Right(tUser));
  });
}