part of '../root_bloc.dart';

class AccountState extends HomeState {
  AccountState(User user) : super(user);
}

class AccountInitialState extends AccountState {
  AccountInitialState(User user) : super(user);
}

class AccountLoadedState extends AccountState {
  AccountLoadedState(User user) : super(user);
}