import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpEmailScreen extends StatefulWidget {
  @override
  _SignUpEmailScreenState createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {

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
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
  }

  Widget _buildEmailField() {
    return TextFormField(
      style: TextStyle(color: Colors.black87),
      cursorColor: Theme.of(context).accentColor,
      controller: _email,
      validator: (value) {
        if (value == null) {   
          return Localizer.of(context).get("invalid-info");
        } if (value.trim() == "") {
          return Localizer.of(context).get("invalid-info");
        } return null;
      },
      focusNode: emailNode,
      decoration: InputDecoration(
          focusColor: Colors.black,
          hintText: Localizer.of(context).get("email"),
          prefixIcon: Icon(Icons.email)),
    );
  }


  Widget _buildNextButton(RootBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () {
          bloc.add(EmailPageSubmitted(_email.text));
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: Text(
                      Localizer.of(context).get("next"),
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
        onPressed: () =>
            Navigator.pop(context), 
        child: Text(Localizer.of(context).get("back"), style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<RootBloc>(context),
      listener: (context, state) {
        if (state is SignupEmailFailure) {
          _key.currentState
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.message))));
        }
      },
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
                                Localizer.of(context).get("sign-up") ?? "Sign up",
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
                        _buildEmailField(),
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
