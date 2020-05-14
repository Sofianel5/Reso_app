import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:Reso/features/reso/presentation/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login.dart';

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
          }
        },
      ),
    );
  }
}