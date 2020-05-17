part of '../root_bloc.dart';

class RegistrationsState extends HomeState {
  RegistrationsState(User user) : super(user);
}

class RegistrationsLoadingState extends RegistrationsState {
  RegistrationsLoadingState(User user) : super(user);
}

class RegistrationsLoadFailure extends RegistrationsState {
  String message;
  RegistrationsLoadFailure(User user, this.message) : super(user);
}

class RegistrationsLoaded extends RegistrationsState {
  List<TimeSlot> timeSlots;
  RegistrationsLoaded(User user, this.timeSlots) : super(user);
}

class RegistrationsHistoryState extends RegistrationsLoaded {
  RegistrationsHistoryState(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}

class RegistrationsCurrentState extends RegistrationsLoaded {
  RegistrationsCurrentState(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}

class NoCurrentRegistrations extends RegistrationsCurrentState {
  NoCurrentRegistrations(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}

class NoPreviousRegistrations extends RegistrationsHistoryState {
  NoPreviousRegistrations(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}