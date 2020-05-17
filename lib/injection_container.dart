import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/reso/data/datasources/local_datasource.dart';
import 'features/reso/data/datasources/remote_datasource.dart';
import 'features/reso/data/repositories/root_repository_imp.dart';
import 'features/reso/domain/repositories/root_repository.dart';
import 'features/reso/domain/usecases/confirm_scan.dart';
import 'features/reso/domain/usecases/get_cached_user.dart';
import 'features/reso/domain/usecases/get_registrations.dart';
import 'features/reso/domain/usecases/get_scan.dart';
import 'features/reso/domain/usecases/get_timeslots.dart';
import 'features/reso/domain/usecases/get_user.dart';
import 'features/reso/domain/usecases/get_venue_detail.dart';
import 'features/reso/domain/usecases/get_venues.dart';
import 'features/reso/domain/usecases/login.dart';
import 'features/reso/domain/usecases/logout.dart';
import 'features/reso/domain/usecases/register.dart';
import 'features/reso/domain/usecases/search.dart';
import 'features/reso/domain/usecases/signup.dart';
import 'features/reso/domain/usecases/toggle_lock_state.dart';
import 'features/reso/presentation/bloc/root_bloc.dart';
final sl = GetIt.instance;
Future<void> init() async {
  //! Features
  sl.registerFactory(() => RootBloc(getTimeSlots: sl(), toggle: sl(), confirmScan: sl(), getRegistrations: sl(), getScan: sl(), search: sl(), getExistingUser: sl(), login: sl(), signup: sl(), logout: sl(), getVenues: sl(), getVenueDetail: sl(), getCachedUser: sl()));
  // Register use cases 
  sl.registerLazySingleton<GetExistingUser>(() => GetExistingUser(sl()));
  sl.registerLazySingleton<ConfirmScan>(()=>ConfirmScan(sl()));
  sl.registerLazySingleton<GetRegistrations>(()=>GetRegistrations(sl()));
  sl.registerLazySingleton<GetScan>(()=>GetScan(sl()));
  sl.registerLazySingleton<GetTimeSlots>(()=>GetTimeSlots(sl()));
  sl.registerLazySingleton<Register>(()=>Register(sl()));
  sl.registerLazySingleton<ToggleLock>(()=>ToggleLock(sl()));
  sl.registerLazySingleton<Search>(() => Search(sl()));
  sl.registerLazySingleton<GetCachedUser>(() => GetCachedUser(sl()));
  sl.registerLazySingleton<Signup>(() => Signup(sl()));
  sl.registerLazySingleton<Login>(() => Login(sl()));
  sl.registerLazySingleton<Logout>(() => Logout(sl()));
  sl.registerLazySingleton<GetVenues>(()=> GetVenues(sl()));
  sl.registerLazySingleton<GetVenueDetail>(() => GetVenueDetail(sl()));
  // Register repositories
  sl.registerLazySingleton<RootRepository>(() => RootRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  // Register data sources 
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External dependencies
  sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
}