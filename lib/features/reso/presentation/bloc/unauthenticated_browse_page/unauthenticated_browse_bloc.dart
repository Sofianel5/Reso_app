part of '../root_bloc.dart';

class UnauthenticatedBrowsePageBloc extends Bloc<UnauthenticatedBrowsePageEvent, UnauthenticatedBrowseState> {
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
    return showing;
  }

  UnauthenticatedBrowsePageBloc({ @required this.getVenues, @required this.getVenueDetail}) {
    this.add(UnauthenticatedBrowsePageCreationEvent());
  }

  @override
  UnauthenticatedBrowseState get initialState => UnauthenticatedLoadingBrowseState();

  @override
  Stream<UnauthenticatedBrowseState> mapEventToState(UnauthenticatedBrowsePageEvent event) async* {
    print(event);
    if (event is UnauthenticatedBrowsePageCreationEvent) {
      if (_venues != null) {
        yield UnauthenticatedLoadedBrowseState(loadedVenues: _venues);
      } else {
        final venuesOrFailure = await getVenues(NoParams());
        yield* venuesOrFailure.fold((failure) async* {
          yield UnauthenticatedLoadingFailedState(message: failure.message);
        }, (venues) async* {
          _venues = venues;
          yield UnauthenticatedLoadedBrowseState(loadedVenues: venues);
        });
      }
    } else if (event is UnauthenticatedBrowsePageRefreshEvent) {
      yield UnauthenticatedLoadingBrowseState();
      final venuesOrFailure = await getVenues(NoParams());
      yield* venuesOrFailure.fold((failure) async* {
        yield UnauthenticatedLoadingFailedState(message: failure.message);
      }, (venues) async* {
        _venues = venues;
        yield UnauthenticatedLoadedBrowseState(loadedVenues: venues);
      });
    } 
  }
}
