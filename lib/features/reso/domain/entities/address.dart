import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Address extends Equatable {
  final String address_1;
  final String address_2;
  final String postCode;
  final String city;
  final String state;
  final int id;
  Address({
    @required this.address_1,
    @required this.id,
    this.address_2,
    this.postCode,
    @required this.city,
    this.state,
  });
  @override
  List<Object> get props => [address_1, address_2, postCode, city, state, id];
}
