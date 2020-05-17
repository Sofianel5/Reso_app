part of '../root_bloc.dart';

class VenuePageEvent extends HomeEvent {
  final Venue venue;

  VenuePageEvent(this.venue);
}

class SelectVenueEvent extends VenuePageEvent {
  final Venue venue;
  final String from;
  SelectVenueEvent({@required this.venue, this.from}) : assert(venue != null), super(venue);
}

class VenuePageCreated extends VenuePageEvent {
  final Venue venue;
  VenuePageCreated({this.venue}) : super(venue);
}

class RequestRegisterPage extends VenuePageEvent {
  final TimeSlot timeSlot;
  final Venue venue;
  RequestRegisterPage(this.venue, this.timeSlot) : super(venue);
}

class TimeSlotsRefreshRequest extends VenuePageEvent {
  TimeSlotsRefreshRequest(Venue venue) : super(venue);
}

class VenuePopEvent extends VenuePageEvent {
  final String from;
  VenuePopEvent(Venue venue, this.from) : super(venue);
}