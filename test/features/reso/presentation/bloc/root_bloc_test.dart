import 'package:Reso/core/errors/failures.dart';
import 'package:Reso/core/localizations/messages.dart';
import 'package:Reso/core/network/network_info.dart';
import 'package:Reso/core/util/input_converter.dart';
import 'package:Reso/features/reso/domain/entities/user.dart';
import 'package:Reso/features/reso/domain/usecases/get_session.dart';
import 'package:Reso/features/reso/domain/usecases/get_user.dart';
import 'package:Reso/features/reso/domain/usecases/login.dart';
import 'package:Reso/features/reso/domain/usecases/logout.dart';
import 'package:Reso/features/reso/domain/usecases/signup.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetExistingUser extends Mock implements GetExistingUser {}

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class MockLogout extends Mock implements Logout {}

class MockGetSessions extends Mock implements GetSessions {}

class MockInputConverter extends Mock implements InputConverter {}

class MockNetworkInfoImpl extends Mock implements NetworkInfoImpl {}

void main() {
  RootBloc bloc;
  MockGetExistingUser mockGetExistingUser;
  MockLogin mockLogin;
  MockSignup mockSignup;
  MockLogout mockLogout;
  MockGetSessions getSessions;
  User user = User();
  setUp(() {
    mockGetExistingUser = MockGetExistingUser();
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    mockLogout = MockLogout();
    getSessions = MockGetSessions();
    when(mockGetExistingUser(any)).thenAnswer((_) async => Right(user));
    bloc = RootBloc(
      getExistingUser: mockGetExistingUser,
      login: mockLogin,
      signup: mockSignup,
      logout: mockLogout,
      getSessions: getSessions,
    );
  });
  test('initial state is InitialState', () {
    expect(bloc.initialState, InitialState());
  });
  group("getExistingUser", () {
    test("should call MockGetExistingUser when created", () {
      // arrange
      // act
      //mockGetExistingUser(NoParams());
      // assert
      verify(mockGetExistingUser(any));
    });
  });
  group("login", () {
    test("should return [AuthenticatedState] when login is successful", () async {
      // arrange
      final user = User();
      when(mockLogin(LoginParams(email: "", password: ""))).thenAnswer((_) async => Right(user));
      // assert 
      final expected = [
        InitialState(),
        AuthenticatedState(user: user),
        LoadingState(),
        AuthenticatedState(user: user),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(LoginEvent(email: "", password: ""));
    });
    test("should emit [Error] if input is invalid", () async {
      // arrange 
      Map<String, String> invalidInputs = Map<String, String>.from({
        "email": Messages.INVALID_NAME_INPUT
      });
      when(mockLogin(any)).thenAnswer((_) async => Left(InvalidFormFailure(messages: invalidInputs)));
      // act 
      bloc.add(LoginEvent(email: "slarbi10@stuy.edu", password: "2145963"));
      // assert 
      final expected = [
        InitialState(),
        AuthenticatedState(user: user),
        LoadingState(),
        LoginState(widgetMessages: invalidInputs),
      ];
      expectLater(bloc, emitsInOrder(expected));
    });
  });
}
