part of '../root_bloc.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchState> {
  Search search;
  User user;
  SearchPageBloc(this.search, this.user);

  @override
  get initialState => InitialSearchState(user);

  @override
  Stream<SearchState> mapEventToState(SearchPageEvent event) async* {
    if (event is SearchCancelled) {
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
