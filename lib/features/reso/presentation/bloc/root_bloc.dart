import 'dart:async';

import 'package:Reso/core/network/network_info.dart';
import 'package:Reso/features/reso/domain/repositories/root_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup.dart';

part 'root_event.dart';
part 'root_state.dart';

const int NO_INTERNET_FAILURE = 1;
const int SERVER_FAILURE = 2;
const int CACHE_FAILURE = 3;

class RootBloc extends Bloc<RootEvent, RootState> {
  final GetExistingUser getExistingUser;
  final Login login;
  final Signup signup;
  final Logout logout;
  final InputConverter inputConverter;
  final RootRepository repository;
  final NetworkInfoImpl networkInfo;
  RootBloc({
    @required this.getExistingUser,
    @required this.login,
    @required this.signup,
    @required this.logout,
    @required this.inputConverter,
    @required this.repository,
    @required this.networkInfo
  }) {
    this.add(GetExistingUserEvent());
  }
  @override
  RootState get initialState => InitialState();

  @override
  Stream<RootState> mapEventToState(
    RootEvent event,
  ) async* {
    if (event is GetExistingUserEvent) {

    }
  }
}
