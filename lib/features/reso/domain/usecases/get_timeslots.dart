import 'package:Reso/features/reso/domain/entities/timeslot.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class GetTimeSlots extends UseCase<List<TimeSlot>, GetTimeSlotsParams> {
  final RootRepository repository;
  GetTimeSlots(this.repository);

  @override 
  Future<Either<Failure,List<TimeSlot>>> call(GetTimeSlotsParams params) async {
    return await repository.getTimeSlots(params.venue);
  }
}

class GetTimeSlotsParams extends Params {
  final Venue venue;
  GetTimeSlotsParams({@required this.venue});

  @override
  List<Object> get props => [venue];
  
}