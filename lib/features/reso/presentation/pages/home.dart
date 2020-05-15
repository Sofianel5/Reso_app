import 'package:Reso/core/localizations/messages.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import 'account.dart';
import 'browse.dart';
import 'error.dart';
import 'history.dart';
import 'qrscreen.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final List<Widget> _mainPages = [
    BrowseScreen(),
    SearchScreen(),
    QRScreen(),
    HistoryScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {},
      child: BlocBuilder(builder: (context, state) {
        if (state is HomeState) {
          return Scaffold(
            backgroundColor: Color(0xFFF3F5F7),
            body: _mainPages[_selectedPage],
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              animationCurve: Curves.easeInOutSine,
              animationDuration: Duration(milliseconds: 400),
              index: _selectedPage,
              onTap: (int value) {
                setState(() {
                  _selectedPage = value;
                });
              },
              items: <Widget>[
                Icon(
                  Icons.home,
                  size: 30,
                  color: _selectedPage == 0
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.black,
                ),
                Icon(
                  Icons.search,
                  size: 30,
                  color: _selectedPage == 1
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.black,
                ),
                Icon(
                  Icons.memory,
                  color: _selectedPage == 2
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.black,
                ),
                Icon(
                  Icons.list,
                  size: 30,
                  color: _selectedPage == 3
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.black,
                ),
                Icon(
                  Icons.account_circle,
                  size: 30,
                  color: _selectedPage == 4
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.black,
                ),
              ],
            ),
          );
        } else {
          return ErrorScreen(message: Messages.UNKNOWN_ERROR);
        }
      }),
    );
  }
}
