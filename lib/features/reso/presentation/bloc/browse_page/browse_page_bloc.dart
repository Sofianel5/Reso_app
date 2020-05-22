part of '../root_bloc.dart';

class BrowsePageBloc extends Bloc<BrowsePageEvent, BrowseState> {
  final GetVenues getVenues;
  final GetVenueDetail getVenueDetail;
  User user;
  List<Venue> _venues;
  List<String> filters = [Venue.types.first];

  List<Venue> getFilteredVenues() {
    List<Venue> showing = [];
    for (var venue in _venues) {
      if (filters.contains(venue.type) || filters.contains(Venue.types.first)) {
        showing.add(venue);
      }
    }
    return showing;
  }

  BrowsePageBloc({@required this.user, @required this.getVenues, @required this.getVenueDetail}) {
    this.add(BrowsePageCreationEvent(user: user));
  }
  
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

  @override
  BrowseState get initialState => LoadingBrowseState(user);

  @override
  Stream<BrowseState> mapEventToState(BrowsePageEvent event) async* {
    print(event);
    if (event is BrowsePageCreationEvent) {
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
