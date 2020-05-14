import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Widget _buildEmailField() {
    return TextField(
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _email,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(passwordNode);
      },
      onSubmitted: (value) {
        if (value != null && value != "") {
          FocusScope.of(context).requestFocus(passwordNode);
        }
        setState((){});
      },
      onTap: () => setState((){}),
      focusNode: emailNode,
      decoration: InputDecoration(
          focusColor: Colors.black,
          hintText: Localizer.of(context).get("email"),
          prefixIcon: Icon(Icons.email),),
      textInputAction: TextInputAction.continueAction,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _password,
      onTap: () => setState((){}),
      onSubmitted: (value) {setState((){});},
      focusNode: passwordNode,
      obscureText: true,
      decoration: InputDecoration(
          focusColor: Theme.of(context).accentColor,
          hintText: Localizer.of(context).get("password"),
          prefixIcon: Icon(
              passwordNode.hasFocus ? Icons.lock_open : Icons.lock_outline)),
    );
  }

  Widget _buildSubmitButton(RootBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: bloc.state is LoadingState
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
      onPressed: () => {},
      child: Text(
        Localizer.of(context).get("sign-up") ?? "Sign up",
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      child: FlatButton(
        onPressed: () => {},
        child: Text(
            Localizer.of(context).get("forgot-password") ?? "Forgot password?"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RootBloc>(context);
    return Scaffold(
      key: _key,
      body: Stack(
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
                    emailNode.hasFocus || passwordNode.hasFocus ? Container() :
                    Image(
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
                    _buildEmailField(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildPasswordField(),
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
    );
  }
}
