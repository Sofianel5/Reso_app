part of '../root_bloc.dart';

class RegistrationsPageBloc extends Bloc<RegistrationsPageEvent, RegistrationsState> {
  GetRegistrations getRegistrations;
  RegistrationsPageBloc(this.getRegistrations, this.user) {
    this.add(RegistrationsPageCreatedEvent());
  }
  User user;
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

  @override
  RegistrationsState get initialState => RegistrationsLoadingState(this.user);

  @override
  Stream<RegistrationsState> mapEventToState(RegistrationsPageEvent event) async* {
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
      } else if (registrations["history"]?.length == 0) {
        yield NoPreviousRegistrations(user, registrations["history"]);
      } else {
        yield RegistrationsHistoryState(user, registrations["history"]);
      }
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