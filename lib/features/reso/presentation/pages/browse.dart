import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/localizations/localizations.dart';
import '../../domain/entities/venue.dart';
import '../bloc/root_bloc.dart';
import '../widgets/venue_card.dart';

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

  List<Venue> venues;
  List<int> showingVenuesIds;
  Completer<void> _refreshCompleter;
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

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        if (index != 0) {
          showingVenuesIds = [];
          for (var venue in venues) {
            if (venue.type == _iconCaptions[index]) {
              showingVenuesIds.add(venue.id);
            }
          }
          setState(() {
            showingVenuesIds = showingVenuesIds;
          });
        } else {
          setState(() {
            showingVenuesIds =
                List<int>.generate(venues.length, (i) => venues[i].id);
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
      listener: (context, state) {
        if (state is LoadedBrowseState) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder(
        builder: (context, state) => SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              bloc.add(BrowsePageRefreshEvent());
              return _refreshCompleter.future;
            },
            child: buildListView(state, bloc),
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
        buildIconsRow(),
        SizedBox(
          height: 20.0,
        ),
        state is LoadedBrowseState
            ? state.loadedVenues.length == 0
                ? buildNoVenuesBody()
                : buildLoadedBody(bloc, state)
            : Center(
                child: buildLoadingBody(state),
              )
      ],
    );
  }

  RefreshIndicator buildLoadedBody(RootBloc bloc, BrowseState state) {
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
          itemCount: state.venues?.length ?? 0,
          itemBuilder: (BuildContext context, int index) => VenueCard(
            venue: state.venues[index],
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

  Container buildLoadingBody(BrowseState state) {
    return Container(
      width: 50,
      height: 50,
      child: state is LoadingFailedState ? Text(Localizer.of(context).get(state.message)) : CircularProgressIndicator(),
    );
  }

  Container buildIconsRow() {
    return Container(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: _icons
            .asMap()
            .entries
            .map(
              (MapEntry map) => _buildIcon(map.key),
            )
            .toList(),
      ),
    );
  }

  Padding buildTopPadding(BrowseState state) {
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
