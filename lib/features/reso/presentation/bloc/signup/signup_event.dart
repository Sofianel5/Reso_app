part of '../root_bloc.dart';

class SignupEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class RequestSignup extends SignupEvent {}

class EmailPageSubmitted extends SignupEvent {
  String email;
  EmailPageSubmitted(this.email);
}

class NamePageSubmitted extends SignupEvent {
  String firstName;
  String lastName;
  NamePageSubmitted(this.firstName, this.lastName);
}

class PasswordPageSubmitted extends RootEvent {
  String password;
  PasswordPageSubmitted(this.password);

  @override
  List<Object> get props => [];
}