import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/root_repository.dart';

class Login extends UseCase<User, LoginParams> {
  final RootRepository repository;
  Login(this.repository);

  @override 
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Params {
  final String email;
  final String password;
  LoginParams({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
  
}