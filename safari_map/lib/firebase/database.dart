import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:safari_map/data/enums.dart';

abstract class Database {
  static const String droneCollection = "drones";
  static const String fixedWingDocument = "fixed-wing";
  static const String multiRotorDocument = "multi-rotor";
  static const String heatspotCollection = "heatspots";

  //Future<List<Heatspot>> getHeatspots(DroneType type);
  Future<List<Heatspot>> getHeatspots();
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
}