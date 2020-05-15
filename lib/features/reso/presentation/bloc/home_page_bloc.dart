part of 'root_bloc.dart';

class HomePageBlocRouter {
  final GetVenues getVenues;
  final GetVenueDetail getVenueDetail;
  final BrowsePageBlocRouter browsePageBlocRouter;
  final SearchPageBlocRouter searchPageBlocRouter;
  final QRPageBlocRouter qrPageBlocRouter;
  final HistoryPageBlocRouter historyPageBlocRouter;
  final AccountPageBlocRouter accountPageBlocRouter;
  HomePageBlocRouter({@required this.getVenues, @required this.getVenueDetail})
      : this.browsePageBlocRouter = BrowsePageBlocRouter(
            getVenueDetail: getVenueDetail, getVenues: getVenues),
        this.searchPageBlocRouter = SearchPageBlocRouter(),
        this.qrPageBlocRouter = QRPageBlocRouter(),
        this.historyPageBlocRouter = HistoryPageBlocRouter(),
        this.accountPageBlocRouter = AccountPageBlocRouter();
  final List<HomeState> pages = [
    BrowseState(),
    SearchState(),
    QRState(),
    HistoryState(),
    AccountState(),
  ];
  Stream<RootState> route(HomeEvent event, User user) async* {
    if (event is PageChangeEvent) {
      yield pages[event.index];
    } else if (event is BrowsePageEvent) {
      yield* browsePageBlocRouter.route(event, user);
    } else if (event is SearchPageEvent) {
      yield* searchPageBlocRouter.route(event, user);
    } else if (event is QRPageEvent) {
      yield* qrPageBlocRouter.route(event, user);
    } else if (event is HistoryPageEvent) {
      yield* historyPageBlocRouter.route(event, user);
    } else if (event is AccountPageEvent) {
      yield* accountPageBlocRouter.route(event, user);
    }
  }
}
