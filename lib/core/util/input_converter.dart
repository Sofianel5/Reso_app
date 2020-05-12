import 'package:Reso/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

class InputConverter {
  Either<Failure, String> parseName(String input) {
    if (isNull(input)) {
      return Left(InvalidInputFailure(messageCode: "null"));
    }
    if (isAlpha(input)) {
      if (isLength(input, 2, 99)) {
        return Right(trim(input));
      } else {
        return Left(InvalidInputFailure(messageCode: "name_too_long"));
      }
    } else {
      final shortened = whitelist(
          input, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
      if (isLength(shortened, 2, 99)) {
        return Right(shortened);
      } else {
        return Left(InvalidInputFailure(messageCode: "invalid_name"));
      }
    }
  }

  Either<Failure, String> parseEmail(String input) {
    var email = trim(input);
    if (isEmail(email)) {
      if (isLength(email, 5, 149)) {
        return Right(normalizeEmail(email));
      } else {
        return Left(InvalidInputFailure(messageCode: "email_too_long"));
      }
    } else {
      return Left(InvalidInputFailure(messageCode: "invalid_email"));
    }
  }

  Either<Failure, String> parsePassword(String input) {
    if (isLength(input, 8, 150)) {
      return Right(input);
    }
    return Left(InvalidInputFailure(messageCode: "wrong_size_password"));
  }
}
