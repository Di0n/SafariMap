import 'package:flutter/material.dart';
import 'package:safari_map/login_page.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/pages/map_page.dart';
import 'package:safari_map/pages/placeholder_page.dart';
import 'package:safari_map/utils/text_resource_manager.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final FirebaseAuthentication auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthState {
  NOT_LOGGED_IN,
  LOGGED_IN,
  NOT_DETERMINED,
}

class _RootPageState extends State<RootPage> {
  AuthState authState = AuthState.NOT_DETERMINED;

  String _userID = "";

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userID = user?.uid;
        }
        authState = user?.uid == null ? AuthState.NOT_LOGGED_IN : AuthState.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userID = user.uid.toString();
      });
    });
    setState(() {
      authState = AuthState.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authState = AuthState.NOT_LOGGED_IN;
      _userID = "";
    });
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authState) {
      case AuthState.NOT_DETERMINED:
        return _buildLoadingScreen();
        break;

      case AuthState.NOT_LOGGED_IN:
        return LoginPage(auth: widget.auth, onSignedIn: _onLoggedIn);
        break;

      case AuthState.LOGGED_IN:
        if (_userID != null && _userID.length > 0) {
          return MapPage(
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
//          return PlaceHolderPage(
//            auth: widget.auth,
//            userID: _userID,
//            onSignedOut: _onSignedOut,
//          );
        } else return _buildLoadingScreen();
        break;
      default:
        return _buildLoadingScreen();
    }
  }


}
