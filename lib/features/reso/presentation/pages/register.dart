import '../bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/timeslot.dart';
import '../../domain/entities/venue.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({@required this.venue,@required this.timeSlot});
  Venue venue;
  TimeSlot timeSlot;

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocProvider(
      create: (context) => RegisterPageBloc(
          canRegister: rootBloc.canRegister,
          venue: widget.venue,
          timeslot: widget.timeSlot,
          register: rootBloc.register),
      child: RegisterBloc(venue: widget.venue, timeSlot: widget.timeSlot,),
    );
  }
}

class RegisterBloc extends StatefulWidget {
  const RegisterBloc({
    Key key, this.venue, this.timeSlot,}) : super(key: key);
  final Venue venue;
  final TimeSlot timeSlot;
  @override
  _RegisterBlocState createState() => _RegisterBlocState();
}

class _RegisterBlocState extends State<RegisterBloc> {
  bool alreadyPopped = false;

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<RegisterPageBloc>(context),
      listener: (context, state) {
        if (state is RegisterFailedState ||
            state is RegisteredSuccessfullyState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(state is RegisteredSuccessfullyState
                    ? "Success"
                    : "Failed", style: TextStyle(color: state is RegisteredSuccessfullyState ? Colors.greenAccent[700] : Color(0xFFdd2c00)),),
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
        bloc: BlocProvider.of<RegisterPageBloc>(context),
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
                            rootBloc.add(PopEvent());
                            alreadyPopped = true;
                          }
                        },
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30,
                          color: Colors.black,
                          onPressed: () {
                            if (!alreadyPopped) {
                              rootBloc.add(PopEvent());
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "to",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                DateFormat("EEEEE, M/d/y ")
                                        .format(widget.timeSlot.stop) +
                                    DateFormat("jm")
                                        .format(widget.timeSlot.stop),
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if (state is CanRegisterState) {
                                BlocProvider.of<RegisterPageBloc>(context)
                                    .add(AttemptRegister(
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
 
