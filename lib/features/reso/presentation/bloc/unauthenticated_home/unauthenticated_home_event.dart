part of '../root_bloc.dart';

class UnauthenticatedHomeEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class UnauthenticatedHomePageChangeEvent extends UnauthenticatedHomeEvent {
  final int index;
  UnauthenticatedHomePageChangeEvent({@required this.index}) : assert(index != null);
}
