import 'package:Reso/features/reso/domain/entities/timeslot.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class Register extends UseCase<bool, RegisterParams> {
  final RootRepository repository;
  Register(this.repository);

  @override 
  Future<Either<Failure, bool>> call(RegisterParams params) async {
    return await repository.register(params.slot);
  }
}

class RegisterParams extends Params {
  final TimeSlot slot;
  RegisterParams({@required this.slot}) : assert(slot != null);
  @override
  List<Object> get props => [id];
}