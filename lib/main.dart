import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localizations/localizations.dart';
import 'features/reso/presentation/pages/splash.dart';
import 'injection_container.dart' as ic;
import 'injection_container.dart';

void main() async {
  await ic.init();
  runApp(Reso());
}

class Reso extends StatefulWidget {
  @override
  _ResoState createState() => _ResoState();
}

class _ResoState extends State<Reso> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RootBloc>(),
      child: MaterialApp(
        title: 'Reso',
        theme: ThemeData(
          primaryColor: Color(0xFF1b4774),
          accentColor: Color(0xFF03016c),
          scaffoldBackgroundColor: Color(0xFF00c2cc),
          canvasColor: Color(0xFF5104f8),
          bottomAppBarColor: Color(0xFFF3F5F7),
        ),
        home: RootPage(),
        supportedLocales: [
          Locale("en"),
          Locale("fr"),
          Locale("ar"),
          Locale("es"),
          Locale("de"),
          Locale("nl"),
          Locale("it"),
          Locale("pl"),
        ],
        localizationsDelegates: [
          Localizer.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          } return supportedLocales.first;
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RootBloc, RootState>(
        builder: (context, state) {
          if (state is InitialState) {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
