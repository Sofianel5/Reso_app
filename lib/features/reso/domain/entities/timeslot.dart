import 'package:equatable/equatable.dart';

import 'venue.dart';

class TimeSlot extends Equatable {
  final DateTime start;
  final DateTime stop;
  final int maxAttendees;
  final int numAttendees;
  final int id;
  final bool current;
  final bool past;
  final String type;
  TimeSlot({
    this.start,
    this.stop,
    this.maxAttendees,
    this.numAttendees,
    this.id,
    this.current,
    this.past,
    this.type,
  });

  @override
  List<Object> get props =>
      [start, stop, id, maxAttendees, numAttendees, current, past];
}

class TimeSlotDetail extends TimeSlot {
  final Venue venue;
  TimeSlotDetail({
    DateTime start,
    DateTime stop,
    int maxAttendees,
    int numAttendees,
    int id,
    bool current,
    bool past,
    String type,
    this.venue,
  }) : super(
          start: start,
          stop: stop,
          maxAttendees: maxAttendees,
          numAttendees: numAttendees,
          id: id,
          current: current,
          past: past,
          type: type,
        );
}
