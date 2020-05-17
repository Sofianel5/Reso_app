part of '../root_bloc.dart';

class QRPageBlocRouter {
  ToggleLock toggle;
  GetScan getScan;
  ConfirmScan confirmScan;
  QRPageBlocRouter({@required this.toggle, @required this.getScan, @required this.confirmScan});
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
          yield QRLockedState(user);
        } else {
          yield QRUnlockedState(user);
          final scanOrFailure = await getScan(NoParams());
          yield* scanOrFailure.fold((failure) async* {
            if (failure is NoScanFailure) {
              yield QRNoScanState(user);
            } else {
              yield QRLoadScanFailedState(user, message: failure.message);
            }
          }, (thread) async* {
            yield QRScannedState(user, thread: thread);
          }); 
        }
      });
    } else if (event is ScanConfirmed) {
      final confirmation = await confirmScan(ConfirmScanParams(thread: event.thread));
      yield* confirmation.fold((failure) async* {
        QRConfirmEntryFailedState(user, message: failure.message);
      }, (result) async* {
        user.isLocked = true;
        yield QREntryConfirmedState(user);
      });
    }
  }
}
