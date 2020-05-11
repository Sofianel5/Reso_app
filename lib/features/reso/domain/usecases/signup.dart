import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/root_repository.dart';

class Signup extends UseCase<User, SignupParams> {
  final RootRepository repository;
  Signup(this.repository);
  @override
  Future<Either<Failure, User>> call(SignupParams params) async {
    return await repository.signUp(email: params.email, password: params.password, firstName: params.firstName, lastName: params.lastName);
  }
  
}

class SignupParams extends Params {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  SignupParams({@required this.email, @required this.password, @required this.firstName, @required this.lastName});

  @override
  List<Object> get props => [email, password];
}