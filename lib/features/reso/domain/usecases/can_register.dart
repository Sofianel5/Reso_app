import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';
import 'register.dart';

class CanRegister extends UseCase<bool, RegisterParams> {
  final RootRepository repository;
  CanRegister(this.repository);

  @override 
  Future<Either<Failure, bool>> call(RegisterParams params) async {
    return await repository.canRegister(params.slot, params.venue);
  }
}