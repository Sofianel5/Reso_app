part of '../root_bloc.dart';

class RegisterPageBloc extends Bloc<RegisterEvent, RegisterState> {
  CanRegister canRegister;
  Register register;
  TimeSlot timeslot;
  Venue venue;
  RegisterPageBloc({@required this.timeslot, @required this.venue, @required this.register, @required this.canRegister}) {
    this.add(RegisterPageOpened());
  }
  Stream<RootState> route(RegisterEvent event, User user) async* {
    if (event is RegisterPageOpened) {
      yield InfoLoadingState();
      final result = await canRegister(RegisterParams(slot: timeslot, venue: venue));
      yield* result.fold((failure) async* {
        yield CannotRegisterState();
      }, (res) async* {
        yield CanRegisterState();
      });
    } else if (event is AttemptRegister) {
      yield InfoLoadingState();
      final result = await register(RegisterParams(slot: event.timeSlot, venue: event.venue));
      yield* result.fold((failure) async* {
        yield RegisterFailedState(failure.message);
      }, (res) async* {
        yield RegisteredSuccessfullyState();
      });
    } else if (event is RegisterPopEvent) {
      ExtendedNavigator.rootNavigator.pop();
      yield VenuePoppedInState(user, event.venue);
    }
  }

  @override
  RegisterState get initialState => InfoLoadingState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterPageOpened) {
      final result = await canRegister(RegisterParams(slot: timeslot, venue: venue));
      yield* result.fold((failure) async* {
        yield CannotRegisterState();
      }, (res) async* {
        yield CanRegisterState();
      });
    } else if (event is AttemptRegister) {
      yield InfoLoadingState();
      final result = await register(RegisterParams(slot: event.timeSlot, venue: event.venue));
      yield* result.fold((failure) async* {
        yield RegisterFailedState(failure.message);
      }, (res) async* {
        yield RegisteredSuccessfullyState();
      });
    }
  }
}