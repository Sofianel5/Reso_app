import 'package:flutter/material.dart';

import '../../../../core/localizations/localizations.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({this.message}) : assert(message != null);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              height: 75,
              width: 75,
              image: AssetImage("assets/tracery1.png"),
            ),
          ),
          SizedBox(height: 20),
          Text(
            Localizer.of(context).get(message) ?? message,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFdd2c00),
            ),
          )
        ],
      ),
    );
  }
}
