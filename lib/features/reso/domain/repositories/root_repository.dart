import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class RootRepository {
  Future<Either<Failure, User>> login({String email, String password});
  Future<Either<Failure, User>> signUp({String email, String password, String firstName, String lastName});
  Future<Either<Failure, Map<String, dynamic>>> getSession();
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, void>> logout();
}