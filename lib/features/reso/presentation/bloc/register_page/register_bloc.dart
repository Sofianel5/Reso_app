part of '../root_bloc.dart';

class RegisterPageBlocRouter {
  CanRegister canRegister;
  Register register;
  RegisterPageBlocRouter({@required this.register, @required this.canRegister});
  Stream<RootState> route(RegisterEvent event, User user) async* {
    if (event is RegisterPageOpened) {
      yield InfoLoadingState();
      final result = await canRegister(RegisterParams(slot: event.timeSlot, venue: event.venue));
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