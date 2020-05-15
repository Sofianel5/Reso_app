import 'package:Reso/features/reso/domain/entities/timeslot.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/thread.dart';
import '../entities/user.dart';
import '../entities/venue.dart';

abstract class RootRepository {
  Future<Either<Failure, User>> login({String email, String password});
  Future<Either<Failure, User>> signUp({String email, String password, String firstName, String lastName});
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, VenueDetail>> getVenue({int pk});
  Future<Either<Failure, List<Venue>>> getVenues({String search});
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, bool>> toggleLockState();
  Future<Either<Failure, bool>> confirmScan(Thread thread);
  Future<Either<Failure, Thread>> checkForScan();
  Future<Either<Failure, bool>> register(TimeSlot timeSlot);
}