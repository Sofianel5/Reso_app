part of '../root_bloc.dart';

class SearchState extends HomeState {}

class InitialSearchState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchFinishedState extends SearchState {
  final List<Venue> venues;
  SearchFinishedState({@required this.venues}) : assert(venues != null);
}

class SearchFailedState extends SearchState {
  final String message;
  SearchFailedState({@required this.message});
}