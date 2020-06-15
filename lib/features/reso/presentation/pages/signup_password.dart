import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations/localizations.dart';
import '../bloc/root_bloc.dart';

class SignUpPasswordScreen extends StatefulWidget {
  SignUpPasswordScreen();
  @override
  _SignUpPasswordScreenState createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _password = TextEditingController(text: "");
  }

  Widget _buildNextButton(RootBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          bloc.add(PasswordPageSubmitted(_password.text));
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: bloc.state is SignupLoading
                  ? CircularProgressIndicator()
                  : Text(
                      Localizer.of(context).get("submit"),
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

  Widget _buildBackBtn() {
    return Container(
      child: FlatButton(
        splashColor: Colors.black12,
        onPressed: () => Navigator.pop(context),
        child: Text(Localizer.of(context).get("back"), style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
        
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return Localizer.of(context).get("invalid-info") ?? "Invalid info";
        }
        if (value.trim() == "") {
          return Localizer.of(context).get("invalid-info") ?? "Invalid info";
        }
        return null;
      },
      style: TextStyle(color: Colors.black87),
      cursorColor: Theme.of(context).accentColor,
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(
          focusColor: Theme.of(context).accentColor,
          hintText: Localizer.of(context).get("password"),
          prefixIcon: Icon(Icons.lock_outline)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        print(state);
        if (state is SignupPasswordFailure) {
          _key.currentState
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.message))));
        }
      },
      bloc: BlocProvider.of<RootBloc>(context),
      child: BlocBuilder(
        bloc: BlocProvider.of<RootBloc>(context),
        builder: (context, state) => Scaffold(
          backgroundColor: Color(0xFFF3F5F7),
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
                                Localizer.of(context).get("sign-up") ??
                                    "Sign up",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        _buildPasswordField(),
                        SizedBox(
                          height: 30,
                        ),
                        _buildNextButton(BlocProvider.of<RootBloc>(context)),
                        SizedBox(
                          height: 50,
                        ),
                        _buildBackBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
