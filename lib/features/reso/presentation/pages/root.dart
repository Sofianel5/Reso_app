import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations/messages.dart';
import '../bloc/root_bloc.dart';
import 'error.dart';
import 'home.dart';
import 'login.dart';
import 'splash.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RootBloc, RootState>(
        builder: (context, state) {
          print(state);
          if (state is InitialState) {
            return SplashScreen();
          } else if (state is UnauthenticatedState) {
            return LoginPage();
          } else if (state is AuthenticatedState) {
            return BlocProvider(
              create: (context) => HomePageBloc(user: state.user),
              child: HomePage(),
            );
          } else if (state is ErrorState) {
            return ErrorScreen(message: state.message);
          } else {
            return ErrorScreen(message: Messages.UNKNOWN_ERROR);
          }
        },
      ),
    );
  }
}
