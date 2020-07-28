import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localizations/localizations.dart';
import '../../domain/entities/timeslot.dart';
import '../../domain/entities/venue.dart';
import '../bloc/root_bloc.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({@required this.venue, @required this.timeSlot});
  Venue venue;
  TimeSlot timeSlot;

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override 
  void didChangeDependencies() {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        if (deepLink != null) {
          if (deepLink.queryParameters.containsKey('user')) {
            BlocProvider.of<RootBloc>(context).add(PushListings(int.parse(deepLink.queryParameters["user"])));
          } else if (deepLink.queryParameters.containsKey('venue')) {
            BlocProvider.of<RootBloc>(context).add(PushVenue(Venue.getLoadingPlaceholder(int.parse(deepLink.queryParameters["venue"]))));
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocProvider(
      create: (context) => RegisterPageBloc(
          canRegister: rootBloc.canRegister,
          venue: widget.venue,
          timeslot: widget.timeSlot,
          register: rootBloc.register),
      child: RegisterBloc(
        venue: widget.venue,
        timeSlot: widget.timeSlot,
      ),
    );
  }
}

class RegisterBloc extends StatefulWidget {
  const RegisterBloc({
    Key key,
    this.venue,
    this.timeSlot,
  }) : super(key: key);
  final Venue venue;
  final TimeSlot timeSlot;
  @override
  _RegisterBlocState createState() => _RegisterBlocState();
}

class _RegisterBlocState extends State<RegisterBloc> {
  bool alreadyPopped = false;
  Map<String, bool> data = <String, bool>{"mask": false, "form": false};

  String _allowedText() {
    String str = (Localizer.of(context).get("pass-for") +
            Localizer.of(context).get(widget.timeSlot.type)) +
        (widget.timeSlot.type == "All"
            ? (" " + Localizer.of(context).get("customers"))
            : "");
    print(str);
    return str;
  }

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
                title: Text(
                  Localizer.of(context).get(
                    state is RegisteredSuccessfullyState ? "Success" : "Failed",
                  ),
                  style: TextStyle(
                      color: state is RegisteredSuccessfullyState
                          ? Colors.greenAccent[700]
                          : Color(0xFFdd2c00)),
                ),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(
                        Localizer.of(context).get(
                          state is RegisterFailedState
                              ? Localizer.of(context).get(state.message)
                              : Localizer.of(context).get("Success"),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      Localizer.of(context).get(
                        "Dismiss",
                      ),
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
                      Container(width: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _allowedText(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                DateFormat("EEEEE, M/d/y ")
                                        .format(widget.timeSlot.start) +
                                    DateFormat("jm")
                                        .format(widget.timeSlot.start),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 30),
                              Text(
                                Localizer.of(context).get("to"),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 30),
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
                        Spacer(),
                        if (widget.venue.maskRequired)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: CheckboxListTile(
                              title: Text(
                                  Localizer.of(context).get("agree-mask"),
                                  style: TextStyle(fontSize: 17)),
                              value: data["mask"],
                              onChanged: (b) => setState(() {
                                data["mask"] = b;
                              }),
                            ),
                          ),
                        if (widget.venue.requiresForm)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: CheckboxListTile(
                              title: Text(
                                  Localizer.of(context).get("agree-form"),
                                  style: TextStyle(fontSize: 17)),
                              value: data["form"],
                              onChanged: (b) => setState(() {
                                data["form"] = b;
                              }),
                            ),
                          ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if (state is CanRegisterState) {
                                BlocProvider.of<RegisterPageBloc>(context).add(
                                  AttemptRegister(
                                      timeSlot: widget.timeSlot,
                                      venue: widget.venue,
                                      data: data),
                                );
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
                                    Localizer.of(context).get(
                                      "Register",
                                    ),
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
