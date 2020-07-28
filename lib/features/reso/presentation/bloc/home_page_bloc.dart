part of 'root_bloc.dart';

class HomePageBloc extends Bloc<HomeEvent, HomeState> {
  final User user;
  HomePageBloc({@required this.user});

  @override
  HomeState get initialState => HomeState(user);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print(event);
    if (event is PageChangeEvent) {
      yield HomeState(this.user, pageIndex: event.index);
    } else if (event is DeepLinkedSearchEvent) {
      yield DeepLinkedSearchState(this.user, event.query);
    }
  }
}
