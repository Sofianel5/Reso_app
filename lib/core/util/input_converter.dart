import 'package:Reso/core/errors/failures.dart';
import 'package:Reso/core/localizations/messages.dart';
import 'package:dartz/dartz.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

class InputConverter {
  Either<Failure, String> parseName(String input) {
    if (isNull(input)) {
      return Left(InvalidInputFailure(message: Messages.NULL_NAME_INPUT));
    }
    if (isAlpha(input)) {
      if (isLength(input, 2, 99)) {
        return Right(trim(input));
      } else {
        return Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_NAME_INPUT));
      }
    } else {
      final shortened = whitelist(
          input, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
      if (isLength(shortened, 2, 99)) {
        return Right(shortened);
      } else {
        return Left(InvalidInputFailure(message: Messages.INVALID_NAME_INPUT));
      }
    }
  }

  Either<Failure, String> parseEmail(String input) {
    if (isNull(input)) {
      return Left(InvalidInputFailure(message: Messages.NULL_EMAIL_INPUT));
    }
    var email = trim(input);
    if (isEmail(email)) {
      if (isLength(email, 5, 149)) {
        return Right(normalizeEmail(email));
      } else {
        return Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_EMAIL));
      }
    } else {
      return Left(InvalidInputFailure(message: Messages.INVALID_EMAIL_INPUT));
    }
  }

  Either<Failure, String> parsePassword(String input) {
    if (isNull(input)) {
      return Left(InvalidInputFailure(message: Messages.NULL_PASSWORD_INPUT));
    }
    if (isLength(input, 8, 150)) {
      return Right(input);
    }
    return Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_PASSWORD_INPUT));
  }

  Map<String, String> validateLoginForm(String email, String password) {
    final emailMessage = parseEmail(email);
    final passwordMessage = parsePassword(password);
    final Map<String, String> messages = Map<String, String>.from({});
    emailMessage.fold((failure) => {
      messages["email"] = failure.message
    }, (r) => {});
    passwordMessage.fold((failure) => {
      messages["password"] = failure.message
    }, (r) => {});
    return messages;
  }
  Either<Failure, String> validateSearchQuery(String query) {
    if (isNull(query)) {
      return Left(InvalidInputFailure(message: Messages.EMPTY_SEARCH_Q));
    } else {
      return Right(query);
    }
  }
}
