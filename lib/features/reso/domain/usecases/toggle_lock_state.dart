import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class ToggleLock extends UseCase<bool, NoParams> {
  final RootRepository repository;
  ToggleLock(this.repository);

  @override 
  Future<Either<Failure, bool>> call(NoParams params) async {
   return await repository.toggleLockState();
  }
}
