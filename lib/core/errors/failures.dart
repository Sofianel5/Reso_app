import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure();
  @override
  List<Object> get props => const <dynamic>[];
}

class ServerFailure extends Failure {
  final int errnum;
  final String messageCode;
  ServerFailure({
    this.errnum,
    this.messageCode,
  });
  List<Object> get props => <dynamic>[errnum, messageCode];
}
class CacheFailure  extends Failure {
  final String messageCode;
  CacheFailure({
    this.messageCode
  });
  List<Object> get props => <dynamic>[messageCode];
}
class ConnectionFailure extends Failure {
  final String messageCode = "NoConnection";
  ConnectionFailure();
}
class AuthenticationFailure extends ServerFailure {
  final errorno = 403;
  final messageCode = "AuthFailure";
  AuthenticationFailure();
}
