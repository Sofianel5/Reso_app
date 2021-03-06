import '../../domain/entities/venue.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import 'account.dart';
import 'browse.dart';
import 'history.dart';
import 'qrscreen.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    if (BlocProvider.of<RootBloc>(context).launchData != null) {
      if (BlocProvider.of<RootBloc>(context).launchData.containsKey("venue")) {
        BlocProvider.of<RootBloc>(context).add(PushVenue(Venue.getLoadingPlaceholder(int.parse(BlocProvider.of<RootBloc>(context).launchData["venue"]))));
      } else if (BlocProvider.of<RootBloc>(context).launchData.containsKey("user")) {
        BlocProvider.of<RootBloc>(context).add(PushListings(int.parse(BlocProvider.of<RootBloc>(context).launchData["user"])));
      }
    }
    super.didChangeDependencies();
  }

  int _selectedPage = 0;
  static String initialQuery;
  final List<Widget> _mainPages = [
    BlocProvider(
        create: (BuildContext context) => BrowsePageBloc(
              getVenueDetail: BlocProvider.of<RootBloc>(context).getVenueDetail,
              user: BlocProvider.of<RootBloc>(context).user,
              getVenues: BlocProvider.of<RootBloc>(context).getVenues,
            ),
        child: BrowseScreen()),
    BlocProvider(
        create: (context) => SearchPageBloc(
            BlocProvider.of<RootBloc>(context).search,
            BlocProvider.of<RootBloc>(context).user,
            initialSearch: initialQuery),
        child: SearchScreen()),
    BlocProvider(
        create: (context) => QRPageBloc(
            confirmScan: BlocProvider.of<RootBloc>(context).confirmScan,
            toggle: BlocProvider.of<RootBloc>(context).toggle,
            getScan: BlocProvider.of<RootBloc>(context).getScan,
            user: BlocProvider.of<RootBloc>(context).user),
        child: QRScreen()),
    BlocProvider(
        create: (context) => RegistrationsPageBloc(
            BlocProvider.of<RootBloc>(context).getRegistrations,
            BlocProvider.of<RootBloc>(context).user),
        child: HistoryScreen()),
    BlocProvider(
        create: (context) =>
            AccountPageBloc(BlocProvider.of<RootBloc>(context).user),
        child: AccountScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<HomePageBloc>(context),
      listener: (context, state) {
        if (state is DeepLinkedSearchState) {
          initialQuery = state.query;
          setState(() {
            // What if you do it multiple times? Must change back to regular state when action completed
            _selectedPage = state.pageIndex;
          });
        }
      },
      child: BlocBuilder(
          bloc: BlocProvider.of<HomePageBloc>(context),
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
          }),
    );
  }
}
