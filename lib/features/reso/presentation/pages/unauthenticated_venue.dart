import 'dart:async';

import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/features/reso/presentation/widgets/unauthenticated_time_slot_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/venue.dart';
import '../bloc/root_bloc.dart';
import '../widgets/time_slot_card.dart';

class UnauthenticatedVenueScreen extends StatefulWidget {
  UnauthenticatedVenueScreen({@required this.venue});
  Venue venue;
  @override
  _UnauthenticatedVenueScreenState createState() => _UnauthenticatedVenueScreenState();
}

class _UnauthenticatedVenueScreenState extends State<UnauthenticatedVenueScreen> {

  @override 
  void didChangeDependencies() {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        if (deepLink != null) {
          BlocProvider.of<RootBloc>(context).add(ChangeLaunchDataEvent(deepLink.queryParameters));
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    super.didChangeDependencies();
  }

  
  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocProvider(
      create: (context) => UnauthenticatedVenuePageBloc(
          getTimeSlots: rootBloc.getTimeSlots,
          venue: widget.venue,
          getVenueDetail: rootBloc.getVenueDetail),
      child: UnauthenticatedVenueBloc(venue: widget.venue),
    );
  }
}

class UnauthenticatedVenueBloc extends StatefulWidget {
  const UnauthenticatedVenueBloc({Key key, this.venue}) : super(key: key);

  final Venue venue;

  @override
  _UnauthenticatedVenueBlocState createState() => _UnauthenticatedVenueBlocState();
}

class _UnauthenticatedVenueBlocState extends State<UnauthenticatedVenueBloc> {
  bool alreadyPopped = false;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  Widget buildContents(UnauthenticatedVenuePageState state) {
    if (state is UnauthenticatedVenueLoadingState || state is UnauthenticatedVenueTimeSlotsLoadingState) {
      return buildLoadingContents();
    } else if (state is UnauthenticatedVenueDetailLoadFailed ||
        state is UnauthenticatedVenueTimeSlotsLoadFailed) {
      return buildTimeSlotsFailedInfo(state);
    } else if (state is UnauthenticatedVenueTimeSlotsLoaded) {
      if (state is UnauthenticatedVenueNoTimeSlots) {
        return buildNoTimeSlotsInfo();
      } else {
        return buildLoadedContainer(state);
      }
    } else {
      return buildLoadingContents();
    }
  }

  Widget buildLoadedContainer(state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: state.timeSlots.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child:
            UnauthenticatedTimeSlotCard(timeslot: state.timeSlots[index], venue: state.venue),
      ),
    );
  }

  Padding buildNoTimeSlotsInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Text(
          Localizer.of(context).get("none available"),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  Padding buildTimeSlotsFailedInfo(state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: Text(
        state.message,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      )),
    );
  }

  Center buildLoadingContents() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDropdown() {
    return (widget.venue.phone == null &&
            widget.venue.website == null &&
            widget.venue.email == null)
        ? Container()
        : Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                iconSize: 30,
                value: null,
                elevation: 16,
                items: [
                  if (widget.venue.phone != null) "phone",
                  if (widget.venue.email != null) "email",
                  if (widget.venue.website != null) "website"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(Localizer.of(context).get(value)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == "Phone") {
                    launch("tel://" + widget.venue.phone);
                  } else if (value == "Email") {
                    launch("mailto:" + widget.venue.email);
                  } else if (value == "Website") {
                    if (value.startsWith("http")) {
                      launch(widget.venue.website);
                    } else {
                      launch("http://" + widget.venue.website);
                    }
                  }
                },
              ),
            ),
          );
  }

  Stack buildVenueBanner(UnauthenticatedVenuePageBloc bloc, BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              )
            ],
          ),
          child: Hero(
            tag: widget.venue.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image(
                image: CachedNetworkImageProvider(widget.venue.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (!alreadyPopped) {
                    BlocProvider.of<RootBloc>(context).add(PopEvent());
                  }
                  alreadyPopped = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    onPressed: () {
                      if (!alreadyPopped) {
                        BlocProvider.of<RootBloc>(context).add(PopEvent());
                      }
                      alreadyPopped = true;
                    },
                  ),
                ),
              ),
              Container()
            ],
          ),
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => print("hi"),
                child: Text(
                  widget.venue.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.locationArrow,
                    size: 15,
                    color: Colors.white70,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    widget.venue.address.city,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(right: 20, bottom: 20, child: _buildDropdown())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      condition: (previous, current) {
        return current is UnauthenticatedVenuePageState;
      },
      bloc: BlocProvider.of<UnauthenticatedVenuePageBloc>(context),
      listener: (context, state) {
        print(state);
        if (state is UnauthenticatedVenueTimeSlotsLoaded ||
            state is UnauthenticatedVenueTimeSlotsLoadFailed) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder(
        condition: (previous, current) {
          return current is UnauthenticatedVenuePageState;
        },
        bloc: BlocProvider.of<UnauthenticatedVenuePageBloc>(context),
        builder: (context, state) => Scaffold(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildVenueBanner(
                    BlocProvider.of<UnauthenticatedVenuePageBloc>(context), context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Localizer.of(context).get(
                          "timeslots",
                        ),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.25,
                        ),
                      )
                    ],
                  ),
                ),
                if (state is UnauthenticatedVenueTimeSlotsLoaded &&
                    !(state is UnauthenticatedVenueNoTimeSlots))
                  for (var timeslot in state.timeSlots)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 25.0),
                      child: UnauthenticatedTimeSlotCard(
                        timeslot: timeslot,
                        venue: state.venue,
                      ),
                    )
                else
                  buildContents(state),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
