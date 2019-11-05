import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/firebase/database.dart';
import 'package:safari_map/pages/forgot_password_page.dart';
import 'package:safari_map/pages/photo_inspect_page.dart';
import 'package:safari_map/utils/resource_strings.dart';
import 'package:safari_map/utils/text_resource_manager.dart';

/* Login page using Firebase authentication
* */
class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final FirebaseAuthentication auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  final RegExp _emailRegex = RegExp("^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$",
      caseSensitive: false,
      multiLine: false);

  bool _isIos;
  bool _isLoading;
  bool _emailPassCombinationSuccess;

  String _email;
  String _password;
  String _errorMessage;


  // Init values
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _emailPassCombinationSuccess = true;
    super.initState();
  }

  // region Widgets
  // Build login page
  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text(ResourceStrings.LOGIN_TITLE),
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  // Progress animation @ login
  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0, width: 0.0);
  }

  // Show logo
  Widget _showLogo() {
    return Hero(
        tag: 'hero',
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset('assets/icons/safari_live-icon2.png'),
          ),
        ));
  }

  // Email input field
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: ResourceStrings.LOGIN_EMAIL,
            errorText: _emailPassCombinationSuccess ? null : "Email does not match password.",
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          _isLoading = false;

          if (value.isEmpty) {
            return 'Email can\'t be empty';
          } else if (!_emailRegex.hasMatch(value)) {
            return "Not a valid email address.";
          }
          else {
            _isLoading = true;
            return null;
          }
        },
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  // Password input field
  Widget _showPasswordInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          autofocus: false,
          obscureText: true,
          decoration: InputDecoration(
              hintText: ResourceStrings.LOGIN_PASSWORD,
              errorText: _emailPassCombinationSuccess ? null : "Password does not match email.",
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.isEmpty) {
              _isLoading = false;

              return 'Password can\'t be empty';
            } else {
              return null;
            }
          },
          onSaved: (value) => _password = value.trim(),
        ));
  }

  // Login button
  Widget _showLoginButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.redAccent,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: _validateAndSubmit,
        ),
      ),
    );
  }

  // Forgot password button
  Widget _showForgotPasswordButton() {
    return FlatButton(
      child: Text(ResourceStrings.LOGIN_FORGOT_BUTTON,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _onForgotPasswordPressed, // TODO password screen
    );
  }

  // Error message
  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  // The body containing all the fields
  Widget _showBody() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showLoginButton(),
              _showForgotPasswordButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }
  // endregion

  void _onForgotPasswordPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage(widget.auth)));
  }

  // Validate and save form
  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Validate and submit form
  void _validateAndSubmit() async {
    // Dismiss the keyboard (otherwise google maps will crash) https://github.com/flutter/flutter/issues/31152
    SystemChannels.textInput.invokeMethod("TextInput.hide");

    setState(() {
      _errorMessage = "";
      _isLoading = true;
      _emailPassCombinationSuccess = true;
    });
    if (!_validateAndSave()) return;

    String userID = "";
    try {
      userID = await widget.auth.signIn(_email, _password);

      setState(() {
        _isLoading = false;
      });

      if (userID != null && userID.length > 0) {
        print('Signed in: $userID');
        Database db = FirestoreHelper();
        await db.validateUserPermissions();
        widget.onSignedIn();
      } else {
        _emailPassCombinationSuccess = false;
      }

    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        // iOS handles the error message differently
        _errorMessage = _isIos ? e.details : e.message;
      });
    }
  }
}
