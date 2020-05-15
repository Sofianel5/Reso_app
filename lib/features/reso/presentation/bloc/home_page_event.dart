part of 'root_bloc.dart';

class HomeEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class PageChangeEvent extends HomeEvent {
  final int index;
  PageChangeEvent({@required this.index}) : assert(index != null);
}
