part of 'root_bloc.dart';

class LoginState extends UnauthenticatedState {
  @override
  List<Object> get props => [];
}

class LoginFailedState extends LoginState {
  final Map<String, String> widgetMessages;
  final String globalMessage;
  LoginFailedState({this.widgetMessages, this.globalMessage});
  bool hasError(String field) {
    if (widgetMessages == null) {
      return false;
    }
    return widgetMessages.containsKey(field);
  }
}
class LoginLoadingState extends LoginState implements LoadingState {
  @override
  String get message => Messages.LOADING;
}