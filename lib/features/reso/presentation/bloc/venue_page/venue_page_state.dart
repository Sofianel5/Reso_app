part of '../root_bloc.dart';

class VenuePageState extends HomeState {
  Venue venue;
  VenuePageState(User user, this.venue) : super(user);
}

class VenueLoadingState extends VenuePageState {
  Venue venue;
  VenueLoadingState(User user, this.venue) : super(user, venue);
}

class VenueDetailLoadedState extends VenuePageState {
  final VenueDetail venue;
  VenueDetailLoadedState(User user, this.venue)
      : super(user, venue);
}

class VenueDetailLoadFailed extends VenuePageState {
  Venue venue;
  String message;
  VenueDetailLoadFailed(User user, this.venue, this.message)
      : super(user, venue);
}

class VenueTimeSlotsLoadingState extends VenueDetailLoadedState {
  VenueTimeSlotsLoadingState(User user, VenueDetail venueDetail)
      : super(user, venueDetail);
}

class VenueTimeSlotsLoaded extends VenueDetailLoadedState {
  final List<TimeSlot> timeSlots;
  VenueTimeSlotsLoaded(User user, VenueDetail venueDetail, this.timeSlots)
      : super(user, venueDetail);
}

class VenueNoTimeSlots extends VenueTimeSlotsLoaded {
  VenueNoTimeSlots(User user, VenueDetail venueDetail)
      : super(user, venueDetail, []);
}

class VenueTimeSlotsLoadFailed extends VenueDetailLoadedState {
  String message;
  VenueTimeSlotsLoadFailed(User user, VenueDetail venue, this.message)
      : super(user, venue);
}

class VenuePoppedInState extends VenueLoadingState {
  VenuePoppedInState(User user, Venue venue) : super(user, venue);
}
