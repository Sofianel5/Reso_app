part of '../root_bloc.dart';

class UnauthenticatedVenuePageEvent extends UnauthenticatedHomeEvent {
  final Venue venue;

  UnauthenticatedVenuePageEvent(this.venue);
}

class UnauthenticatedSelectVenueEvent extends UnauthenticatedVenuePageEvent {
  final Venue venue;
  final String from;
  UnauthenticatedSelectVenueEvent({@required this.venue, this.from}) : assert(venue != null), super(venue);
}

class UnauthenticatedVenuePageCreated extends UnauthenticatedVenuePageEvent {
  final Venue venue;
  UnauthenticatedVenuePageCreated({this.venue}) : super(venue);
}

class UnauthenticatedRequestRegisterPage extends UnauthenticatedVenuePageEvent {
  final TimeSlot timeSlot;
  final Venue venue;
  UnauthenticatedRequestRegisterPage(this.venue, this.timeSlot) : super(venue);
}

class UnauthenticatedTimeSlotsRefreshRequest extends UnauthenticatedVenuePageEvent {
  UnauthenticatedTimeSlotsRefreshRequest(Venue venue) : super(venue);
}