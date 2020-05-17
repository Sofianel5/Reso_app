part of 'root_bloc.dart';

class HomePageBlocRouter {
  final GetVenues getVenues;
  final Search search;
  final GetVenueDetail getVenueDetail;
  final BrowsePageBlocRouter browsePageBlocRouter;
  final ToggleLock toggle;
  final GetScan getScan;
  final SearchPageBlocRouter searchPageBlocRouter;
  final GetRegistrations getRegistrations;
  final QRPageBlocRouter qrPageBlocRouter;
  final RegistrationsPageBlocRouter registrationsPageBlocRouter;
  final AccountPageBlocRouter accountPageBlocRouter;
  final ConfirmScan confirmScan;
  HomePageBlocRouter({@required this.getVenues, @required this.getVenueDetail, @required this.search, @required this.toggle, @required this.getScan, @required this.getRegistrations, @required this.confirmScan})
      : this.browsePageBlocRouter = BrowsePageBlocRouter(
            getVenueDetail: getVenueDetail, getVenues: getVenues),
        this.searchPageBlocRouter = SearchPageBlocRouter(search),
        this.qrPageBlocRouter = QRPageBlocRouter(toggle: toggle, getScan: getScan, confirmScan: confirmScan),
        this.registrationsPageBlocRouter = RegistrationsPageBlocRouter(getRegistrations),
        this.accountPageBlocRouter = AccountPageBlocRouter();
  
  Stream<RootState> route(HomeEvent event, User user) async* {
    if (event is PageChangeEvent) {
      final pages = [
        LoadingBrowseState(user),
        InitialSearchState(user),
        user.isLocked ? QRLockedState(user) : QRUnlockedState(user),
        RegistrationsLoadingState(user),
        AccountInitialState(user),
      ];
      yield pages[event.index];
    } else if (event is BrowsePageEvent) {
      yield* browsePageBlocRouter.route(event, user);
    } else if (event is SearchPageEvent) {
      yield* searchPageBlocRouter.route(event, user);
    } else if (event is QRPageEvent) {
      yield* qrPageBlocRouter.route(event, user);
    } else if (event is RegistrationsPageEvent) {
      yield* registrationsPageBlocRouter.route(event, user);
    } else if (event is AccountPageEvent) {
      yield* accountPageBlocRouter.route(event, user);
    }
  }
}
