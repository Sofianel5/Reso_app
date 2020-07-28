part of '../root_bloc.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchState> {
  Search search;
  User user;
  String initialSearch;
  SearchPageBloc(this.search, this.user, {this.initialSearch}) {
    if (this.initialSearch != null) {
      this.add(SearchSubmitted(this.initialSearch));
    }
  }

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
        if (venues.length == 0) {
          yield NoResultsState(user);
        } else {
          yield SearchFinishedState(user, venues: venues);
        }
      });
    }
  }
}
