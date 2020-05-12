import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/root_repository.dart';

class GetExistingUser extends UseCase<User, NoParams> {
  final RootRepository repository;
  GetExistingUser(this.repository);

  @override 
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getUser();
  }
}
