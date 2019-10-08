import 'package:flutter/material.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/utils/resource_strings.dart';

class ForgotPasswordPage extends StatefulWidget {
  final FirebaseAuthentication auth;

  ForgotPasswordPage(this.auth);

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final RegExp _emailRegex = RegExp("^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$",
      caseSensitive: false,
      multiLine: false);

  String _email;
  String _errorMessage;

  bool _isLoading;
  bool _isIos;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text(ResourceStrings.PASSWORD_RESET),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // TODO _showLogo()
            //_showText(),
            _showEmailInput(),
            _showButton(),
            _showErrorMessage()
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    return _isLoading ? Center(child: CircularProgressIndicator()) : Container(height: 0.0, width: 0.0);
  }

  Widget _showText() {
    return Text("Enter your email",
      style: TextStyle(
        fontSize: 13.0,
        color: Colors.black,
        height: 1.0,
        fontWeight: FontWeight.w300
      ));
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        decoration: InputDecoration(
          hintText: ResourceStrings.EMAIL_INPUT,
          errorText: null,
          icon: Icon(
            Icons.mail,
            color: Colors.grey
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

  Widget _showButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.redAccent,
          child: Text(
            "Submit",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: _validateAndSubmit,
        )
      ),
    );
  }

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

  bool _submitForm() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _validateAndSubmit() async {

    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (!_submitForm()) return;

    try {
      await widget.auth.sendPasswordResetEmail(_email);

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
      // TODO show animation after reset email is sent
      // https://medium.com/flutter-community/flutter-animation-has-never-been-easier-part-1-e378e82b2508
    } catch (e) {
      print("Error: $e");

      setState(() {
        _isLoading = false;

        _errorMessage = _isIos ? e.details : e.message;
      });
    }
  }

}