import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class GetVenues extends UseCase<List<Venue>, NoParams> {
  final RootRepository repository;
  GetVenues(this.repository);

  @override 
  Future<Either<Failure, List<Venue>>> call(NoParams params) async {
    return await repository.getVenues();
  }
}