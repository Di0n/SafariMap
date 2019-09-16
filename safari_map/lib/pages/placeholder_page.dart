import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/utils/resource_strings.dart';


class PlaceHolderPage extends StatefulWidget {
  PlaceHolderPage({this.auth, this.userID, this.onSignedOut});
  final FirebaseAuthentication auth;
  final VoidCallback onSignedOut;

  final String userID;

  @override
  State<StatefulWidget> createState() => new _PlaceHolderState();
}

class _PlaceHolderState extends State<PlaceHolderPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Placeholder",
            ),
          ),
          body: Center(
            child: Text("This is a place holder\nUser: ${widget.userID}"),
          ),
        ));
  }


  @override
  void initState() {

  }

  Future<bool> _onBackPressed() async {
    bool val = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => new AlertDialog(
            title: Text("Logout"),
            content: Text(
                "Are you sure you want to logout and return to the login page?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  print("No pressed");
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  print("Yes pressed");

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;

    if (val) {
      await _signOut();
    }

    return false;
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}
