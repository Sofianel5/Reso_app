import '../bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueCard extends StatelessWidget {
  VenueCard({this.venue});

  final venue;
  @override
  Widget build(BuildContext context) {
    RootBloc bloc = BlocProvider.of<RootBloc>(context);
    BrowseState state = bloc.state;
    return GestureDetector(
      onTap: () => bloc.add(SelectVenueEvent(venue: venue)),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: venue.id,
                                  child: Container(
                    height: 200,
                    width: 357,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth, image: NetworkImage(venue.image)),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  venue.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  venue.type,
                  style: TextStyle(fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                Text(
                  venue.address.address_1,
                  style: TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
