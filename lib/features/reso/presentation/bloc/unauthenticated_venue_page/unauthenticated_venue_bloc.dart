part of '../root_bloc.dart';

class UnauthenticatedVenuePageBloc extends Bloc<UnauthenticatedVenuePageEvent, UnauthenticatedVenuePageState> {
  UnauthenticatedVenuePageBloc(
      {
      @required this.venue,
      @required this.getTimeSlots,
      @required this.getVenueDetail}) {
    this.add(UnauthenticatedVenuePageCreated(venue: venue));
  }

  GetTimeSlots getTimeSlots;
  GetVenueDetail getVenueDetail;
  List<TimeSlot> timeSlots;
  Venue venue;

  @override
  Stream<UnauthenticatedVenuePageState> mapEventToState(UnauthenticatedVenuePageEvent event) async* {
    if (event is UnauthenticatedVenuePageCreated && (state is UnauthenticatedVenueLoadingState)) {
      yield UnauthenticatedVenueLoadingState(event.venue);
      final result =
          await getVenueDetail(GetVenueDetailParams(venue: event.venue));
      yield* result.fold((failure) async* {
        yield UnauthenticatedVenueDetailLoadFailed(event.venue, failure.message);
      }, (venueDetail) async* {
        venue = venueDetail;
        yield UnauthenticatedVenueTimeSlotsLoadingState(venueDetail);
        final result = await getTimeSlots(GetTimeSlotsParams(venue: venue));
        yield* result.fold((failure) async* {
          yield UnauthenticatedVenueTimeSlotsLoadFailed(venue, failure.message);
        }, (timeSlots) async* {
           print("timeslot len" + timeSlots.length.toString());
          if (timeSlots.length == 0) {
            yield UnauthenticatedVenueNoTimeSlots(venue);
          } else {
            yield UnauthenticatedVenueTimeSlotsLoaded(venue, timeSlots);
          }
        });
      });
    } else if (event is UnauthenticatedTimeSlotsRefreshRequest) {
      yield UnauthenticatedVenueTimeSlotsLoadingState(venue);
      final result = await getTimeSlots(GetTimeSlotsParams(venue: venue));
      yield* result.fold((failure) async* {
        yield UnauthenticatedVenueTimeSlotsLoadFailed(venue, failure.message);
      }, (timeSlots) async* {
        print("timeslot len" + timeSlots.length.toString());
        if (timeSlots.length == 0) {
          UnauthenticatedVenueNoTimeSlots(venue);
        } else {
          yield UnauthenticatedVenueTimeSlotsLoaded(venue, timeSlots);
        }
      });
    }
  }

  @override
  UnauthenticatedVenuePageState get initialState => UnauthenticatedVenueLoadingState(this.venue);

}
