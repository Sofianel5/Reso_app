part of '../root_bloc.dart';

class BrowseState extends HomeState {
  bool shouldShowType(int index) => false;
}

class LoadingBrowseState extends BrowseState implements LoadingState {
  final String message = Messages.LOADING;
  final User user;
  LoadingBrowseState({this.user});
}

class LoadingFailedState extends BrowseState {
  final String message;
  final User user;
  LoadingFailedState({this.message, this.user});
}

class LoadedBrowseState extends BrowseState {
  final List<Venue> loadedVenues;
  final User user;
  LoadedBrowseState({@required this.loadedVenues, @required this.user}) : assert(loadedVenues != null, user != null);
}