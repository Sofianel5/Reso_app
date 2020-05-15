part of 'root_bloc.dart';

class LoginEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class LoginAttemptEvent extends LoginEvent {
  final String email;
  final String password;
  LoginAttemptEvent({this.email, this.password});
  LoginParams get params => LoginParams(email: email, password: password);
  @override
  List<Object> get props => [email, password];
}
class RequestSignupEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class RequestResetPasswordEvent extends RootEvent {
  @override
  List<Object> get props => [];
}