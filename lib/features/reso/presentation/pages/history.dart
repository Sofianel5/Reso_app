import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/models/timeslot_model.dart';
import 'package:tracery_app/models/vp_handshake_model.dart';
import 'package:intl/intl.dart';
import 'package:tracery_app/widgets/reservation_card.dart';
import 'package:tracery_app/widgets/timeslot_card.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<TimeSlot> history;
  List<TimeSlot> current;
  _fetchRegistrations(UserRepository user) async {
    Map<String, dynamic> result = await user.getRegistrations();
    if (result == null) {
      return;
    }
    if (mounted) {
      setState(() {
        history = result['history'];
        current = result['current'];
      });
    }
  }

  Widget _buildList(BuildContext context, List<TimeSlot> list) {
    final userRepo = Provider.of<UserRepository>(context);
    if (current == null || history == null) {
      _fetchRegistrations(userRepo);
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        TimeSlot ts = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ReservationCard(
              venue: ts.venue, timeslot: ts, userRepo: userRepo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 70,
        ),
        Text(
          "Your Registrations",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Text(
                "Current",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
            child: _buildList(context, current)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: _buildList(context, history)),
      ],
    );
  }
}
