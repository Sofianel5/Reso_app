import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/routes.dart';
import '../../domain/entities/venue.dart';
import '../bloc/root_bloc.dart';
import '../widgets/time_slot_card.dart';

class VenueScreen extends StatefulWidget {
  VenueScreen({@required this.venue});
  Venue venue;
  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocProvider(
      create: (context) => VenuePageBloc(
          getTimeSlots: rootBloc.getTimeSlots,
          venue: widget.venue,
          user: rootBloc.user,
          getVenueDetail: rootBloc.getVenueDetail),
      child: VenueBloc(venue: widget.venue),
    );
  }

}

class VenueBloc extends StatefulWidget {
  const VenueBloc({
    Key key, this.venue
  }) :  super(key: key);

  final Venue venue;

  @override
  _VenueBlocState createState() => _VenueBlocState();
}

class _VenueBlocState extends State<VenueBloc> {
  bool alreadyPopped = false;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  Widget buildContents(VenuePageState state) {
    if (state is VenueLoadingState || state is VenueTimeSlotsLoadingState) {
      return buildLoadingContents();
    } else if (state is VenueDetailLoadFailed ||
        state is VenueTimeSlotsLoadFailed) {
      return buildTimeSlotsFailedInfo(state);
    } else if (state is VenueTimeSlotsLoaded) {
      if (state is VenueNoTimeSlots) {
        return buildNoTimeSlotsInfo();
      } else {
        return buildLoadedContainer(state);
      }
    } else {
      return buildLoadingContents();
    }
  }

  Container buildLoadedContainer(state) {
    return Container(
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: state.timeSlots.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TimeSlotCard(
              timeslot: state.timeSlots[index], venue: state.venue),
        ),
      ),
    );
  }

  Padding buildNoTimeSlotsInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Text(
          "None available",
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

  Stack buildVenueBanner(VenuePageBloc bloc, BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width - 100,
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
                image: NetworkImage(widget.venue.image),
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
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    if (!alreadyPopped) {
                      BlocProvider.of<RootBloc>(context).add(PopEvent());
                    }
                    alreadyPopped = true;
                  },
                ),
              ),
              Row(
                children: <Widget>[],
              )
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
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
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: () => print("HI :)"),
            child: Icon(
              Icons.location_on,
              color: Colors.white70,
              size: 25,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      condition: (previous, current) {
        return current is VenuePageState;
      },
      bloc: BlocProvider.of<VenuePageBloc>(context),
      listener: (context, state) {
        if (state is VenueTimeSlotsLoaded ||
            state is VenueTimeSlotsLoadFailed) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder(
        condition: (previous, current) {
          return current is VenuePageState;
        },
        bloc: BlocProvider.of<VenuePageBloc>(context),
        builder: (context, state) => Scaffold(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          body: Column(
            children: <Widget>[
              buildVenueBanner(
                  BlocProvider.of<VenuePageBloc>(context), context),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Time slots",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.25,
                      ),
                    )
                  ],
                ),
              ),
              buildContents(state),
            ],
          ),
        ),
      ),
    );
  }
}
