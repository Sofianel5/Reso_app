import 'dart:async';

import 'package:Reso/core/errors/failures.dart';
import 'package:Reso/core/usecases/params.dart';
import 'package:Reso/features/reso/domain/usecases/get_session.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


import '../../../../core/localizations/messages.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final GetExistingUser getExistingUser;
  final Login login;
  final Signup signup;
  final GetSessions getSessions;
  final Logout logout;
  RootBloc(
      {@required this.getExistingUser,
      @required this.login,
      @required this.getSessions,
      @required this.signup,
      @required this.logout,}) {
    this.add(GetExistingUserEvent());
  }
  @override
  RootState get initialState => InitialState();

  @override
  Stream<RootState> mapEventToState(
    RootEvent event,
  ) async* {
    if (event is GetExistingUserEvent) {
      final result = await getExistingUser(NoParams());
      yield* result.fold((failure) async* {
        if (failure is AuthenticationFailure) {
          yield UnauthenticatedState();
        } else if (failure is ConnectionFailure) {
          // Try to load cached data in future
          final sessionsOrFailure = await getSessions(NoParams());
          yield* sessionsOrFailure.fold((failure) async* {
            yield LoginState();
          }, (sessions) async* {
            yield AuthenticatedState();
          });
          yield ErrorState(message: Messages.NO_INTERNET);
        } else {
          yield ErrorState(message: Messages.UNKNOWN_ERROR);
        }
      }, (user) async* {
        yield AuthenticatedState(user: user);
      });
    } else if (event is LoginEvent) {
      final result = await login(event.params);
      yield LoadingState();
      yield* result.fold((failure) async* {
        if (failure is InvalidFormFailure) {
          yield LoginState(widgetMessages: failure.messages);
        } else {
          yield LoginState(globalMessage: failure.message);
        }
      }, (user) async* {
        yield AuthenticatedState(user: user);
      });
    }
  }
}
