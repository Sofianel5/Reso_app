import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/user.dart';
import 'address_model.dart';
import 'coordinates_model.dart';
import 'model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class UserModel extends User implements Model {
  final CoordinatesModel coordinates;
  final AddressModel address;
  UserModel({
    @required int id,
    String email,
    String publicId,
    DateTime dateJoined,
    @required String firstName,
    @required String lastName,
    bool isLocked,
    this.coordinates,
    this.address,
  }) : super(
          id: id,
          email: email,
          publicId: publicId,
          dateJoined: dateJoined,
          firstName: firstName,
          lastName: lastName,
          isLocked: isLocked,
          address: address,
          coordinates: coordinates,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
