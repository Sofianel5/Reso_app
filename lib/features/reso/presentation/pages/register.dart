import '../bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/timeslot.dart';
import '../../domain/entities/venue.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({this.venue, this.timeSlot});
  Venue venue;
  TimeSlot timeSlot;

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool alreadyPopped = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RootBloc bloc = BlocProvider.of<RootBloc>(context);
    bloc.add(RegisterPageOpened(timeSlot: widget.timeSlot, venue: widget.venue));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if (state is RegisterFailedState ||
            state is RegisteredSuccessfullyState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(state is RegisteredSuccessfullyState
                    ? "Success"
                    : "Failed"),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(state is RegisteredSuccessfullyState
                          ? "You have successfully registered for this timeslot"
                          : "Try again later."),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      "Dismiss",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) => Scaffold(
          backgroundColor: Color(0xFFF3F5F7),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!alreadyPopped) {
                            bloc.add(RegisterPopEvent(venue: widget.venue));
                            alreadyPopped = true;
                          }
                        },
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30,
                          color: Colors.black,
                          onPressed: () {
                          if (!alreadyPopped) {
                            bloc.add(RegisterPopEvent(venue: widget.venue));
                            alreadyPopped = true;
                          }
                        },
                        ),
                      ),
                      Text(widget.venue.title),
                      Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Container(
                    height: 650,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pass for",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              Text(
                                DateFormat("EEEEE, M/d/y ")
                                        .format(widget.timeSlot.start) +
                                    DateFormat("jm")
                                        .format(widget.timeSlot.start),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "to",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                DateFormat("EEEEE, M/d/y ")
                                        .format(widget.timeSlot.stop) +
                                    DateFormat("jm")
                                        .format(widget.timeSlot.stop),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if (state is CanRegisterState) {
                                bloc.add(AttemptRegister(
                                    timeSlot: widget.timeSlot,
                                    venue: widget.venue));
                              }
                            },
                            elevation: 5,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: !(state is CanRegisterState)
                                ? Colors.grey
                                : Theme.of(context).accentColor,
                            child: (state is InfoLoadingState)
                                ? CircularProgressIndicator()
                                : Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
