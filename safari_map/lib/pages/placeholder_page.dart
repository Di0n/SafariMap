import 'package:flutter/material.dart';

class PlaceHolderPage extends StatelessWidget {

  PlaceHolderPage({this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Placeholder"),
      ),
      body: Center(
        child: Text("This is a place holder\nUser: $userID"),
      )
    );
  }
}