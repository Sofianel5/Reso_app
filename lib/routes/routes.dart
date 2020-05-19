
import 'package:auto_route/auto_route_annotations.dart';

import '../features/reso/presentation/pages/register.dart';
import '../features/reso/presentation/pages/root.dart';
import '../features/reso/presentation/pages/signup_email.dart';
import '../features/reso/presentation/pages/signup_name.dart';
import '../features/reso/presentation/pages/signup_password.dart';
import '../features/reso/presentation/pages/venue.dart';


@MaterialAutoRouter()
class $Router {
  @initial
  RootPage rootPage;
  VenueScreen venue;
  SignUpEmailScreen signUpEmail;
  SignUpNameScreen signUpName;
  SignUpPasswordScreen signUpPasswordScreen;
  RegisterScreen register;
}
