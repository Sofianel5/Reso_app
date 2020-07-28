import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/core/network/urls.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override 
  void didChangeDependencies() {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        if (deepLink != null) {
          BlocProvider.of<RootBloc>(context).add(ChangeLaunchDataEvent(deepLink.queryParameters));
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    super.didChangeDependencies();
  }
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  TextEditingController _password = TextEditingController();
  String focusedNode = "email";
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Widget _buildEmailField(RootBloc bloc) {
    RootState state = bloc.state;
    var errorWidget;
    if (state is LoginFailedState) {
      if (state.hasError("email")) {
        errorWidget = Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Localizer.of(context).get(state.widgetMessages["email"]) ??
                    state.widgetMessages["email"],
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFdd2c00),
                ),
              ),
            ],
          ),
        );
      } else {
        errorWidget = Container(height: 10);
      }
    } else {
      errorWidget = Container(height: 10);
    }
    return Column(
      children: [
        TextField(
          style: TextStyle(color: Colors.black87),
          cursorColor: Theme.of(context).accentColor,
          controller: _email,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(passwordNode);
          },
          onSubmitted: (value) {
            if (value != null && value != "") {
              FocusScope.of(context).requestFocus(passwordNode);
            }
            setState(() {});
          },
          onTap: () => setState(() {}),
          focusNode: emailNode,
          decoration: InputDecoration(
            focusColor: Colors.black,
            hintText: Localizer.of(context).get("email"),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        errorWidget
      ],
    );
  }

  Widget _buildPasswordField(RootBloc bloc) {
    RootState state = bloc.state;
    var errorWidget;
    if (state is LoginFailedState) {
      if (state.hasError("password")) {
        errorWidget = Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Localizer.of(context).get(state.widgetMessages["password"]) ??
                    state.widgetMessages["password"],
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFdd2c00),
                ),
              ),
            ],
          ),
        );
      } else {
        errorWidget = Container(height: 10);
      }
    } else {
      errorWidget = Container(height: 10);
    }
    return Column(
      children: [
        TextField(
          style: TextStyle(color: Colors.black87),
          cursorColor: Theme.of(context).accentColor,
          controller: _password,
          onTap: () => setState(() {}),
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
            setState(() {
              bloc.add(
              LoginAttemptEvent(email: _email.text, password: _password.text));
            });
          },
          focusNode: passwordNode,
          obscureText: true,
          decoration: InputDecoration(
            focusColor: Theme.of(context).accentColor,
            hintText: Localizer.of(context).get("password") ?? "Password",
            prefixIcon: Icon(
                passwordNode.hasFocus ? Icons.lock_open : Icons.lock_outline),
          ),
        ),
        errorWidget
      ],
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

  Widget _buildSubmitButton(RootBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          bloc.add(
              LoginAttemptEvent(email: _email.text, password: _password.text));
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: bloc.state is LoginLoadingState
                  ? CircularProgressIndicator()
                  : Text(
                      Localizer.of(context).get("submit") ?? "Submit",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )),
      ),
    );
  }

  Widget _buildSignUpBtn(RootBloc bloc) {
    return FlatButton(
      onPressed: () => bloc.add(RequestSignup()),
      child: Text(
        Localizer.of(context).get("sign-up") ?? "Sign up",
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Theme.of(context).accentColor, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RootBloc>(context);

    return BlocListener<RootBloc, RootState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is LoginFailedState) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.globalMessage))));
        }
        // DO navigation if other events
      },
      child: BlocBuilder<RootBloc, RootState>(
        bloc: bloc,
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.white,
          key: _key,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
                      child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).bottomAppBarColor,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          emailNode.hasFocus || passwordNode.hasFocus
                              ? Container()
                              : Image(
                                  height: 75,
                                  width: 75,
                                  image: AssetImage("assets/tracery1.png"),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 40),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  Localizer.of(context).get("welcome") ??
                                      "Welcome to Reso",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Localizer.of(context).get("sign-in") ??
                                      "Sign in",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          _buildEmailField(bloc),
                          SizedBox(
                            height: 30,
                          ),
                          _buildPasswordField(bloc),
                          SizedBox(
                            height: 50,
                          ),
                          _buildSubmitButton(bloc),
                          SizedBox(
                            height: 50,
                          ),
                          _buildSignUpBtn(bloc),
                          SizedBox(
                            height: 20,
                          ),
                          _buildForgotPasswordBtn(),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
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
