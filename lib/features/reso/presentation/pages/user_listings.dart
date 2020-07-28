import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import '../widgets/venue_card.dart';

class ListingsScreen extends StatefulWidget {
  final int id;
  ListingsScreen(this.id);

  @override
  State<StatefulWidget> createState() => ListingsScreenState();
}

class ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ListingsPageBloc(
          getListings: BlocProvider.of<RootBloc>(context).getListings,
          id: widget.id,
          user: BlocProvider.of<RootBloc>(context).user),
      child: ListingsBlocScreen(widget.id),
    );
  }
}

class ListingsBlocScreen extends StatefulWidget {
  final int id;
  ListingsBlocScreen(this.id);
  @override
  State<StatefulWidget> createState() => ListingsBlocScreenState();
}

class ListingsBlocScreenState extends State<ListingsBlocScreen> {
  @override
  void didChangeDependencies() {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('user')) {
          BlocProvider.of<RootBloc>(context)
              .add(PushListings(int.parse(deepLink.queryParameters["user"])));
        } else if (deepLink.queryParameters.containsKey('venue')) {
          BlocProvider.of<RootBloc>(context).add(PushVenue(
              Venue.getLoadingPlaceholder(
                  int.parse(deepLink.queryParameters["venue"]))));
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    super.didChangeDependencies();
  }
  bool alreadyPopped = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<ListingsPageBloc>(context),
      listener: (context, state) {
        if (state is ListingsPageLoadFailedState) {
          _key.currentState
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.message))));
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<ListingsPageBloc>(context),
        builder: (context, state) => SafeArea(
          bottom: false,
          child: buildBody(state, context),
        ),
      ),
    );
  }

  Widget buildBody(state, BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Color(0xFFF3F5F7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                        onTap: () {
                          if (!alreadyPopped) {
                            BlocProvider.of<RootBloc>(context).add(PopEvent());
                            alreadyPopped = true;
                          }
                        },
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30,
                          color: Colors.black,
                          onPressed: () {
                            if (!alreadyPopped) {
                              BlocProvider.of<RootBloc>(context).add(PopEvent());
                              alreadyPopped = true;
                            }
                          },
                        ),
                      ),
                  if (state is ListingsPageLoadingState)
                    Text(Localizer.of(context).get("Loading"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  else if (state is ListingsPageLoadFailedState)
                    Text(Localizer.of(context).get("Failed"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  else if (state is ListingsPageLoadedState)
                    Text(
                        state.venuesAdmin.toString() +
                            Localizer.of(context).get("'s Listings"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(width: 30),
                ],
              ),
            ),
            if (state is ListingsPageLoadedState)
              for (var venue in state.venues)
                VenueCard(
                  venue: venue,
                  from: "search",
                )
            else
              buildBodySwitchState(state),
          ],
        ),
      ),
    );
  }

  Widget buildBodySwitchState(ListingsPageState state) {
    if (state is ListingsPageLoadingState) {
      return buildLoadingBody();
    } else if (state is ListingsPageLoadFailedState) {
      return buildNoResultsBody();
    }
  }

  Padding buildNoResultsBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: Text(
        Localizer.of(context).get(
          "No results available",
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      )),
    );
  }

  Center buildLoadingBody() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
