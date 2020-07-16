import 'package:Reso/core/localizations/messages.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class Failure extends Equatable {
  final String message;
  Failure({this.message}) : assert(message != null);
  @override
  List<Object> get props => const <dynamic>[];
}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({
    @required this.message,
  }) : super(message: message);
  List<Object> get props => <dynamic>[message];
}

class CacheFailure extends Failure {
  final String message;
  CacheFailure({@required this.message}) : super(message: message);
  List<Object> get props => <dynamic>[message];
}

class ConnectionFailure extends Failure {
  final String message;
  ConnectionFailure({@required this.message}) : super(message: message);
}

class AuthenticationFailure extends ServerFailure {
  final String message;
  AuthenticationFailure({@required this.message}) : super(message: message);
}

class InvalidInputFailure extends Failure {
  final String message;
  InvalidInputFailure({@required this.message}) : super(message: message);
}

class InvalidFormFailure extends Failure {
  final Map<String, String> messages;
  InvalidFormFailure({this.messages}) : assert(messages != null && messages.length != 0), super(message: Messages.INVALID_FORM);
}

class UnknownFailure extends Failure {
  UnknownFailure() : super(message: Messages.UNKNOWN_ERROR);
}

class NoScanFailure extends Failure {
  NoScanFailure() : super(message: Messages.NO_SCAN);
}

class CannotRegisterFailure extends Failure {
  CannotRegisterFailure() : super(message: Messages.CANNOT_REGISTER);
}

class NeedsUpdateFailure extends Failure {
  NeedsUpdateFailure() : super(message: Messages.NEEDS_UPDATE);
}

class IncompleteRegistrationFailure extends Failure {
  IncompleteRegistrationFailure() : super(message: Messages.MUST_AGREE);
}