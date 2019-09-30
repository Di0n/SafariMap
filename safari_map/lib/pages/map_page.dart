import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/firebase/database.dart';
import 'package:safari_map/data/enums.dart';
import 'package:safari_map/pages/marker_page.dart';

class MapPage extends StatefulWidget {
  MapPage({this.auth, this.onSignedOut});

  final FirebaseAuthentication auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {
//
  //static const LatLng _center = LatLng(-24.475740, 31.390870);
  static const LatLng _center = LatLng(51.657871, 4.812610);

  static const double _defaultZoom = 17.0;
  static final CameraPosition _startingPosition = CameraPosition(
    target: _center,
    zoom: _defaultZoom
  );

  final Completer<GoogleMapController> _controller = Completer();

  // Markers visible on map
  final Set<Marker> _markers = Set();
  // Marker ID's with state objects (heatspot)
  final Set<Marker> _allMarkers = Set();
  final Map<MarkerId, Heatspot> _markerHeatspots = Map();
  // Database for retrieval of data
  final Database database = FirestoreHelper();


  GoogleMap getMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      mapType: MapType.satellite,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      trafficEnabled: false,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      zoomGesturesEnabled: true,
      initialCameraPosition: _startingPosition,
      markers: _markers,
    );
  }

  Widget _fixedDroneButton() {
    //return FloatingActionButton.extended(onPressed: _onFixedDronePress, label: Text("Test"), icon: Icon(Icons.airplanemode_active));
    return FloatingActionButton(
      onPressed: _onFixedDronePressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.airplanemode_active, size: 36.0),
      heroTag: "fixed_drone_fab",
    );
  }

  Widget _quadDroneButton() {
    return FloatingActionButton(
      onPressed: _onQuadDronePressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.toys, size: 36.0),
      heroTag: "multi_copter_fab",
    );
  }

  Widget _myLocationButton() {
    return FloatingActionButton(
      onPressed: _onMyLocationPressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.my_location, size: 36.0),
      heroTag: "my_location_fab",
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onBuilt(context));
  }
  // Called after widget is build for the first time
  Future<void> _onBuilt(BuildContext context) async {
    print("onBuilt");
    await _addMarkersToMap();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Map",
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more_vert), onPressed: (){}), // TODO popupmenu
          ],
        ),
        body: Stack(
          children: <Widget>[
            getMap(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    _fixedDroneButton(),
                    SizedBox(height: 16.0),
                    _quadDroneButton()
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: _myLocationButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _createMarker(Heatspot hs) {
    final MarkerId mID = MarkerId(hs.id);
    return Marker(
      markerId: mID,
      infoWindow: InfoWindow(
          title: hs.id,
          snippet: "Made by: ${hs.drone.toString()}\n\n${hs.description}"),
      position: LatLng(hs.location.latitude, hs.location.longitude),
      onTap: () {
        _onMarkerTap(mID);
      },
      visible: true,
    );
  }

  bool _fixedWingEnabled = true;
  bool _multiRotorEnabled = true;
  void _toggleDroneTypeMap(final DroneType type) {
    if (type == DroneType.fixedWing)
      _fixedWingEnabled = !_fixedWingEnabled;
    else
      _multiRotorEnabled = !_multiRotorEnabled;

    final bool val = type == DroneType.fixedWing ? _fixedWingEnabled : _multiRotorEnabled;
    setState(() {
      if (!val) {
        _markers.removeWhere((m) {
          final Heatspot hs = _markerHeatspots[m.markerId];
          return hs.drone == type;
        });
      }
      else {
        var set = _allMarkers.where((m) {
          final Heatspot hs = _markerHeatspots[m.markerId];
          return hs.drone == type;
        }).toSet();
        _markers.addAll(set);
      }
    });
  }
  // Add markers to the map
  Future<void> _addMarkersToMap() async {
    // Retrieve heatspots from database
//    List<Heatspot> heatspots = await database.getHeatspots(DroneType.fixedWing);
//    var temp = await database.getHeatspots(DroneType.multiRotor);
    List<Heatspot> heatspots = await database.getHeatspots();
    // Create set for storage
    Set<Marker> markers = Set();
    // Loop through the loaded heatspots
    for (int i = 0; i < heatspots.length; i++) {
      Heatspot hs = heatspots[i];
      if (hs != null) {
        // Create the marker
        Marker marker = _createMarker(hs);
        markers.add(marker);
        _markerHeatspots.putIfAbsent(marker.markerId, () => hs);
      }
    }
    // Add markers on map and rebuild widget
    setState(() {
      _markers.addAll(markers);
      _allMarkers.addAll(markers);
    });
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  Future<void> _onFixedDronePressed() {
    _toggleDroneTypeMap(DroneType.fixedWing);
//    _fixedWingEnabled = !_fixedWingEnabled;
//    setState(() {
//      if (!_fixedWingEnabled) {
//        _markers.removeWhere((m) {
//          final Heatspot hs = _markerHeatspots[m.markerId];
//          return hs.drone == DroneType.fixedWing;
//        });
//      }
//      else {
//        var set = _allMarkers.where((m) {
//          final Heatspot hs = _markerHeatspots[m.markerId];
//          return hs.drone == DroneType.fixedWing;
//        }).toSet();
//        _markers.addAll(set);
//      }
//    });
  }

  // Aka Multi rotor
  Future<void> _onQuadDronePressed() {
    _toggleDroneTypeMap(DroneType.multiRotor);
//    _multiRotorEnabled = !_multiRotorEnabled;
//    setState(() {
//      if (!_multiRotorEnabled) {
//        _markers.removeWhere((m) {
//          final Heatspot hs = _markerHeatspots[m.markerId];
//          return hs.drone == DroneType.multiRotor;
//        });
//      }
//      else {
//        var set = _allMarkers.where((m) {
//          final Heatspot hs = _markerHeatspots[m.markerId];
//          return hs.drone == DroneType.multiRotor;
//        }).toSet();
//        _markers.addAll(set);
//      }
//    });
  }

  Future<void> _onMarkerTap(MarkerId id) async {
    final Marker marker = _markers.firstWhere((m) => m.markerId == id);
    if (marker == null) {
      // TODO marker was null
      print("Marker is null");
      return;
    }
    print("Marker tapped and found");
    final heatspot = _markerHeatspots[marker.markerId];
    Navigator.push(context, MaterialPageRoute(builder: (context) => MarkerPage(heatspot)),);
  }

  // Callback on my location pressed
  // TODO replace with geolocation for faster result
  Future<void> _onMyLocationPressed() async {
    final GoogleMapController controller = await _controller.future;
    LatLng loc;

    try {
      loc = await _getCurrentUserLocation();
    } on Exception {
      return;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: loc,
        zoom: _defaultZoom,
      )
    ));
  }

  // Gets the current location of the user
  Future<LatLng> _getCurrentUserLocation() async {
    LocationData currentLocation;
    Location location = Location();
    currentLocation = await location.getLocation();
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }


  // On back press callback
  Future<bool> _onBackPressed() async {
    bool val = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: Text("Logout"),
        content: Text(
            "Are you sure you want to logout and return to the login page?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () {
              print("No pressed");
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              print("Yes pressed");

              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    ) ??
        false;

    if (val) {
      await _signOut();
    }

    return false;
  }

  // Sign the user out
  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}