import 'dart:async';

import 'package:Reso/features/reso/domain/usecases/can_register.dart';
import 'package:Reso/features/reso/domain/usecases/get_listings.dart';
import 'package:Reso/features/reso/domain/usecases/register.dart';
import 'package:Reso/features/reso/services/dynamic_links_service.dart';
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
part 'listings_page/listings_page_bloc.dart';
part 'listings_page/listings_page_event.dart';
part 'listings_page/listings_page_state.dart';
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
part 'unauthenticated_home/unauthenticated_home_bloc.dart';
part 'unauthenticated_home/unauthenticated_home_state.dart';
part 'unauthenticated_home/unauthenticated_home_event.dart';
part 'unauthenticated_browse_page/unauthenticated_browse_bloc.dart';
part 'unauthenticated_browse_page/unauthenticated_browse_event.dart';
part 'unauthenticated_browse_page/unauthenticated_browse_state.dart';
part 'unauthenticated_venue_page/unauthenticated_venue_bloc.dart';
part 'unauthenticated_venue_page/unauthenticated_venue_state.dart';
part 'unauthenticated_venue_page/unauthenticated_venue_event.dart';

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
  final GetScan getScan;
  final GetTimeSlots getTimeSlots;
  final GetRegistrations getRegistrations;
  final ToggleLock toggle;
  final ConfirmScan confirmScan;
  final CanRegister canRegister;
  final Register register;
  final DynamicLinksService dynamicLinksService;
  final GetListings getListings;
  HomePageBloc homeBloc;
  Map<String, dynamic> launchData;
  User user;
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
    @required this.canRegister,
    @required this.register,
    @required this.dynamicLinksService,
    @required this.getListings,
    this.launchData,
  })  : this.loginBloc = LoginBlocRouter(login),
        this.signupRouter = SignupBlocRouter(signup) {
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
      this.launchData = await dynamicLinksService.getLaunchData();
      print("launchData: ");
      print(launchData);
      final result = await getExistingUser(NoParams());
      yield* result.fold((failure) async* {
        if (failure is AuthenticationFailure) {
          yield UnauthenticatedState();
        } else if (failure is ConnectionFailure) {
          final getCachedUserOrFailure = await getCachedUser(NoParams());
          yield* getCachedUserOrFailure.fold(
            (failure) async* {
              yield ErrorState(message: Messages.NO_INTERNET);
            },
            (_user) async* {
              user = _user;
              final venuesOrFailure = await getVenues(NoParams());
              yield* venuesOrFailure.fold(
                (failure) async* {
                  yield LoadingFailedState(user, message: Messages.NO_INTERNET);
                },
                (venues) async* {
                  yield LoadedBrowseState(user, loadedVenues: venues);
                },
              );
            },
          );
        } else {
          yield ErrorState(message: failure.message);
        }
      }, (_user) async* {
        user = _user;
        homeBloc = HomePageBloc(user: user);
        yield AuthenticatedState(user);
        if (launchData != null) {
          if (launchData.containsKey("venue")) {
            ExtendedNavigator.rootNavigator.pushNamed(Routes.venue,
                arguments: VenueScreenArguments(
                    venue: Venue.getLoadingPlaceholder(launchData["venue"])));
          } else if (launchData.containsKey("user")) {
            ExtendedNavigator.rootNavigator.pushNamed(Routes.listingsScreen,
                arguments:
                    ListingsScreenArguments(id: int.parse(launchData["user"])));
          }
        }
      });
    } else if (event is LoginEvent) {
      yield* loginBloc.route(event);
      user = loginBloc.user;
      homeBloc = HomePageBloc(user: user);
      if (launchData != null) {
        if (launchData.containsKey("venue")) {
          ExtendedNavigator.rootNavigator.pushNamed(Routes.venue,
              arguments: VenueScreenArguments(
                  venue: Venue.getLoadingPlaceholder(launchData["venue"])));
        } else if (launchData.containsKey("user")) {
          ExtendedNavigator.rootNavigator.pushNamed(Routes.listingsScreen,
              arguments:
                  ListingsScreenArguments(id: int.parse(launchData["user"])));
        }
      }
    } else if (event is LogoutEvent) {
      await logout(NoParams());
      yield UnauthenticatedState();
    } else if (event is PasswordPageSubmitted) {
      yield SignupLoading();
      final result = await signup(
        SignupParams(
          email: signupRouter.email,
          firstName: signupRouter.firstName,
          lastName: signupRouter.lastName,
          password: event.password,
        ),
      );
      print(result);
      yield* result.fold(
        (failure) async* {
          yield SignupPasswordFailure(message: failure.message);
        },
        (success) async* {
          user = success;
          homeBloc = HomePageBloc(user: user);
          yield AuthenticatedState(user);
          ExtendedNavigator.rootNavigator.popUntil((route) => route.isFirst);
          if (launchData != null) {
            if (launchData.containsKey("venue")) {
              ExtendedNavigator.rootNavigator.pushNamed(Routes.venue,
                  arguments: VenueScreenArguments(
                      venue: Venue.getLoadingPlaceholder(launchData["venue"])));
            } else if (launchData.containsKey("user")) {
              ExtendedNavigator.rootNavigator.pushNamed(Routes.listingsScreen,
                  arguments: ListingsScreenArguments(
                      id: int.parse(launchData["user"])));
            }
          }
        },
      );
    } else if (event is SignupEvent) {
      yield* signupRouter.route(event);
    } else if (event is PopEvent) {
      ExtendedNavigator.rootNavigator.pop();
    } else if (event is PushVenue) {
      if (event.authenticated) {
        ExtendedNavigator.rootNavigator.pushNamed(Routes.venue,
            arguments: VenueScreenArguments(venue: event.venue));
      } else {
        ExtendedNavigator.rootNavigator.pushNamed(Routes.unauthenticatedVenue,
            arguments: UnauthenticatedVenueScreenArguments(venue: event.venue));
      }
    } else if (event is PushRegister) {
      ExtendedNavigator.rootNavigator.pushNamed(Routes.register,
          arguments: RegisterScreenArguments(
              timeSlot: event.timeslot, venue: event.venue));
    } else if (event is PushListings) {
      ExtendedNavigator.rootNavigator.pushNamed(Routes.listingsScreen,
          arguments: ListingsScreenArguments(id: event.id));
    } else if (event is ChangeLaunchDataEvent) {
      if (event.data != null) {
        this.launchData = event.data;
      }
    } else if (event is FullPopEvent) {
      ExtendedNavigator.rootNavigator.popUntil((route) => route.isFirst);
    }
  }
}
