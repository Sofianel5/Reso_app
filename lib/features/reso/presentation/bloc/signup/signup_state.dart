part of '../root_bloc.dart';

class SignupState extends UnauthenticatedState {

}

class SignupEmail extends SignupState {
  String email;
  SignupEmail({this.email});
}

class SignupEmailLoading extends SignupEmail {
  SignupEmailLoading({String email}) : super(email: email);
}

class SignupEmailFailure extends SignupEmail {
  String email;
  String message;
  SignupEmailFailure({this.email, this.message});
}

class SignupName extends SignupState {
  String firstName;
  String lastName;
  SignupName({this.firstName, this.lastName});
}

class SignupNameLoading extends SignupName {
  SignupNameLoading(String firstName, String lastName) : super(firstName: firstName, lastName: lastName);
}

class SignupNameFailure extends SignupName { 
  String message;
  String firstName;
  String lastName;
  SignupNameFailure({this.firstName, this.lastName, this.message});
} 

class SignupPassword extends SignupState {
  String password;
  SignupPassword({this.password});
}

class SignupPasswordLoading extends SignupPassword {
  SignupPasswordLoading(String password): super(password: password);
}

class SignupPasswordFailure extends SignupPassword {
  String message;
  SignupPasswordFailure({this.message});
}

class SignupLoading extends SignupState {}