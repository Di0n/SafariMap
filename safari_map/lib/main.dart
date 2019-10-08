
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/pages/root_page.dart';
// Main entry point
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safari Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          ),
        ),
      ),
      home: RootPage(auth: new FirebaseAuthentication()));
  }
}
