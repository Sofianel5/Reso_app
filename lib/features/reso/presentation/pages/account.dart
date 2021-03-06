import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/core/network/urls.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
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
  void _showLogoutDialog(RootBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(Localizer.of(context).get("logout-warning1")),
          content: Text(Localizer.of(context).get("logout-warning2")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(Localizer.of(context).get("Cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                Localizer.of(context).get('logout'),
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                bloc.add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL() async {
    var url = Urls.PASSWORD_RESET_URL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      child: FlatButton(
        onPressed: () =>
            _launchURL(), 
        child: Text(Localizer.of(context).get("forgot-password") ?? "Forgot password?"),
      ),
    );
  }

  _buildLogoutWidget(RootBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _showLogoutDialog(bloc),
          child: Text(
            //! LOCALIZE
            Localizer.of(context).get('logout'),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<AccountPageBloc>(context),
        listener: (context, state) {},
      child: BlocBuilder(
    bloc: BlocProvider.of<AccountPageBloc>(context),
        builder: (context, state) => SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 700,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -10),
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    color: Color(0xFFF3F5F7),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                        ),
                        Text(
                          Localizer.of(context)
                                  .get("your-account") ??
                              "Your account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          state.user.firstName +
                              " " +
                              state.user.lastName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 24),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _buildLogoutWidget(rootBloc),
                        SizedBox(height: 30,),
                        _buildForgotPasswordBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(children: [
                  Center(
                    child: Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(105),
                          color: Color(0xFFF3F5F7)),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        state.user.firstName.substring(0, 1) +
                            state.user.lastName.substring(0, 1),
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ]),
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
