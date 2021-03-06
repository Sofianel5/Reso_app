import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations/messages.dart';
import '../bloc/root_bloc.dart';
import 'error.dart';
import 'home.dart';
import 'splash.dart';
import 'unauthenticated_home.dart';

class RootPage extends StatefulWidget with WidgetsBindingObserver {
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
            return BlocProvider(
              create: (context) => UnauthenticatedHomePageBloc(),
              child: UnauthenticatedHomePage(),
            );
          } else if (state is AuthenticatedState) {
            return BlocProvider(
              create: (context) => BlocProvider.of<RootBloc>(context).homeBloc,
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
