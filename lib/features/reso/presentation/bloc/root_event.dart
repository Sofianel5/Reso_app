part of 'root_bloc.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();
}

class GetExistingUserEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class LoginEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class SignupEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class ErrorEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends RootEvent {
  @override
  List<Object> get props => [];
}
