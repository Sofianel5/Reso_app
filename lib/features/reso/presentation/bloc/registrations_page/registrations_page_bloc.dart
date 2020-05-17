part of '../root_bloc.dart';

class RegistrationsPageBlocRouter {
  GetRegistrations getRegistrations;
  RegistrationsPageBlocRouter(this.getRegistrations);
  Map<String, List<TimeSlot>> registrations;
  Stream<RootState> route(RegistrationsPageEvent event, User user) async* {
    if (event is RegistrationsPageCreatedEvent) {
      yield RegistrationsLoadingState(user);
      final registrationsOrFail = await getRegistrations(NoParams());
      yield* registrationsOrFail.fold((failure) async* {
        yield RegistrationsLoadFailure(user, failure.message);
      }, (result) async* {
        registrations = result;
        if (registrations["current"].length == 0) {
          yield NoCurrentRegistrations(user, []);
        } else {
          yield RegistrationsCurrentState(user, registrations["current"]);
        }
      });
    } else if (event is RegistrationsPageRequestHistory) {
      if (registrations == null) {
        yield RegistrationsLoadingState(user);
      } else if (registrations["current"]?.length == 0) {
        yield NoPreviousRegistrations(user, registrations["current"]);
      } else {
        yield RegistrationsHistoryState(user, registrations["current"]);
      }
      yield RegistrationsHistoryState(user, registrations["history"]);
    } else if (event is RegistrationsPageRequestCurrent) {
      if (registrations == null) {
        yield RegistrationsLoadingState(user);
      } else if (registrations["current"]?.length == 0) {
        yield NoCurrentRegistrations(user, registrations["current"]);
      } else {
        yield RegistrationsCurrentState(user, registrations["current"]);
      }
    }
  }
}