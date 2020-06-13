part of '../root_bloc.dart';

class UnauthenticatedVenuePageState extends UnauthenticatedHomeState {
  Venue venue;
  UnauthenticatedVenuePageState(this.venue);
}

class UnauthenticatedVenueLoadingState extends UnauthenticatedVenuePageState {
  Venue venue;
  UnauthenticatedVenueLoadingState(this.venue) : super(venue);
}

class UnauthenticatedVenueDetailLoadedState extends UnauthenticatedVenuePageState {
  final VenueDetail venue;
  UnauthenticatedVenueDetailLoadedState(this.venue)
      : super(venue);
}

class UnauthenticatedVenueDetailLoadFailed extends UnauthenticatedVenuePageState {
  Venue venue;
  String message;
  UnauthenticatedVenueDetailLoadFailed(this.venue, this.message)
      : super(venue);
}

class UnauthenticatedVenueTimeSlotsLoadingState extends UnauthenticatedVenueDetailLoadedState {
  UnauthenticatedVenueTimeSlotsLoadingState(VenueDetail venueDetail)
      : super(venueDetail);
}

class UnauthenticatedVenueTimeSlotsLoaded extends UnauthenticatedVenueDetailLoadedState {
  final List<TimeSlot> timeSlots;
  UnauthenticatedVenueTimeSlotsLoaded(VenueDetail venueDetail, this.timeSlots)
      : super(venueDetail);
}

class UnauthenticatedVenueNoTimeSlots extends UnauthenticatedVenueTimeSlotsLoaded {
  UnauthenticatedVenueNoTimeSlots(VenueDetail venueDetail)
      : super(venueDetail, []);
}

class UnauthenticatedVenueTimeSlotsLoadFailed extends UnauthenticatedVenueDetailLoadedState {
  String message;
  UnauthenticatedVenueTimeSlotsLoadFailed( VenueDetail venue, this.message)
      : super(venue);
}

class UnauthenticatedVenuePoppedInState extends UnauthenticatedVenueLoadingState {
  UnauthenticatedVenuePoppedInState(Venue venue) : super(venue);
}
