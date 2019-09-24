import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safari_map/data/enums.dart';

class Heatspot {
  String _id;
  GeoPoint _location;
  Timestamp _time;
  String _description;
  DroneType _drone;
  List<String> _images;

  Heatspot(String id, GeoPoint location, Timestamp time, String description, DroneType drone, List<String> images) {
    this._id = id;
    this._location = location;
    this._time = _time;
    this._description = description;
    this._drone = drone;
    this._images = images;
  }

  String get description => _description;

  Timestamp get time => _time;

  GeoPoint get location => _location;

  String get id => _id;

  DroneType get drone => _drone;

  List<String> get images => _images;

  static Heatspot getHeatspot(DocumentSnapshot doc) {
    var data = doc.data;
    // TODO Exception if key value does not exist
    List<dynamic> images = data["images"];
    Heatspot hs = new Heatspot(doc.documentID, data["location"], data["time"],
        data["description"], DroneType.values[data["droneType"]], images.cast<String>());

    return hs;
  }
}