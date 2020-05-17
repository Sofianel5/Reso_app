part of '../root_bloc.dart';

class VenuePageBlocRouter {
  GetTimeSlots getTimeSlots;
  GetVenueDetail getVenueDetail;
  VenueDetail venue;
  List<TimeSlot> timeSlots;
  VenuePageBlocRouter({@required this.getTimeSlots, @required this.getVenueDetail});
  Stream<RootState> route(VenuePageEvent event, User user) async* {
    if (event is SelectVenueEvent) {
      ExtendedNavigator.rootNavigator.pushNamed(Routes.venue, arguments: VenueScreenArguments(venue: event.venue, from: event.from));
      yield VenueLoadingState(user, event.venue);
    } else if (event is VenuePageCreated) {
      yield VenueLoadingState(user, event.venue);
      final result = await getVenueDetail(GetVenueDetailParams(venue: event.venue));
      yield* result.fold((failure) async* {
        yield VenueDetailLoadFailed(user, event.venue, failure.message);
      }, (venueDetail) async* {
        venue = venueDetail;
        yield VenueTimeSlotsLoadingState(user, venueDetail);
        final result = await getTimeSlots(GetTimeSlotsParams(venue: venue));
        yield* result.fold((failure) async* {
          yield VenueTimeSlotsLoadFailed(user, venue, failure.message);
        }, (timeSlots) async* {
          if (timeSlots.length == 0) {
            yield VenueNoTimeSlots(user, venue);
          } else {
            yield VenueTimeSlotsLoaded(user, venue, timeSlots);
          }
        });
      });
    } else if (event is TimeSlotsRefreshRequest) {
      yield VenueTimeSlotsLoadingState(user, venue);
        final result = await getTimeSlots(GetTimeSlotsParams(venue: venue));
        yield* result.fold((failure) async* {
          yield VenueTimeSlotsLoadFailed(user, venue, failure.message);
        }, (timeSlots) async* {
          if (timeSlots.length == 0) {
            VenueNoTimeSlots(user, venue);
          } else {
            yield VenueTimeSlotsLoaded(user, venue, timeSlots);
          }
        });
    } else if (event is VenuePopEvent) {
      ExtendedNavigator.rootNavigator.pop();
      if (event.from == "search") {
        yield SearchPoppedIn(user);
      } else {
        yield BrowsePoppedIn(user);
      }
    }
  }
}