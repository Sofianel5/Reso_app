import 'package:Reso/features/reso/domain/entities/user.dart';
import 'package:Reso/features/reso/domain/repositories/root_repository.dart';
import 'package:Reso/features/reso/domain/usecases/signup.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRootRepository extends Mock implements RootRepository {}

void main() {
  Signup usecase;
  MockRootRepository mockRootRepository;

  setUp(() {
    mockRootRepository = MockRootRepository();
    usecase = Signup(mockRootRepository);
  });
  final tUser = User();
  test('should sign up properly', () async {
    // arrange
    when(mockRootRepository.signUp(email: anyNamed("email"), password: anyNamed("password"), firstName: anyNamed("firstName"), lastName: anyNamed("lastName"))).thenAnswer((_) async => Right(tUser));
    // act 
    final result = await usecase(SignupParams(email: "slarbi10@stuy.edu", password: "214596983", firstName: "Sofiane", lastName: "Larbi"));
    // asset
    expect(result, Right(tUser));
  });
}