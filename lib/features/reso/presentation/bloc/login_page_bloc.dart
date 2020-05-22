part of 'root_bloc.dart';

class LoginBlocRouter {
  Login login;
  User user;
  LoginBlocRouter(this.login);
  Stream<RootState> route(LoginEvent event) async* {
    yield LoginLoadingState();
    if (event is LoginAttemptEvent) {
      final result = await login(event.params);
      yield* result.fold(
        (failure) async* {
          if (failure is InvalidFormFailure) {
            yield LoginFailedState(
                widgetMessages: failure.messages,
                globalMessage: Messages.INVALID_FORM);
          } else {
            yield LoginFailedState(globalMessage: failure.message);
          }
        },
        (_user) async* {
          user = _user;
          yield AuthenticatedState(user);
        },
      );
    }
  }
}
