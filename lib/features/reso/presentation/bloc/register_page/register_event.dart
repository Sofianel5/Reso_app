part of '../root_bloc.dart';

class RegisterEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class RegisterPageOpened extends RegisterEvent {
}

class AttemptRegister extends RegisterEvent {
  TimeSlot timeSlot;
  Map<String, bool> data;
  Venue venue;
  AttemptRegister({this.timeSlot, this.venue, this.data});
}

class RegisterPopEvent extends RegisterEvent {
  Venue venue;
  RegisterPopEvent({this.venue});
}