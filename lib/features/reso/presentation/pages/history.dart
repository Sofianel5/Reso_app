import 'package:Reso/core/localizations/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/timeslot.dart';
import '../bloc/root_bloc.dart';
import '../widgets/reservation_card.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {

  Widget _buildList(BuildContext context, List<TimeSlot> list) {
    return Container(
      height: MediaQuery.of(context).size.height-270,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          TimeSlot ts = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ReservationCard(timeslot: ts),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
        bloc: BlocProvider.of<RegistrationsPageBloc>(context),
        listener: (context, state) {
    if (state is RegistrationsLoadFailure) {
      //! Localize
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
    }
        },
        child: BlocBuilder(
    bloc: BlocProvider.of<RegistrationsPageBloc>(context),
    builder: (content, state) => Column(
      children: <Widget>[
        SizedBox(
          height: 70,
        ),
        Text(
          "Your Registrations",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        buildSwitchButtonRow(state, BlocProvider.of<RegistrationsPageBloc>(context), context),
        SizedBox(
          height: 20,
        ),
        buildContents(state),
      ],
    ),
        ),
      );
  }

  Widget buildContents(RegistrationsState state) {
    if (state is RegistrationsLoaded) {
      if (state is NoCurrentRegistrations || state is NoPreviousRegistrations) {
        return Center(
          child: Text(
            Localizer.of(context).get(state is NoCurrentRegistrations
                ? "NoCurrentRegistrations"
                : "NoPreviousRegistrations"),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
          child: _buildList(context, state.timeSlots),
        );
      }
    } else if (state is RegistrationsLoadingState) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state is RegistrationsLoadFailure) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
        child: Center(child: Text(Localizer.of(context).get("failed") + ": " + Localizer.of(context).get(state.message))),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
        child: Center(child: Text(Localizer.of(context).get("failed"))),
      );
    }
  }

  Row buildSwitchButtonRow(state, RegistrationsPageBloc bloc, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            if (state is RegistrationsHistoryState) {
              bloc.add(RegistrationsPageRequestCurrent());
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Text(
                "Current",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 3,
                    color: state is RegistrationsHistoryState
                        ? Color(0xFFF3F5F7)
                        : Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (state is RegistrationsCurrentState) {
              bloc.add(RegistrationsPageRequestHistory());
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 3,
                  color: state is RegistrationsHistoryState
                      ? Theme.of(context).accentColor
                      : Color(0xFFF3F5F7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
