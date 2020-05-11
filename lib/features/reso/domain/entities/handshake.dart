import 'package:equatable/equatable.dart';

import 'user.dart';
import 'venue.dart';

class Handshake extends Equatable {
  final Venue venue;
  final User user;
  final int id;
  final DateTime time;
  Handshake({this.venue, this.time, this.user, this.id});

  @override
  List<Object> get props => [venue, user, time, id];
}
