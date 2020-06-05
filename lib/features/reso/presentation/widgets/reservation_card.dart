import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/timeslot.dart';
import 'attendance_graph.dart';

class ReservationCard extends StatelessWidget {
  ReservationCard({this.timeslot});
  final TimeSlotDetail timeslot;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  taken: timeslot.numAttendees,
                  type: timeslot.type,
                  )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                timeslot.venue.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/25),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              Text(
                DateFormat("MM/dd/yyyy").format(timeslot.start),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/25),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              Text(
                DateFormat("jm").format(timeslot.start) + " to " + DateFormat("jm").format(timeslot.stop),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/25),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
