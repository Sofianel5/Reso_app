import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/root_repository.dart';

class Logout extends UseCase<User, NoParams> {
  final RootRepository repository;
  Logout(this.repository);

  @override 
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.logout();
  }
}