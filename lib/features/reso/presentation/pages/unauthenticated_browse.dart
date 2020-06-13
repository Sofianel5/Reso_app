import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/localizations/localizations.dart';
import '../../domain/entities/venue.dart';
import '../bloc/root_bloc.dart';
import '../widgets/venue_card.dart';

class UnauthenticatedBrowseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UnauthenticatedBrowseScreenState();
}

class UnauthenticatedBrowseScreenState extends State<UnauthenticatedBrowseScreen> {
  Completer<void> _refreshCompleter;
  List<Venue> showingVenues;
  List<Venue> venues;
  int _selectedIndex = 0;
  List<IconData> _icons = [
    FontAwesomeIcons.globeEurope,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.shoppingBasket,
    FontAwesomeIcons.mugHot,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.gasPump,
    FontAwesomeIcons.envelopeOpenText,
    FontAwesomeIcons.tools,
    FontAwesomeIcons.cut,
    FontAwesomeIcons.book
  ];
  List<String> _iconCaptions = Venue.types;
  @override
  initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _buildIcon(int index, UnauthenticatedBrowsePageBloc bloc) {
    return GestureDetector(
      onTap: () {
        if (!(bloc.state is UnauthenticatedLoadedBrowseState)) {
          return;
        }
        if (index != 0) {
          showingVenues = [];
          for (var venue in venues) {
            if (venue.type == _iconCaptions[index]) {
              showingVenues.add(venue);
            }
          }
          setState(() {
            showingVenues = showingVenues;
          });
        } else {
          setState(() {
            showingVenues = venues;
          });
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Color(0xFFE7BEE),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Icon(
                _icons[index],
                size: 25.0,
                color: Colors.black,
              ),
            ),
            Text(
              _iconCaptions[index],
              style: TextStyle(
                color: _selectedIndex == index
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<UnauthenticatedBrowsePageBloc>(context),
      condition: (previous, current) => true,
      listener: (context, state) {
        print(state);
        if (state is UnauthenticatedLoadedBrowseState) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
          venues = state.loadedVenues;
          showingVenues = state.loadedVenues;
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<UnauthenticatedBrowsePageBloc>(context),
        condition: (previous, current) => true,
        builder: (context, state) => SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<BrowsePageBloc>(context)
                  .add(BrowsePageRefreshEvent());
              return _refreshCompleter.future;
            },
            child: buildListView(BlocProvider.of<UnauthenticatedBrowsePageBloc>(context).state,
                BlocProvider.of<UnauthenticatedBrowsePageBloc>(context)),
          ),
        ),
      ),
    );
  }

  ListView buildListView(state, UnauthenticatedBrowsePageBloc bloc) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      children: <Widget>[
        buildTopPadding(state),
        SizedBox(height: 20.0),
        buildIconsRow(bloc),
        SizedBox(
          height: 20.0,
        ),
        if (state is UnauthenticatedLoadedBrowseState)
          if (showingVenues.length == 0)
            buildNoVenuesBody()
          else 
            for (var venue in showingVenues)
              VenueCard(venue: venue)
        else if (state is UnauthenticatedLoadingBrowseState)
          Center(
            child: buildLoadingBody(state),
          ),
      ],
    );
  }

  RefreshIndicator buildLoadedBody(
      UnauthenticatedBrowsePageBloc bloc, UnauthenticatedLoadedBrowseState state) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(UnauthenticatedBrowsePageRefreshEvent());
        return _refreshCompleter.future;
      },
      child: Container(
        height: 10,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) => VenueCard(
            venue: showingVenues[0],
          ),
        ),
      ),
    );
  }

  Padding buildNoVenuesBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Text(
          Localizer.of(context).get("None nearby"),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  Container buildLoadingBody(UnauthenticatedBrowseState state) {
    return Container(
      width: 50,
      height: 50,
      child: state is UnauthenticatedLoadingFailedState
          ? Text(Localizer.of(context).get(state.message))
          : CircularProgressIndicator(),
    );
  }

  Container buildIconsRow(UnauthenticatedBrowsePageBloc bloc) {
    return Container(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: _icons
            .asMap()
            .entries
            .map(
              (MapEntry map) => _buildIcon(map.key, bloc),
            )
            .toList(),
      ),
    );
  }

  Padding buildTopPadding(UnauthenticatedBrowseState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        Localizer.of(context).get("near-you"),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
