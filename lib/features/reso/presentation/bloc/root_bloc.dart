import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/localizations/messages.dart';
import '../../../../core/usecases/params.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/venue.dart';
import '../../domain/usecases/get_cached_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_venue_detail.dart';
import '../../domain/usecases/get_venues.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/search.dart';
import '../../domain/usecases/signup.dart';

part 'account_page/account_page_bloc.dart';
part 'account_page/account_page_event.dart';
part 'account_page/account_page_state.dart';
part 'browse_page/browse_page_bloc.dart';
part 'browse_page/browse_page_event.dart';
part 'browse_page/browse_page_state.dart';
part 'history_page/history_page_bloc.dart';
part 'history_page/history_page_event.dart';
part 'history_page/history_page_state.dart';
part 'home_page_bloc.dart';
part 'home_page_event.dart';
part 'home_page_state.dart';
part 'login_page_bloc.dart';
part 'login_page_event.dart';
part 'login_page_state.dart';
part 'qr_page/qr_page_bloc.dart';
part 'qr_page/qr_page_event.dart';
part 'qr_page/qr_page_state.dart';
part 'root_event.dart';
part 'root_state.dart';
part 'search_page/search_page_bloc.dart';
part 'search_page/search_page_event.dart';
part 'search_page/search_page_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final GetExistingUser getExistingUser;
  final Login login;
  final Signup signup;
  final Logout logout;
  final LoginBlocRouter loginBloc;
  final GetCachedUser getCachedUser;
  final GetVenues getVenues;
  final Search search;
  final GetVenueDetail getVenueDetail;
  final HomePageBlocRouter homePageBloc;
  User _user;
  RootBloc({
    @required this.getExistingUser,
    @required this.login,
    @required this.signup,
    @required this.logout,
    @required this.getVenues,
    @required this.getVenueDetail,
    @required this.getCachedUser,
    @required this.search
  })  : this.loginBloc = LoginBlocRouter(login),
        this.homePageBloc = HomePageBlocRouter(
            getVenueDetail: getVenueDetail, getVenues: getVenues, search: search) {
    this.add(GetExistingUserEvent());
  }
  @override
  RootState get initialState => InitialState();

  @override
  Stream<RootState> mapEventToState(
    RootEvent event,
  ) async* {
    print(event);
    if (event is GetExistingUserEvent) {
      final result = await getExistingUser(NoParams());
      yield* result.fold((failure) async* {
        if (failure is AuthenticationFailure) {
          yield UnauthenticatedState();
        } else if (failure is ConnectionFailure) {
          final getCachedUserOrFailure = await getCachedUser(NoParams());
          yield* getCachedUserOrFailure.fold((failure) async* {
            yield ErrorState(message: Messages.NO_INTERNET);
          },
              (user) async* {
                _user = user;
            final venuesOrFailure = await getVenues(NoParams());
            yield* venuesOrFailure.fold((failure) async* {
              yield LoadingFailedState(message: Messages.NO_INTERNET);
            }, (venues) async* {
              yield LoadedBrowseState(user: user, loadedVenues: venues);
            });
          });
        } else {
          yield ErrorState(message: Messages.UNKNOWN_ERROR);
        }
      }, (user) async* {
        _user = user;
        yield AuthenticatedState(user: user);
      });
    } else if (event is LoginEvent) {
      yield* loginBloc.route(event);
    } else if (event is HomeEvent) {
      yield* homePageBloc.route(event, _user);
    } 
  }
}
