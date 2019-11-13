import 'package:firebase_auth/firebase_auth.dart';
import 'package:safari_map/firebase/database.dart';

abstract class User {
  String _uid;
  String _email;

  String get uid => _uid;

  String get email => _email;

  //Future<UserProperties> getUserProperties();

}


class FBUser extends User {
  FBUser(FirebaseUser fbUser) {
    _uid = fbUser.uid;
    _email = fbUser.email;
  }
}
/*class User {
  final String _uid;
  final String _email;
  bool _isAdmin;
  User(this._uid, this._email);

  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) {
    _isAdmin = value;
  }

  String get email => _email;

  String get uid => _uid;
}*/