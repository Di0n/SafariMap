import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safari_map/data/heatspot.dart';

enum DroneType { fixedWing, multiRotor }
abstract class Database {
  static const String droneCollection = "drones";
  static const String fixedWingDocument = "fixed-wing";
  static const String multiRotorDocument = "multi-rotor";
  static const String heatspotCollection = "heatspots";

  Future<List<Heatspot>> getHeatspots(DroneType type);
}

class FirestoreHelper implements Database {
  final Firestore _instance = Firestore.instance;

  Future<List<Heatspot>> getHeatspots(DroneType type) async {
    final String droneType = type == DroneType.fixedWing ? Database.fixedWingDocument : Database.multiRotorDocument;
    CollectionReference collection = await _instance.collection(Database.droneCollection).document(droneType).collection(Database.heatspotCollection);
        //.where("heatspots.time", isGreaterThanOrEqualTo: new DateTime.now());

    QuerySnapshot snapshot = await collection.getDocuments();
    List<Heatspot> heatspots = new List();

    for (var i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot doc = snapshot.documents[i];
      Heatspot hs = Heatspot.getHeatspot(doc);
      heatspots.add(hs);
    }

    return heatspots;
  }
}