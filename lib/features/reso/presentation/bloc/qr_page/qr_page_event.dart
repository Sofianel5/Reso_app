part of '../root_bloc.dart';

class QRPageEvent extends HomeEvent {}

class QRPageCreated extends QRPageEvent {}

class QRLockToggle extends QRPageEvent {}

class ScanConfirmed extends QRPageEvent {
  Thread thread;
  ScanConfirmed(this.thread);
}

class QRCheckScan extends QRPageEvent {}