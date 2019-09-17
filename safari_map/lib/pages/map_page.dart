import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage({this.auth, this.onSignedOut});

  final FirebaseAuthentication auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(51.585370, 4.790010);

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Map",
          )
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  // On back press callback
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

  // Sign the user out
  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}