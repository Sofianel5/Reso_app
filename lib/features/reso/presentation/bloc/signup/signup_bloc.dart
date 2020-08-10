part of '../root_bloc.dart';

class SignupBlocRouter {
  Signup signup;
  InputConverter inputConverter = InputConverter();
  SignupBlocRouter(this.signup);
  String email;
  String firstName;
  String lastName;
  String password;
  Stream<RootState> route(SignupEvent event) async* {
    if (event is RequestSignup) {
      ExtendedNavigator.rootNavigator.pushNamed(Routes.signUpName);
      yield SignupEmail();
    } else if (event is NamePageSubmitted) {
      yield SignupNameLoading(event.firstName, event.lastName);
      yield* inputConverter.parseName(event.firstName).fold((failure) async* {
        yield SignupNameFailure(firstName: event.firstName, lastName: event.lastName, message: failure.message);
      } , (str) async* {
        firstName = str;
        yield* inputConverter.parseName(event.lastName).fold((failure) async* {
          yield SignupNameFailure(firstName: event.firstName, lastName: event.lastName, message: failure.message);
        }, (str) async* {
          lastName = str;
          ExtendedNavigator.rootNavigator.pushNamed(Routes.signUpEmail);
          yield SignupEmail();
        });
      });
    } else if (event is EmailPageSubmitted) {
      yield SignupEmailLoading(email: event.email);
      yield* inputConverter.parseEmail(event.email).fold((failure) async* {
        yield SignupEmailFailure(email: event.email,message: failure.message);
      } , (str) async* {
        email = str;
        ExtendedNavigator.rootNavigator.pushNamed(Routes.signUpPasswordScreen);
      });
    }
  }
}