part of '../root_bloc.dart';

class QRPageBloc extends Bloc<QRPageEvent, QRState> {
  ToggleLock toggle;
  GetScan getScan;
  ConfirmScan confirmScan;
  User user;
  QRPageBloc(
      {@required this.user,
      @required this.toggle,
      @required this.getScan,
      @required this.confirmScan}) {
        this.add(QRPageCreated());
      }

  Stream<RootState> route(QRPageEvent event, User user) async* {
    if (event is QRPageCreated) {
      if (user.isLocked) {
        yield QRLockedState(user);
      } else {
        yield QRUnlockedState(user);
      }
    } else if (event is QRLockToggle) {
      yield QRLoadingState(user);
      final isLocked = await toggle(NoParams());
      yield* isLocked.fold((failure) async* {
        yield QRUnlockFailedState(user, message: failure.message);
      }, (locked) async* {
        user.isLocked = locked;
        if (locked) {
          //canceller?.cancel();
          yield QRLockedState(user);
        } else {
          yield QRUnlockedState(user);
          //canceller = Canceller();
          getScan(NoParams() /*GetScanParams(canceller)*/)
              .then((scanOrFailure) async* {
            yield* scanOrFailure.fold((failure) async* {
              if (failure is NoScanFailure) {
                yield QRNoScanState(user);
              } else {
                yield QRLoadScanFailedState(user, message: failure.message);
              }
            }, (thread) async* {
              yield QRScannedState(user, thread: thread);
            });
          });
        }
      });
    } else if (event is ScanConfirmed) {
      final confirmation =
          await confirmScan(ConfirmScanParams(thread: event.thread));
      yield* confirmation.fold((failure) async* {
        QRConfirmEntryFailedState(user, message: failure.message);
      }, (result) async* {
        user.isLocked = true;
        yield QREntryConfirmedState(user);
      });
    }
  }

  @override
  QRState get initialState => QRLoadingState(user);

  checkForScan() async {
    while (state is QRLoadingState) {
      await Future.delayed(const Duration(seconds: 1), () => "1");
    }
    if (state is QRUnlockedState) {
      while (state is QRUnlockedState) {
        await Future.delayed(const Duration(seconds: 1), () => "1");
        if (state is QRUnlockedState) {
          this.add(QRCheckScan());
        }
      }
    }
  }

  @override
  Stream<QRState> mapEventToState(QRPageEvent event) async* {
    print(event);
    if (event is QRPageCreated) {
      if (user.isLocked) {
        yield QRLockedState(user);
      } else {
        yield QRUnlockedState(user);
        checkForScan();
      }
    } else if (event is QRLockToggle) {
      yield QRLoadingState(user);
      final isLocked = await toggle(NoParams());
      yield* isLocked.fold((failure) async* {
        yield QRUnlockFailedState(user, message: failure.message);
      }, (locked) async* {
        user.isLocked = locked;
        if (locked) {
          yield QRLockedState(user);
        } else {
          yield QRUnlockedState(user);
          checkForScan();
        }
      });
    } else if (event is ScanConfirmed) {
      final confirmation =
          await confirmScan(ConfirmScanParams(thread: event.thread));
      yield* confirmation.fold((failure) async* {
        QRConfirmEntryFailedState(user, message: failure.message);
      }, (result) async* {
        user.isLocked = true;
        yield QREntryConfirmedState(user);
      });
    } else if (event is QRCheckScan) {
      final result = await getScan(NoParams());
      yield* result.fold((failure) async* {
        if (!(failure is NoScanFailure)) {
          yield QRLoadScanFailedState(user, message: failure.message);
        }
      }, (thread) async* {
        yield QRScannedState(user, thread: thread);
      });
    }
  }
}
