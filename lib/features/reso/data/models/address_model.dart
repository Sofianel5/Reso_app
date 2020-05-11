import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/address.dart';
import 'model.dart';

part 'address_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AddressModel extends Address implements Model {
  AddressModel({
    @required int id,
    String address_1,
    String address_2,
    String postCode,
    String city,
    String state,
  }) : super(
          id: id,
          address_1: address_1,
          address_2: address_2,
          postCode: postCode,
          city: city,
          state: state,
        );
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
