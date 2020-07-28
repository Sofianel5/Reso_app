part of '../root_bloc.dart';

class VenuePageBloc extends Bloc<VenuePageEvent, VenuePageState> {
  VenuePageBloc(
      {@required this.user,
      @required this.venue,
      @required this.getTimeSlots,
      @required this.getVenueDetail}) {
    this.add(VenuePageCreated(venue: venue));
  }

  GetTimeSlots getTimeSlots;
  GetVenueDetail getVenueDetail;
  List<TimeSlot> timeSlots;
  User user;
  Venue venue;

  @override
  Stream<VenuePageState> mapEventToState(VenuePageEvent event) async* {
    if (event is VenuePageCreated && (state is VenueLoadingState)) {
      yield VenueLoadingState(user, event.venue);
      final result =
          await getVenueDetail(GetVenueDetailParams(venue: event.venue));
      yield* result.fold((failure) async* {
        yield VenueDetailLoadFailed(user, event.venue, failure.message);
      }, (venueDetail) async* {
        venue = venueDetail;
        yield VenueTimeSlotsLoadingState(user, venueDetail);
        final result = await getTimeSlots(GetTimeSlotsParams(venue: venue));
        yield* result.fold((failure) async* {
          yield VenueTimeSlotsLoadFailed(user, venue, failure.message);
        }, (timeSlots) async* {
           print("timeslot len" + timeSlots.length.toString());
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
        print("timeslot len" + timeSlots.length.toString());
        if (timeSlots.length == 0) {
          VenueNoTimeSlots(user, venue);
        } else {
          yield VenueTimeSlotsLoaded(user, venue, timeSlots);
        }
      });
    }
  }

  @override
  VenuePageState get initialState => VenueLoadingState(this.user, this.venue);
  /*
  Stream<RootState> route(VenuePageEvent event, User user) async* {
    print(event);
    if (event is SelectVenueEvent) {
      //ExtendedNavigator.rootNavigator.pushNamed(Routes.venue, arguments: VenueScreenArguments(venue: event.venue, from: event.from));
      yield VenueLoadingState(user, event.venue);
    } else if (event is VenuePageCreated) {
      yield VenueLoadingState(user, event.venue);
      final result =
          await getVenueDetail(GetVenueDetailParams(venue: event.venue));
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
    }
  }
  */
}
