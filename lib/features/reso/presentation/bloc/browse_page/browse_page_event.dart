part of '../root_bloc.dart';

class BrowsePageEvent extends HomeEvent {

}

class BrowsePageCreationEvent extends BrowsePageEvent {
  final User user; 
  BrowsePageCreationEvent({@required this.user});
}

class BrowsePageRefreshEvent extends BrowsePageEvent {}
