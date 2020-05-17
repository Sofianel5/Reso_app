part of '../root_bloc.dart';

class BrowsePageBlocRouter {
  final GetVenues getVenues;
  final GetVenueDetail getVenueDetail;
  List<Venue> _venues;

  BrowsePageBlocRouter({@required this.getVenues,@required this.getVenueDetail});
  Stream<RootState> route(BrowsePageEvent event, User user) async* {
    if (event is BrowsePageCreationEvent) {
      yield LoadingBrowseState(user);
      final venuesOrFailure = await getVenues(NoParams());
      yield* venuesOrFailure.fold((failure) async* {
        yield LoadingFailedState(user, message: failure.message);
      }, (venues) async* {
        _venues = venues;
        yield LoadedBrowseState(user, loadedVenues: venues);
      });
    } else if (event is BrowsePageRefreshEvent) {
      yield LoadingBrowseState(user);
    }
  }
}
