import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import 'login.dart';
import 'unauthenticated_browse.dart';

class UnauthenticatedHomePage extends StatefulWidget {
  @override
  _UnauthenticatedHomePageState createState() => _UnauthenticatedHomePageState();
}

class _UnauthenticatedHomePageState extends State<UnauthenticatedHomePage> {
  int _selectedPage = 0;
  final List<Widget> _mainPages = [
    BlocProvider(
        create: (BuildContext context) => UnauthenticatedBrowsePageBloc(
              getVenueDetail: BlocProvider.of<RootBloc>(context).getVenueDetail,
              getVenues: BlocProvider.of<RootBloc>(context).getVenues,
            ),
        child: UnauthenticatedBrowseScreen()),
    LoginPage()
  ];

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<UnauthenticatedHomePageBloc>(context),
      listener: (context, state) {},
      child: BlocBuilder(
          bloc: BlocProvider.of<UnauthenticatedHomePageBloc>(context),
          builder: (context, state) {
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
                    Icons.account_circle,
                    size: 30,
                    color: _selectedPage == 1
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.black,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
