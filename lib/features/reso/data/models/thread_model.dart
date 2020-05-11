import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/thread.dart';
import 'model.dart';
import 'user_model.dart';
import 'venue_model.dart';

part 'thread_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ThreadModel extends Thread implements Model {
  final VenueModel venue;
  final UserModel user;
  ThreadModel({
    @required int id,
    this.venue,
    this.user,
    bool fromConfirmed,
    bool toConfirmed,
    DateTime time,
    String threadId,
  }) : super(
          threadId: threadId,
          venue: venue,
          user: user,
          time: time,
          id: id,
          fromConfirmed: fromConfirmed,
          toConfirmed: toConfirmed,
        );

  factory ThreadModel.fromJson(Map<String, dynamic> json) =>
      _$ThreadModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);
}
