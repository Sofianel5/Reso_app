part of '../root_bloc.dart';

class RegisterEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class RegisterPageOpened extends RegisterEvent {
  TimeSlot timeSlot;
  Venue venue;
  RegisterPageOpened({this.timeSlot, this.venue});
}

class AttemptRegister extends RegisterEvent {
  TimeSlot timeSlot;
  Venue venue;
  AttemptRegister({this.timeSlot, this.venue});
}

class RegisterPopEvent extends RegisterEvent {
  Venue venue;
  RegisterPopEvent({this.venue});
}