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
  AuthenticatedState(this.user) : assert(user != null);
  @override
  List<Object> get props => [user];
}

abstract class LoadingState extends RootState {
  final String message;
  LoadingState({this.message});
  @override
  List<Object> get props => [message];
}


class NoInternetState extends ErrorState {
  @override
  String get message => Messages.NO_INTERNET;
}

class ResetPasswordState extends RootState {
  @override
  List<Object> get props => [];
}