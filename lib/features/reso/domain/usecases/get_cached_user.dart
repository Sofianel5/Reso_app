import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/root_repository.dart';

class GetCachedUser extends UseCase<User, NoParams> {
  final RootRepository repository;
  GetCachedUser(this.repository);

  @override 
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCachedUser();
  }
}
