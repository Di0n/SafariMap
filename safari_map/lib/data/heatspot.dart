import 'package:cloud_firestore/cloud_firestore.dart';

class Heatspot {
  String _id;
  GeoPoint _location;
  Timestamp _time;
  String _description;

  Heatspot(String id, GeoPoint location, Timestamp time, String description) {
    this._id = id;
    this._location = location;
    this._time = _time;
    this._description = description;
  }

  String get description => _description;

  Timestamp get time => _time;

  GeoPoint get location => _location;

  String get id => _id;

  static Heatspot getHeatspot(DocumentSnapshot doc) {
    var data = doc.data;
    // TODO Exception if key value does not exist
    Heatspot hs = new Heatspot(doc.documentID, data["location"], data["time"], data["description"]);

    return hs;
  }
}