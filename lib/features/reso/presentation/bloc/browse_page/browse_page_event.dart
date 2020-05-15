part of '../root_bloc.dart';

class BrowsePageEvent extends HomeEvent {

}

class BrowsePageCreationEvent extends BrowsePageEvent {
  final User user; 
  BrowsePageCreationEvent({@required this.user});
}

class SelectVenueEvent extends BrowsePageEvent {
  final Venue venue;
  SelectVenueEvent({@required this.venue}) : assert(venue != null);
}

class BrowsePageRefreshEvent extends BrowsePageEvent {}
