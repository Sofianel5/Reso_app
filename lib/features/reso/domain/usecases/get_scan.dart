import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/thread.dart';
import '../repositories/root_repository.dart';

class GetScan extends UseCase<Thread, GetScanParams> {
  final RootRepository repository;
  GetScan(this.repository);

  @override 
  Future<Either<Failure, Thread>> call(GetScanParams params) async {
    int counter = 0;
    while (counter < 600 && !params.canceller.isCancelled) {
      print(counter);
      final result = await repository.checkForScan();
      print(result);
      var thingToReturn;
      result.fold((failure) {
        if (failure is ConnectionFailure) {
          thingToReturn = failure;
        } else if (failure is AuthenticationFailure) {
          thingToReturn = failure;
        }
      }, (thread) {
        thingToReturn = thread;
      });
      if (thingToReturn != null) {
        if (thingToReturn is Failure) {
          return Left(thingToReturn);
        } else if (thingToReturn is Thread) {
          return Right(thingToReturn);
        }
      }
      counter++;
    }
    return Left(NoScanFailure());
  }
}

class GetScanParams extends Params {
  Canceller canceller;
  GetScanParams(this.canceller);

  @override
  List<Object> get props => [canceller];
  
}
class Canceller {
  bool isCancelled = false;
  void cancel() {
    isCancelled = true;
  }
}