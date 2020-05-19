import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/thread.dart';
import '../repositories/root_repository.dart';

class GetScan extends UseCase<Thread, NoParams> {
  final RootRepository repository;
  GetScan(this.repository);

  @override 
  Future<Either<Failure, Thread>> call(NoParams params) async {
    return await repository.checkForScan();
  }
}