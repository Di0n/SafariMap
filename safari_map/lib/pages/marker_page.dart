import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:safari_map/data/animal_confidence.dart';
import 'package:safari_map/data/enums.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:safari_map/firebase/database.dart';
import 'package:safari_map/pages/photo_inspect_page.dart';
import 'package:safari_map/pages/edit_heatspot_page.dart';
import 'package:safari_map/utils/util.dart';

// Resources
// https://www.youtube.com/watch?v=_W2R-3dGHc4
// https://pub.dev/packages/gscarousel
// https://www.google.com/search?q=flutter+carousel+images&client=firefox-b-d&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjxu_Gh2enkAhUrMewKHSzjDEMQ_AUIEigC&biw=1536&bih=750#imgrc=_
// https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e

class MarkerPage extends StatefulWidget {
  final Heatspot hs;
  final bool _isAdmin;
  List<CachedNetworkImage> images;

  MarkerPage(this.hs, this._isAdmin) {
    images = List();
    for (int i = 0; i < hs.images.length; i++) {
      images.add(CachedNetworkImage(
          imageUrl: hs.images[i],
          imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )),
              ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error)));
    }
  }

  @override
  State<StatefulWidget> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {

  static const double _leftEdgeDistance = 8.0;
  List<AnimalConfidence> _animals = List<AnimalConfidence>();

  @override
  void initState() {
    super.initState();
    widget.hs.confidenceLevels.forEach((k, v) {
      _animals.add(AnimalConfidence(animal: k, confidence: v));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heatspot"),
        actions: <Widget>[
          _deleteIcon(),
          _editIcon()
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 64),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showImageCarousel(),
              _showConfidenceLevels(),
              _showDroneInfo(),
              _showTimeInfo(),
            ],
          ),
        ),
//       child: Container(
//         child: SizedBox(
//           height: 200.0,
//           child: Center(
//             child: Carousel(
//               images: widget.images,
//               dotSize: 6.0,
//               dotSpacing: 15.0,
//               dotColor: Colors.lightGreenAccent,
//               indicatorBgPadding: 5.0,
//               //dotBgColor: Colors.purple.withOpacity(0.5),
//               borderRadius: false,
//               autoplayDuration: Duration(milliseconds: 5000),
//             ),
//           ),
//         ),
//       ),
      ),
    );
  }

  Widget _deleteIcon() {
    if (widget._isAdmin) {
      return IconButton(icon: Icon(Icons.delete), onPressed: _onDeletePressed);
    } else {
      return Container(height: 0, width: 0);
    }
  }
  Widget _editIcon() {
    if (widget._isAdmin) {
      return IconButton(icon: Icon(Icons.edit), onPressed: _onEditPressed);
    } else {
      return Container(height: 0, width: 0);
    }
  }
  Widget _showImageCarousel() {
    return SizedBox(
      height: 200.0,
      child: Center(
        child: Carousel(
          images: widget.images,
          dotSize: 6.0,
          dotSpacing: 15.0,
          dotColor: Colors.redAccent,
          indicatorBgPadding: 5.0,
          //dotBgColor: Colors.purple.withOpacity(0.5),
          borderRadius: false,
          autoplayDuration: Duration(milliseconds: 5000),
          onImageTap: _onImageTap,
        ),
      ),
    );
  }

  Widget _showConfidenceLevels() {
    String text = "Confidence levels\n\n";
    widget.hs.confidenceLevels.forEach((k, v) {
      text += k + ": " + v.toString() + "%\n";
    });
    return Padding(
      padding: const EdgeInsets.fromLTRB(_leftEdgeDistance, 10, 0, 0),
      child: Text(text),
    );//Text(text);
  }

  Widget _showDroneInfo() {
    final heatspot = widget.hs;
    return Padding(
      padding: const EdgeInsets.fromLTRB(_leftEdgeDistance, 20, 0, 0),
      child: Text("Taken by dronetype: " + ((heatspot.drone == DroneType.fixedWing) ? "Fixed Wing" : "Multi Rotor"))
    );//Text("Taken by dronetype: " + ((heatspot.drone == DroneType.fixedWing) ? "Fixed Wing" : "Multi Rotor"));
  }

  Widget _showTimeInfo() {
    final heatspot = widget.hs;
    DateTime dt = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(_leftEdgeDistance, 5, 0, 0),
      child: Text("Taken on: " + Util.stringFormat("{0}:{1}, {2}-{3}-{4}.", [dt.hour, dt.minute, dt.day, dt.month, dt.year])),
    );
  }

  Future<void> _onImageTap(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoInspectPage(widget.images[index].imageUrl)));
    // TODO COULD HAVE: Gesture detector for image
  }

  Future<void> _onEditPressed() {
    // TODO open edit screen

    Navigator.push(context, MaterialPageRoute(builder: (context) => EditHeatspotPage(_animals)));

  }

  Future<void> _onDeletePressed() {

  }
}
