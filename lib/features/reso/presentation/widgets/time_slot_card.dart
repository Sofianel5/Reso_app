import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'attendance_graph.dart';

class TimeSlotCard extends StatelessWidget {
  TimeSlotCard({this.venue, this.timeslot});
  final timeslot;
  final venue;
  @override
  Widget build(BuildContext context) {
    RootBloc bloc = BlocProvider.of<RootBloc>(context);
    return GestureDetector(
      onTap: () {
        bloc.add(PushRegister(venue: venue, timeslot: timeslot));
      },
      child: Container(
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 10, offset: Offset.fromDirection(-0.2))]
        ),
        padding: EdgeInsets.all(20),
        height: 125,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AttendanceGraph(
                    size: Size(85.0, 85.0),
                    total: timeslot.maxAttendees,
                    taken: timeslot.numAttendees)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  DateFormat("EEEEE").format(timeslot.start),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                Text(
                  DateFormat("jm").format(timeslot.start) + " to " + DateFormat("jm").format(timeslot.stop),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
