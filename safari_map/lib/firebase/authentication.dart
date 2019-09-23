import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/* Acts as an interface for authentication, so it can be switched to another service in the future if needed.
* */
abstract class Auth {
  Future<String> signIn(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class FirebaseAuthentication implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user.uid;

    } catch (e) {
      print(e.toString());
    }

  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}

