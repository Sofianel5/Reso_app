import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/localizations/localizations.dart';
import '../../../../routes/routes.dart';
import '../../domain/entities/venue.dart';
import '../bloc/root_bloc.dart';
import '../widgets/venue_card.dart';
import 'venue.dart';

class BrowseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BrowseScreenState();
}

class BrowseScreenState extends State<BrowseScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RootBloc bloc = BlocProvider.of<RootBloc>(context);
    RootState state = bloc.state;
    if (state is AuthenticatedState) {
      bloc.add(BrowsePageCreationEvent(user: state.user));
    }
  }
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

  Widget _buildIcon(int index, RootBloc bloc) {
    return GestureDetector(
      onTap: () {
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
    final RootBloc bloc = BlocProvider.of<RootBloc>(context);
    final BrowseState state = bloc.state;
    return BlocListener(
      bloc: bloc,
      condition: (previous, current) => true,
      listener: (context, state) {
        print(state);
        if (state is LoadedBrowseState) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
          venues = state.loadedVenues;
          showingVenues = state.loadedVenues;
        } else if (state is BrowsePoppedIn) {
          bloc.add(BrowsePageCreationEvent(user: state.user));
        } 
      },
      child: BlocBuilder(
        bloc: bloc,
        condition: (previous, current) => true,
        builder: (context, state) => SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              bloc.add(BrowsePageRefreshEvent());
              return _refreshCompleter.future;
            },
            child: buildListView(bloc.state, bloc),
          ),
        ),
      ),
    );
  }

  ListView buildListView(state, RootBloc bloc) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      children: <Widget>[
        buildTopPadding(state),
        SizedBox(height: 20.0),
        buildIconsRow(bloc),
        SizedBox(
          height: 20.0,
        ),
        if (state is LoadedBrowseState)
          showingVenues.length == 0
              ? buildNoVenuesBody()
              : buildLoadedBody(bloc, state)
        else if (state is LoadingBrowseState)
          Center(
            child: buildLoadingBody(state),
          )
      ],
    );
  }

  RefreshIndicator buildLoadedBody(RootBloc bloc, LoadedBrowseState state) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(BrowsePageRefreshEvent());
        return _refreshCompleter.future;
      },
      child: Container(
        height: 600,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: showingVenues?.length ?? 0,
          itemBuilder: (BuildContext context, int index) => VenueCard(
            venue: showingVenues[index],
            from: "browse"
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
        "None nearby",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      )),
    );
  }

  Container buildLoadingBody(AuthenticatedState state) {
    return Container(
      width: 50,
      height: 50,
      child: state is LoadingFailedState
          ? Text(Localizer.of(context).get(state.message))
          : CircularProgressIndicator(),
    );
  }

  Container buildIconsRow(RootBloc bloc) {
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

  Padding buildTopPadding(AuthenticatedState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        //! LOCALIZE
        "Near " + state.user?.address?.address_1 ?? "you",
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
