import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class GetVenueDetail extends UseCase<VenueDetail, GetVenueDetailParams> {
  final RootRepository repository;
  GetVenueDetail(this.repository);

  @override 
  Future<Either<Failure, VenueDetail>> call(GetVenueDetailParams params) async {
    return await repository.getVenue(pk: params.venue.id);
  }
}

class GetVenueDetailParams extends Params {
  final Venue venue;
  GetVenueDetailParams({@required this.venue}) : assert(venue != null);

  @override
  List<Object> get props => [venue];
  
}