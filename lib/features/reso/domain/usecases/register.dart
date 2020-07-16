import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeslot.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class Register extends UseCase<bool, RegisterParams> {
  final RootRepository repository;
  Register(this.repository);

  @override 
  Future<Either<Failure, bool>> call(RegisterParams params) async {
    if (params.venue.maskRequired) {
      if (!params.data["mask"]) {
        return Left(IncompleteRegistrationFailure());
      }
    } 
    if (params.venue.requiresForm) {
      if (!params.data["form"]) {
        return Left(IncompleteRegistrationFailure());
      }
    }
    return await repository.register(params.slot, params.venue);
  }
}

class RegisterParams extends Params {
  final TimeSlot slot;
  final Venue venue;
  final Map<String, bool> data;
  RegisterParams({@required this.slot, @required this.venue, @required this.data}) : assert(slot != null);
  @override
  List<Object> get props => [id];
}