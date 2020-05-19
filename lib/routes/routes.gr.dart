// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:Reso/features/reso/presentation/pages/root.dart';
import 'package:Reso/features/reso/presentation/pages/venue.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:Reso/features/reso/presentation/pages/signup_email.dart';
import 'package:Reso/features/reso/presentation/pages/signup_name.dart';
import 'package:Reso/features/reso/presentation/pages/signup_password.dart';
import 'package:Reso/features/reso/presentation/pages/register.dart';
import 'package:Reso/features/reso/domain/entities/timeslot.dart';

abstract class Routes {
  static const rootPage = '/';
  static const venue = '/venue';
  static const signUpEmail = '/sign-up-email';
  static const signUpName = '/sign-up-name';
  static const signUpPasswordScreen = '/sign-up-password-screen';
  static const register = '/register';
  static const all = {
    rootPage,
    venue,
    signUpEmail,
    signUpName,
    signUpPasswordScreen,
    register,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.rootPage:
        if (hasInvalidArgs<RootPageArguments>(args)) {
          return misTypedArgsRoute<RootPageArguments>(args);
        }
        final typedArgs = args as RootPageArguments ?? RootPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => RootPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.venue:
        if (hasInvalidArgs<VenueScreenArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<VenueScreenArguments>(args);
        }
        final typedArgs = args as VenueScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              VenueScreen(venue: typedArgs.venue),
          settings: settings,
        );
      case Routes.signUpEmail:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpEmailScreen(),
          settings: settings,
        );
      case Routes.signUpName:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpNameScreen(),
          settings: settings,
        );
      case Routes.signUpPasswordScreen:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpPasswordScreen(),
          settings: settings,
        );
      case Routes.register:
        if (hasInvalidArgs<RegisterScreenArguments>(args)) {
          return misTypedArgsRoute<RegisterScreenArguments>(args);
        }
        final typedArgs =
            args as RegisterScreenArguments ?? RegisterScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => RegisterScreen(
              venue: typedArgs.venue, timeSlot: typedArgs.timeSlot),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//RootPage arguments holder class
class RootPageArguments {
  final Key key;
  RootPageArguments({this.key});
}

//VenueScreen arguments holder class
class VenueScreenArguments {
  final Venue venue;
  VenueScreenArguments({@required this.venue});
}

//RegisterScreen arguments holder class
class RegisterScreenArguments {
  final Venue venue;
  final TimeSlot timeSlot;
  RegisterScreenArguments({this.venue, this.timeSlot});
}
