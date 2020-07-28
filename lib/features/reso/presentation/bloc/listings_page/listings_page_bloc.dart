part of '../root_bloc.dart';

class ListingsPageBloc extends Bloc<ListingsPageEvent, ListingsPageState> {
  User user;
  List<VenueDetail> _venues;
  int id;
  User listingAdmin;
  final GetListings getListings;
  ListingsPageBloc({@required this.user, @required this.getListings, @required this.id}) {
    this.add(ListingsPageCreatedEvent());
  }

  @override
  get initialState => ListingsPageLoadingState(this.user);

  @override
  Stream<ListingsPageState> mapEventToState(ListingsPageEvent event) async* {
    if (event is ListingsPageCreatedEvent) {
      if (_venues != null) {
        yield ListingsPageLoadedState(user, _venues, _venues[0].admin);
      } else {
        final venuesOrFailure = await getListings(GetListingsParams(id: id));
        yield* venuesOrFailure.fold((failure) async* {
          print(failure.message);
          yield ListingsPageLoadFailedState(user,failure.message);
        }, (venues) async* {
          _venues = venues;
          yield ListingsPageLoadedState(user, _venues, _venues[0].admin);
        });
      }
    }
  } 
}