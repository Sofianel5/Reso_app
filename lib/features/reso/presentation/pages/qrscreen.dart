import 'dart:ui';
import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class QRScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QRScreenState();
}

class QRScreenState extends State<QRScreen> {
  Widget _buildUnlockButton(QRPageBloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Stack(
        children: [
          RaisedButton(
            onPressed: () => bloc.add(QRLockToggle()),
            elevation: 10,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.lock, color: Colors.white),
                SizedBox(
                  width: 20,
                ),
                Text(
                  Localizer.of(context).get("unlock-btn"),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Stack(
        children: [
          RaisedButton(
            onPressed: () {},
            elevation: 10,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(backgroundColor: Colors.white)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockButton(QRPageBloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => bloc.add(QRLockToggle()),
        elevation: 10,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock_open,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              Localizer.of(context).get("lock-btn"),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedContents(QRState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SpinKitWave(color: Theme.of(context).accentColor, size: 150),
      ),
    );
  }

  Widget _buildLoadingContents() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildConfirmButton(
      QRPageBloc bloc, QRScannedState state, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => bloc.add(ScanConfirmed(state.thread)),
        elevation: 10,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              Localizer.of(context).get("confirm-entry"),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedInfo(QRPageBloc bloc) {
    final state = bloc.state;
    if (state is QRNoScanState) {
      return Center(
        //! Localize
        child:
            Text(Localizer.of(context).get("no-scans") ?? "No pending scans"),
      );
    } else if (state is QRScannedState) {
      return Column(
        children: <Widget>[
          //! Localize
          Container(
            height: 100,
            child: AspectRatio(
              aspectRatio: 1,
              child: FlareActor(
                "assets/success.flr",
                animation: "Untitled",
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
          _buildConfirmButton(bloc, state, Colors.greenAccent[700])
        ],
      );
    } else if (state is QREntryConfirmedState) {
      return Center(
        //! Localize
        child: Text(Localizer.of(context).get("confirmed") ??
            "Confirmation successful"),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<QRPageBloc>(context),
      listener: (context, state) async {
        print("listening");
        if (state is QRFailedState) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.message))));
        } else if (state is QRUnlockedState) {
          while (
              BlocProvider.of<QRPageBloc>(context).state is QRUnlockedState) {
            await Future.delayed(const Duration(seconds: 1), () => "1");
            if (BlocProvider.of<QRPageBloc>(context).state is QRUnlockedState) {
              //BlocProvider.of<QRPageBloc>(context).add(QRCheckScan());
            }
          }
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<QRPageBloc>(context),
        builder: (context, state) =>
            buildBody(context, state, BlocProvider.of<QRPageBloc>(context)),
      ),
    );
  }

  SingleChildScrollView buildBody(
      BuildContext context, QRState state, QRPageBloc bloc) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                  child: Column(
                    children: <Widget>[
                      buildHeader(context),
                      Stack(
                        children: [
                          buildQRImage(state),
                          (state is QRUnlockedState)
                              ? Container()
                              : buildBlur(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            buildContents(state, bloc),
          ],
        ),
      ),
    );
  }

  Container buildContents(QRState state, QRPageBloc bloc) {
    return Container(
      height: 500,
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Column(
          children: buildContentList(state, bloc),
        ),
      ),
    );
  }

  List<Widget> buildContentList(QRState state, QRPageBloc bloc) {
    List<Widget> children = [];
    if (state is QRLoadingState) {
      children.add(_buildLoadingButton());
      children.add(_buildLoadingContents());
    } else if (state is QRFailedState) {
      if (state.user.isLocked ?? true) {
        children.add(_buildUnlockButton(bloc));
        children.add(_buildLockedInfo(bloc));
      } else {
        children.add(_buildLockButton(bloc));
        children.add(_buildUnlockedContents(state));
      }
    } else if (state is QRUnlockedState) {
      children.add(_buildLockButton(bloc));
      children.add(_buildUnlockedContents(state));
    } else {
      children.add(_buildUnlockButton(bloc));
      children.add(_buildLockedInfo(bloc));
    }
    return children;
  }

  Center buildBlur() {
    return Center(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            color: Colors.black.withOpacity(0),
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }

  Padding buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      //! Localize
      child: Text(
        Localizer.of(context).get("me-title"),
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      ),
    );
  }

  Center buildQRImage(QRState state) {
    return Center(
      child: QrImage(
        data: state.user.publicId,
        version: QrVersions.auto,
        foregroundColor: Colors.black,
        size: 200.0,
      ),
    );
  }
}
