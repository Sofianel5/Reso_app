part of '../root_bloc.dart';

class RegisterState extends RootState {
  @override
  List<Object> get props => [];
}

class InfoLoadingState extends RegisterState {}

class CannotRegisterState extends RegisterState {}

class CanRegisterState extends RegisterState {}

class RegisterFailedState extends RegisterState {
  final String message;
  RegisterFailedState(this.message);
}

class RegisteredSuccessfullyState extends RegisterState {}
