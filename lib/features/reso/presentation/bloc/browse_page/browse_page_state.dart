part of '../root_bloc.dart';

class BrowseState extends HomeState {
  BrowseState(User user) : super(user);
  bool shouldShowType(int index) => false;
}

class LoadingBrowseState extends BrowseState implements LoadingState {
  final String message = Messages.LOADING;
  LoadingBrowseState(User user) : super(user);
}

class LoadingFailedState extends BrowseState {
  final String message;
  LoadingFailedState(User user, {this.message}) : super(user);
}

class LoadedBrowseState extends BrowseState {
  final List<Venue> loadedVenues;
  LoadedBrowseState(User user, {@required this.loadedVenues}) : assert(loadedVenues != null, user != null), super(user);
}