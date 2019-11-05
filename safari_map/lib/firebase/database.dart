import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:safari_map/data/enums.dart';
import 'package:safari_map/firebase/authentication.dart';

abstract class Database {
  static const String droneCollection = "drones";
  static const String fixedWingDocument = "fixed-wing";
  static const String multiRotorDocument = "multi-rotor";
  static const String heatspotCollection = "heatspots";
  static const String userCollection = "users";

  //Future<List<Heatspot>> getHeatspots(DroneType type);
  Future<List<Heatspot>> getHeatspots();
  Future<void> validateUserPermissions();
}

class FirestoreHelper implements Database {
  final Firestore _instance = Firestore.instance;

//  Future<List<Heatspot>> getHeatspots(DroneType type) async {
//    final String droneType = type == DroneType.fixedWing ? Database.fixedWingDocument : Database.multiRotorDocument;
//    CollectionReference collection = await _instance.collection(Database.droneCollection).document(droneType).collection(Database.heatspotCollection);
//        //.where("heatspots.time", isGreaterThanOrEqualTo: new DateTime.now());
//
//    QuerySnapshot snapshot = await collection.getDocuments();
//    List<Heatspot> heatspots = new List();
//
//    for (var i = 0; i < snapshot.documents.length; i++) {
//      DocumentSnapshot doc = snapshot.documents[i];
//      Heatspot hs = Heatspot.getHeatspot(doc);
//      heatspots.add(hs);
//    }
//
//    return heatspots;
//  }

  Future<List<Heatspot>> getHeatspots() async {
    final currentDateTime = DateTime.now();
    final currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day); // Time at 00:00

    //var collection = await _instance.collection(Database.heatspotCollection).where("heatspot.time", isGreaterThanOrEqualTo: currentDate).reference();//.where("time", isGreaterThanOrEqualTo: currentDate).reference();//.where("time", is: new DateTime.now());
        //.where("heatspots.time", isGreaterThanOrEqualTo: new DateTime.now());
    // Only retrieve markers which are detected on the same day
    final Query query = _instance.collection(Database.heatspotCollection).where("time", isGreaterThanOrEqualTo: currentDate);

    QuerySnapshot snapshot = await query.getDocuments(); //_instance.collection(Database.heatspotCollection). //collection.getDocuments();
    List<Heatspot> heatspots = new List();

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot doc = snapshot.documents[i];
      Heatspot hs = Heatspot.getHeatspot(doc);
      heatspots.add(hs);
    }

    return heatspots;
  }

  // Checks if user permissions are present and if not will add them
  Future<void> validateUserPermissions() async {

    final Auth auth = FirebaseAuthentication();
    final FirebaseUser user = await auth.getCurrentUser();
    var data = {"canEdit":false, "email":user.email};
    DocumentReference docref  = _instance.collection(Database.userCollection).document(user.uid);
    DocumentSnapshot doc = await docref.get();
    if (!doc.exists)
      await _instance.collection(Database.userCollection).document(user.uid).setData(data, merge: true);
  }

  Future<bool> isAdministrator() async {
    final Auth auth = FirebaseAuthentication();
    final FirebaseUser user = await auth.getCurrentUser();
    DocumentReference docref  = _instance.collection(Database.userCollection).document(user.uid);
    DocumentSnapshot doc = await docref.get();
    if (doc.exists) {
      return doc.data["canEdit"];
    }
    else return false;
  }
}