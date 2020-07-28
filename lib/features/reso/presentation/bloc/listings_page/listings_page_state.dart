part of '../root_bloc.dart';

class ListingsPageState extends HomeState {
  ListingsPageState(User user) : super(user);
}

class ListingsPageLoadingState extends ListingsPageState {
  ListingsPageLoadingState(User user) : super(user);
}

class ListingsPageLoadFailedState extends ListingsPageState {
  final String message;
  ListingsPageLoadFailedState(User user, this.message) : super(user);
}

class ListingsPageLoadedState extends ListingsPageState {
  List<Venue> venues;
  User venuesAdmin;
  ListingsPageLoadedState(User user, this.venues, this.venuesAdmin) : super(user);
}