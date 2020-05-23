import 'package:Reso/core/errors/failures.dart';
import 'package:Reso/core/localizations/messages.dart';
import 'package:Reso/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group("parseName", () {
    test('should return the string when only alphabetic chars are used', () {
      // arrange
      final str = "Sofiane";
      // act
      final result = inputConverter.parseName(str);
      // assert
      expect(result, Right(str));
    });
    test('should remove numbers when they are included in the name', () {
      // arrange
      final str = "Sofiane2721";
      // act
      final result = inputConverter.parseName(str);
      // assert
      expect(result, Right("Sofiane"));
    });
    test('should remove whitespace when it is included in the name', () {
      // arrange
      final str = "Sofiane     ";
      // act
      final result = inputConverter.parseName(str);
      // assert
      expect(result, Right("Sofiane"));
    });
    test('should fail when no alphabetic character are provided', () {
      // arrange
      final str = "214596983";
      // act
      final result = inputConverter.parseName(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.INVALID_NAME_INPUT)));
    });
    test('should fail when too long', () {
      // arrange
      final str = """ username = None 
                  email = models.EmailField(verbose_name=_("Email"), max_length=150, unique=True)
                  public_id = models.UUIDField(unique=True, default=uuid.uuid4)
                  date_joined = models.DateTimeField(verbose_name=_("date joined"), auto_now_add=True)
                  first_name = models.CharField(verbose_name=_("First name"), max_length=100)
                  last_name = models.CharField(verbose_name=_("Last name"), max_length=100)
                  coordinates = models.ForeignKey(Coordinates, on_delete=models.DO_NOTHING, blank=True, null=True)
                  address = models.ForeignKey(Address, on_delete=models.DO_NOTHING, blank=True, null=True)
                  is_staff = models.BooleanField(default=False)
                  is_admin = models.BooleanField(default=False)
                  is_active = models.BooleanField(default=True)
                  last_login = models.DateTimeField(verbose_name=_("Last login"), auto_now=True)
                  is_locked = models.BooleanField(default=True)
                  objects = AccountManager()
                  """;
      // act
      final result = inputConverter.parseName(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_NAME_INPUT)));
    });
    test("should reject null", () {
      // arrange
      final str = null;
      // act
      final result = inputConverter.parseName(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.NULL_NAME_INPUT)));
    });
  });
  group("parseEmail", () {
    test('should remove whitespace', () {
      // arrange
      final str = "    Sofiane@gmail.com     ";
      // act
      final result = inputConverter.parseEmail(str);
      // assert
      expect(result, Right("sofiane@gmail.com"));
    });
    test("should reject null", () {
      // arrange
      final str = null;
      // act
      final result = inputConverter.parseEmail(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.NULL_EMAIL_INPUT)));
    });
  });

  group("parsePassword", () {
    test('should reject small passwords', () {
      // arrange
      final str = "12";
      // act
      final result = inputConverter.parsePassword(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_PASSWORD_INPUT)));
    });
    test('should reject giant passwords', () {
      // arrange
      final str = """ username = None 
                  email = models.EmailField(verbose_name=_("Email"), max_length=150, unique=True)
                  public_id = models.UUIDField(unique=True, default=uuid.uuid4)
                  date_joined = models.DateTimeField(verbose_name=_("date joined"), auto_now_add=True)
                  first_name = models.CharField(verbose_name=_("First name"), max_length=100)
                  last_name = models.CharField(verbose_name=_("Last name"), max_length=100)
                  coordinates = models.ForeignKey(Coordinates, on_delete=models.DO_NOTHING, blank=True, null=True)
                  address = models.ForeignKey(Address, on_delete=models.DO_NOTHING, blank=True, null=True)
                  is_staff = models.BooleanField(default=False)
                  is_admin = models.BooleanField(default=False)
                  is_active = models.BooleanField(default=True)
                  last_login = models.DateTimeField(verbose_name=_("Last login"), auto_now=True)
                  is_locked = models.BooleanField(default=True)
                  objects = AccountManager()
                  """;
      // act
      final result = inputConverter.parsePassword(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_PASSWORD_INPUT)));
    });
    test('should allow normal passwords', () {
      // arrange
      final str = "abcdefghiFEF32";
      // act
      final result = inputConverter.parsePassword(str);
      // assert
      expect(result, Right(str));
    });
    test("should reject null", () {
      // arrange
      final str = null;
      // act
      final result = inputConverter.parsePassword(str);
      // assert
      expect(result, Left(InvalidInputFailure(message: Messages.NULL_EMAIL_INPUT)));
    });
  });
  group("validateLoginForm", () {
    test("should return [Failure] if email is empty string", () {
      // arrange
      final email = "";
      final password = "bruh123687";
      // act 
      final result = inputConverter.validateLoginForm(email, password);
      // assert
      expect(result, {"email": Messages.NULL_EMAIL_INPUT});
    });
  });
}
