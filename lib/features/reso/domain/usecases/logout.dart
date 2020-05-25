import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class Logout extends UseCase<void, NoParams> {
  final RootRepository repository;
  Logout(this.repository);

  @override 
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}