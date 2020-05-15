part of '../root_bloc.dart';

class BrowsePageBlocRouter {
  final GetVenues getVenues;
  final GetVenueDetail getVenueDetail;
  List<Venue> _venues;

  BrowsePageBlocRouter({@required this.getVenues,@required this.getVenueDetail});
  Stream<RootState> route(BrowsePageEvent event, User user) async* {
    if (event is BrowsePageCreationEvent) {
      yield LoadingBrowseState();
      final venuesOrFailure = await getVenues(NoParams());
      yield* venuesOrFailure.fold((failure) async* {
        yield LoadingFailedState(message: failure.message);
      }, (venues) async* {
        _venues = venues;
        yield LoadedBrowseState(loadedVenues: venues, user: user);
      });
    } else if (event is BrowsePageRefreshEvent) {
      yield LoadingBrowseState(user: user);
    }
  }
}
