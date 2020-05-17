import 'package:Reso/features/reso/domain/entities/timeslot.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class GetRegistrations extends UseCase<Map<String, List<TimeSlotDetail>>, NoParams> {
  final RootRepository repository;
  GetRegistrations(this.repository);

  @override 
  Future<Either<Failure, Map<String, List<TimeSlotDetail>>>> call(NoParams params) async {
    return await repository.getRegistrations();
  }
}