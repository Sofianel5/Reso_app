part of '../root_bloc.dart';

class SearchPageEvent extends HomeEvent {}

class SearchPageCreated extends SearchPageEvent {}

class SearchCancelled extends SearchPageEvent {}

class SearchTyping extends SearchPageEvent {}

class SearchSubmitted extends SearchPageEvent {
  final String query;
  SearchSubmitted(this.query);
}
