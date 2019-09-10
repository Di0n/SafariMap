
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/pages/root_page.dart';
// Main entry point
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safari Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: RootPage(auth: new FirebaseAuthentication()));
  }
}
