import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/localizations/messages.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/util/input_converter.dart';
import '../../../../routes/routes.gr.dart';
import '../../domain/entities/thread.dart';
import '../../domain/entities/timeslot.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/venue.dart';
import '../../domain/usecases/confirm_scan.dart';
import '../../domain/usecases/get_cached_user.dart';
import '../../domain/usecases/get_registrations.dart';
import '../../domain/usecases/get_scan.dart';
import '../../domain/usecases/get_timeslots.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_venue_detail.dart';
import '../../domain/usecases/get_venues.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/search.dart';
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/toggle_lock_state.dart';

part 'account_page/account_page_bloc.dart';
part 'account_page/account_page_event.dart';
part 'account_page/account_page_state.dart';
part 'browse_page/browse_page_bloc.dart';
part 'browse_page/browse_page_event.dart';
part 'browse_page/browse_page_state.dart';
part 'home_page_bloc.dart';
part 'home_page_event.dart';
part 'home_page_state.dart';
part 'login_page_bloc.dart';
part 'login_page_event.dart';
part 'login_page_state.dart';
part 'qr_page/qr_page_bloc.dart';
part 'qr_page/qr_page_event.dart';
part 'qr_page/qr_page_state.dart';
part 'registrations_page/registrations_page_bloc.dart';
part 'registrations_page/registrations_page_event.dart';
part 'registrations_page/registrations_page_state.dart';
part 'root_event.dart';
part 'root_state.dart';
part 'search_page/search_page_bloc.dart';
part 'search_page/search_page_event.dart';
part 'search_page/search_page_state.dart';
part 'signup/signup_bloc.dart';
part 'signup/signup_event.dart';
part 'signup/signup_state.dart';
part 'venue_page/venue_page_bloc.dart';
part 'venue_page/venue_page_event.dart';
part 'venue_page/venue_page_state.dart';
part 'register_page/register_bloc.dart';
part 'register_page/register_event.dart';
part 'register_page/register_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final GetExistingUser getExistingUser;
  final Login login;
  final Signup signup;
  final Logout logout;
  final LoginBlocRouter loginBloc;
  final GetCachedUser getCachedUser;
  final SignupBlocRouter signupRouter;
  final GetVenues getVenues;
  final Search search;
  final GetVenueDetail getVenueDetail;
  final HomePageBlocRouter homePageBloc;
  final GetScan getScan;
  final GetTimeSlots getTimeSlots;
  final GetRegistrations getRegistrations;
  final ToggleLock toggle;
  final ConfirmScan confirmScan;
  User _user;
  RootBloc({
    @required this.getExistingUser,
    @required this.login,
    @required this.signup,
    @required this.logout,
    @required this.getVenues,
    @required this.getVenueDetail,
    @required this.getCachedUser,
    @required this.search,
    @required this.confirmScan,
    @required this.getRegistrations,
    @required this.toggle,
    @required this.getScan,
    @required this.getTimeSlots,
  })  : this.loginBloc = LoginBlocRouter(login),
        this.signupRouter = SignupBlocRouter(signup),
        this.homePageBloc = HomePageBlocRouter(
            getTimeSlots: getTimeSlots,
            getVenueDetail: getVenueDetail,
            getVenues: getVenues,
            search: search,
            confirmScan: confirmScan,
            getScan: getScan,
            toggle: toggle,
            getRegistrations: getRegistrations) {
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
          }, (user) async* {
            _user = user;
            final venuesOrFailure = await getVenues(NoParams());
            yield* venuesOrFailure.fold((failure) async* {
              yield LoadingFailedState(user, message: Messages.NO_INTERNET);
            }, (venues) async* {
              yield LoadedBrowseState(user, loadedVenues: venues);
            });
          });
        } else {
          yield ErrorState(message: failure.message);
        }
      }, (user) async* {
        _user = user;
        yield AuthenticatedState(user);
      });
    } else if (event is LoginEvent) {
      yield* loginBloc.route(event);
    } else if (event is HomeEvent) {
      yield* homePageBloc.route(event, _user);
    } else if (event is LogoutEvent) {
      await logout(NoParams());
      yield UnauthenticatedState();
    } else if (event is PasswordPageSubmitted) {
      yield SignupLoading();
      final result = await signup(SignupParams(email: signupRouter.email, firstName: signupRouter.firstName, lastName: signupRouter.lastName, password: event.password));
      print(result);
      yield* result.fold((failure) async* {
        yield SignupPasswordFailure(message: failure.message);
      }, (success) async* {
        _user = success;
        yield AuthenticatedState(_user);
      });
    } else if (event is SignupEvent) {
      yield* signupRouter.route(event);
    }
  }
}
