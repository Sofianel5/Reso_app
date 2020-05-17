part of '../root_bloc.dart';

class SearchPageBlocRouter {
  Search search;
  SearchPageBlocRouter(this.search);
  Stream<RootState> route(SearchPageEvent event, User user) async* {
    if (event is SearchPageCreated) {
      yield InitialSearchState(user); 
    } else if (event is SearchCancelled) {
      yield InitialSearchState(user);
    } else if (event is SearchSubmitted) {
      yield SearchLoadingState(user);
      final result = await search(SearchParams(query: event.query));
      yield* result.fold((failure) async* {
        yield SearchFailedState(user, message: failure.message);
      }, (venues) async* {
        yield SearchFinishedState(user, venues: venues);
      });
    }
  }
}
