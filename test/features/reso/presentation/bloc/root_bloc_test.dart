import 'package:Reso/core/network/network_info.dart';
import 'package:Reso/core/util/input_converter.dart';
import 'package:Reso/features/reso/domain/usecases/get_user.dart';
import 'package:Reso/features/reso/domain/usecases/login.dart';
import 'package:Reso/features/reso/domain/usecases/logout.dart';
import 'package:Reso/features/reso/domain/usecases/signup.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetExistingUser extends Mock implements GetExistingUser {}

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class MockLogout extends Mock implements Logout {}

class MockInputConverter extends Mock implements InputConverter {}

class MockNetworkInfoImpl extends Mock implements NetworkInfoImpl {}

void main() {
  RootBloc bloc;
  MockGetExistingUser mockGetExistingUser;
  MockLogin mockLogin;
  MockSignup mockSignup;
  MockLogout mockLogout;

  MockInputConverter mockInputConverter;
  setUp(() {
    mockGetExistingUser = MockGetExistingUser();
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    mockLogout = MockLogout();
    mockInputConverter = MockInputConverter();
    bloc = RootBloc(getExistingUser: mockGetExistingUser, login: mockLogin, signup: mockSignup, logout: mockLogout, inputConverter: mockInputConverter);
  });

  test('initial state is InitialState', () {
    expect(bloc.initialState, InitialState());
  });
  group("getExistingUser", () {
    test("should check to see if token cached", () {
      // arrange 

      // act 
      // assert 
    });
    test("should emit ErrorState if unable to connect to internet", () {
      // arrange 

      // act 
      // assert 
    });
    test("")
  });
}