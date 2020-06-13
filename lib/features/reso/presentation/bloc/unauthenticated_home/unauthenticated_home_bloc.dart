part of '../root_bloc.dart';

class UnauthenticatedHomePageBloc extends Bloc<UnauthenticatedHomeEvent, UnauthenticatedHomeState> {
  UnauthenticatedHomePageBloc();

  @override
  UnauthenticatedHomeState get initialState => UnauthenticatedHomeState();

  @override
  Stream<UnauthenticatedHomeState> mapEventToState(UnauthenticatedHomeEvent event) async* {
    print(event);
    if (event is UnauthenticatedHomePageChangeEvent) {
      yield UnauthenticatedHomeState(pageIndex: event.index);
    }
  }
}
