import 'package:equatable/equatable.dart';
import 'package:Reso/features/reso/domain/entities/address.dart';
import 'package:Reso/features/reso/domain/entities/coordinates.dart';

class User extends Equatable{
  final int id;
  final String email;
  String publicId;
  final DateTime dateJoined;
  final String firstName;
  final String lastName;
  bool isLocked;
  Coordinates coordinates;
  Address address;

  User({
    this.id,  
    this.email,
    this.publicId,
    this.dateJoined,
    this.firstName,
    this.lastName,
    this.coordinates,
    this.address,
    this.isLocked,
  });

  @override
  List<Object> get props => [id];

  @override 
  String toString() {
    return this.firstName + " " + this.lastName;
  }

}