part of '../root_bloc.dart';

class QRState extends HomeState {
  QRState(User user) : super(user);
}

class QRLockedState extends QRState {
  User user;
  QRLockedState(this.user) : super(user);
}

class QRUnlockedState extends QRState {
  User user;
  QRUnlockedState(this.user): super(user);
}

class QRNoScanState extends QRLockedState {
  User user;
  QRNoScanState(this.user) : super(user);
}

class QRFailedState extends QRState {
  final String message;
  QRFailedState(User user, {@required this.message}) : super(user);
}

class QRLoadScanFailedState extends QRFailedState {
  final String message;
  QRLoadScanFailedState(User user, {@required this.message}) : super(user, message: message);
}

class QRScannedState extends QRLockedState {
  Thread thread;
  QRScannedState(User user, {this.thread}) : super(user);
}

class QRLoadingState extends QRState {
  final User user;
  QRLoadingState(this.user): super(user);
}

class QRUnlockFailedState extends QRFailedState {
  final String message;
  QRUnlockFailedState(User user, {this.message}) : super(user, message: message);
}

class QRConfirmEntryFailedState extends QRFailedState {
  final String message;
  QRConfirmEntryFailedState(User user, {this.message}) : super(user, message: message);
}

class QREntryConfirmedState extends QRLockedState {
  QREntryConfirmedState(User user) : super(user);
}