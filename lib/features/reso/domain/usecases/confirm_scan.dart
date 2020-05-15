import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/thread.dart';
import '../repositories/root_repository.dart';

class ConfirmScan extends UseCase<bool, ConfirmScanParams> {
  final RootRepository repository;
  ConfirmScan(this.repository);

  @override 
  Future<Either<Failure, bool>> call(ConfirmScanParams params) async {
    return await repository.confirmScan(params.thread);
  }
}

class ConfirmScanParams extends Params {
  final Thread thread;
  ConfirmScanParams({@required this.thread}) : assert(thread != null);
  @override
  List<Object> get props => [id];
}