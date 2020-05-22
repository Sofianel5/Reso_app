import 'package:Reso/features/reso/presentation/pages/venue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../routes/routes.dart';
import '../bloc/root_bloc.dart';

class VenueCard extends StatelessWidget {
  VenueCard({this.venue, this.from});

  final venue;
  final String from;
  @override
  Widget build(BuildContext context) {
    RootBloc bloc = BlocProvider.of<RootBloc>(context);
    return GestureDetector(
      onTap: () {
        bloc.add(PushVenue(venue));
      },
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
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
                          width: MediaQuery.of(context).size.width-56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: CachedNetworkImageProvider(venue.image),
                            ),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
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
          ),
        ],
      ),
    );
  }
}
