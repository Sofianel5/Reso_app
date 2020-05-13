import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class GetSessions extends UseCase<Map<String, dynamic>, NoParams> {
  final RootRepository repository;
  GetSessions(this.repository);

  @override 
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.getSession();
  }
}
