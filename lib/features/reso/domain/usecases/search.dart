import 'package:Reso/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class Search extends UseCase<List<Venue>, SearchParams> {
  final RootRepository repository;
  Search(this.repository);

  @override
  Future<Either<Failure, List<Venue>>> call(SearchParams params) async {
    final inputValidator = InputConverter();
    final invalidInput = inputValidator.validateSearchQuery(params.query);
    return invalidInput.fold((failure) {
      return Left(failure);
    }, (query) async {
      return await repository.getVenues(search: query);
    });
  }
}

class SearchParams extends Params {
  final String query;
  SearchParams({@required this.query});
  @override
  List<Object> get props => [query];
}
