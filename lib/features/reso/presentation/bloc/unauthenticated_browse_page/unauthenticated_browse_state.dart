part of '../root_bloc.dart';

class UnauthenticatedBrowseState extends UnauthenticatedHomeState {
  UnauthenticatedBrowseState();
  bool shouldShowType(int index) => false;
}

class UnauthenticatedLoadingBrowseState extends UnauthenticatedBrowseState implements LoadingState {
  final String message = Messages.LOADING;
  UnauthenticatedLoadingBrowseState();
}

class UnauthenticatedLoadingFailedState extends UnauthenticatedBrowseState {
  final String message;
  UnauthenticatedLoadingFailedState({this.message});
}

class UnauthenticatedLoadedBrowseState extends UnauthenticatedBrowseState {
  final List<Venue> loadedVenues;
  List<String> filters;
  UnauthenticatedLoadedBrowseState( {@required this.loadedVenues, this.filters}) : assert(loadedVenues != null) {
    if (filters == null) {
      filters = [Venue.types.first];
    }
  }
}

class UnauthenticatedBrowsePoppedIn extends UnauthenticatedLoadingFailedState {
  UnauthenticatedBrowsePoppedIn();
}