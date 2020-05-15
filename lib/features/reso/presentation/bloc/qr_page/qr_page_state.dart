part of '../root_bloc.dart';

class QRState extends HomeState {}

class QRLockedState extends QRState {}

class QRUnlockedState extends QRState {}

class QRNoScanState extends QRLockedState {}

class QRScannedState extends QRLockedState {}

class QRLoadingState extends QRState {}

class QRUnlockFailedState extends QRLockedState {}

class QRConfirmEntryFailedState extends QRLockedState {}