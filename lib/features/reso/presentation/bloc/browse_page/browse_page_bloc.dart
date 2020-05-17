part of '../root_bloc.dart';

class BrowsePageBlocRouter {
  final GetVenues getVenues;
  final GetVenueDetail getVenueDetail;
  List<Venue> _venues;
  List<String> filters = [Venue.types.first];

  List<Venue> getFilteredVenues() {
    List<Venue> showing = [];
    for (var venue in _venues) {
      if (filters.contains(venue.type) || filters.contains(Venue.types.first)) {
        showing.add(venue);
      }
    }
    //print(showing.length);
    return showing;
  }

  BrowsePageBlocRouter(
      {@required this.getVenues, @required this.getVenueDetail});
  Stream<RootState> route(BrowsePageEvent event, User user) async* {
    if (event is BrowsePageCreationEvent) {
      yield LoadingBrowseState(user);
      if (_venues != null) {
        yield LoadedBrowseState(user, loadedVenues: _venues);
      } else {
        final venuesOrFailure = await getVenues(NoParams());
        yield* venuesOrFailure.fold((failure) async* {
          yield LoadingFailedState(user, message: failure.message);
        }, (venues) async* {
          _venues = venues;
          yield LoadedBrowseState(user, loadedVenues: venues);
        });
      }
    } else if (event is BrowsePageRefreshEvent) {
      yield LoadingBrowseState(user);
      final venuesOrFailure = await getVenues(NoParams());
      yield* venuesOrFailure.fold((failure) async* {
        yield LoadingFailedState(user, message: failure.message);
      }, (venues) async* {
        _venues = venues;
        yield LoadedBrowseState(user, loadedVenues: venues);
      });
    } 
  }
}
