part of 'root_bloc.dart';

abstract class RootState extends Equatable {
  const RootState();
}

class InitialState extends RootState {
  @override
  List<Object> get props => [];
}

class ErrorState extends RootState {
  final String message;
  ErrorState({this.message});
  @override
  List<Object> get props => [message];
}

class LoginState extends RootState {
  final Map<String, String> widgetMessages;
  final String globalMessage;
  const LoginState({this.widgetMessages, this.globalMessage});

  @override
  List<Object> get props => [widgetMessages];
}

class UnauthenticatedState extends RootState {
  @override
  List<Object> get props => [];
}

class AuthenticationError extends UnauthenticatedState implements ErrorState {
  @override
  String get message => Messages.INVALID_PASSWORD;
}

class AuthenticatedState extends RootState {
  final User user;
  AuthenticatedState({this.user});
  @override
  List<Object> get props => [user];
}

class LoadingState extends RootState {
  final String message;
  LoadingState({this.message});
  @override
  List<Object> get props => [message];
}
class LoadingHomeState extends AuthenticatedState implements LoadingState {
  final String message = Messages.LOADING;
}

class HomeState extends AuthenticatedState {}

class NoInternetState extends ErrorState {
  @override
  String get message => Messages.NO_INTERNET;
}

class ResetPasswordState extends RootEvent {
  @override
  List<Object> get props => [];
}

class SignupState extends RootEvent {
  @override
  List<Object> get props => [];
}