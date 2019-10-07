import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoInspectPage extends StatelessWidget {
  //final CachedNetworkImage image;
  String image;
  PhotoInspectPage(this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inspect image"),
      ),
      body: GestureDetector(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(image),
          backgroundDecoration: BoxDecoration(color: Colors.black),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}