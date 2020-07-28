import 'package:Reso/features/reso/domain/entities/timeslot.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class GetListings extends UseCase<List<VenueDetail>, GetListingsParams> {
  final RootRepository repository;
  GetListings(this.repository);

  @override 
  Future<Either<Failure,List<VenueDetail>>> call(GetListingsParams params) async {
    return await repository.getListings(params.id);
  }
}

class GetListingsParams extends Params {
  final int id;
  GetListingsParams({@required this.id});

  @override
  List<Object> get props => [id];
  
}