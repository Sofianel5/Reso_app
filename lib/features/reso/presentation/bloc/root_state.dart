part of 'root_bloc.dart';

abstract class RootState extends Equatable {
  const RootState();
}

class InitialState extends RootState {
  @override
  List<Object> get props => [];
}

class ErrorState extends RootState {
  final String message;
  ErrorState({this.message});
  @override
  List<Object> get props => [message];
}

class UnauthenticatedState extends RootState {
   
  @override
  List<Object> get props => throw UnimplementedError();
  
}

class AuthenticatedState extends RootState {
  final User user;

  AuthenticatedState({this.user});
  @override
  List<Object> get props => [user];
  
}