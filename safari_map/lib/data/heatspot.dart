import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safari_map/data/enums.dart';
import 'package:safari_map/data/firestore_object.dart';

class Heatspot implements FirestoreObject {
  String _id;
  GeoPoint _location;
  Timestamp _time;
  String _description;
  DroneType _drone;
  Map<String, int> _confidenceLevels;
  List<String> _images;

  Heatspot(String id, GeoPoint location, Timestamp time, String description,
      DroneType drone, Map<String, int> confidenceLevels, List<String> images) {
    this._id = id;
    this._location = location;
    this._time = time;
    this._description = description;
    this._drone = drone;
    this._confidenceLevels = confidenceLevels;
    this._images = images;
  }

  String get description => _description;

  Timestamp get time => _time;

  GeoPoint get location => _location;

  String get id => _id;

  DroneType get drone => _drone;

  Map<String, int> get confidenceLevels => _confidenceLevels;


  set confidenceLevels(Map<String, int> value) {
    _confidenceLevels = value;
  }

  List<String> get images => _images;

  MapEntry<String, int> getHighestAnimalConfidence() {
    if (_confidenceLevels.length > 0) {
      String animal = "";
      int highestConfidence = 0;

      _confidenceLevels.forEach((k, v) {
        if (v > highestConfidence) {
          animal = k;
          highestConfidence = v;
        }
      });

      // If a highest confidence animal is found
      if (animal.isNotEmpty) {
        return MapEntry(animal, highestConfidence);
      }
    }
    return null;
  }

  Map<String, Object> toFirestoreObject() {
    var data = {
      "confidenceLevels": confidenceLevels,
      "description" : description,
      "droneType" : drone.index,
      "images": images,
      "location": location,
      "time" : time
    };
    return data;
  }
  static Heatspot getHeatspot(DocumentSnapshot doc) {
    var data = doc.data;
    // TODO Exception if key value does not exist
    Map<dynamic, dynamic> confLevels = data["confidenceLevels"];
    Map<String, int> confidenceLevels = Map();
    confLevels.forEach((key, value) {
      String animal = key;
      int percentage = int.parse(value.toString());
      confidenceLevels.putIfAbsent(animal, () => percentage);
    });

    // test = map["Lion"];
    List<dynamic> images = data["images"];
    Heatspot hs = new Heatspot(doc.documentID, data["location"], data["time"],
        data["description"], DroneType.values[data["droneType"]], confidenceLevels, images.cast<String>());

    return hs;
  }
}