part of 'root_bloc.dart';
class HomeState extends AuthenticatedState {
  int pageIndex;
  HomeState(User user, {this.pageIndex=0}) : super(user);
}


