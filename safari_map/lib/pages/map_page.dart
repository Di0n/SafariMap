import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:safari_map/firebase/database.dart';

class MapPage extends StatefulWidget {
  MapPage({this.auth, this.onSignedOut});

  final FirebaseAuthentication auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {
//
  static const LatLng _center = LatLng(-24.475740, 31.390870);
  static const double _defaultZoom = 17.0;
  static final CameraPosition _startingPosition = CameraPosition(
    target: _center,
    zoom: _defaultZoom
  );
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = Set();
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
      child: const Icon(Icons.airplanemode_active, size: 36.0)
    );
  }

  Widget _quadDroneButton() {
    return FloatingActionButton(
      onPressed: _onQuadDronePressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.toys, size: 36.0),
    );
  }

  Widget _myLocationButton() {
    return FloatingActionButton(
      onPressed: _onMyLocationPressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.my_location, size: 36.0)
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onBuilt(context));
  }
  // Called after widget is build
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
          )
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
    return Marker(
      markerId: MarkerId(hs.id),
      infoWindow: InfoWindow(
          title: hs.id,
          snippet: hs.description),
      position: LatLng(hs.location.latitude, hs.location.longitude),
    );
  }

  // Add markers to the map
  Future<void> _addMarkersToMap() async {
    // Retrieve heatspots from database
    List<Heatspot> heatspots = await database.getHeatspots(DroneType.fixedWing);
    // Create set for storage
    Set<Marker> markers = Set();
    // Loop through the loaded heatspots
    for (int i = 0; i < heatspots.length; i++) {
      Heatspot hs = heatspots[i];
      if (hs != null) {
        // Create the marker
        Marker marker = _createMarker(hs);
        markers.add(marker);
      }
    }
    // Add markers on map and rebuild widget
    setState(() {
      _markers.addAll(markers);
    });
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _onFixedDronePressed() async {
    // TODO toggle fixed drone markers

  }

  Future<void> _onQuadDronePressed() async {
    // TODO toggle quad drone markers
  }

  // Callback on my location pressed
  Future<void> _onMyLocationPressed() async {
    final GoogleMapController controller = await _controller.future;
    print("Future");
    LatLng loc;

    try {
      loc = await _getCurrentUserLocation();
      print("User loc");

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
    print("Zoom");

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