import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:carousel_pro/carousel_pro.dart';

// Resources
// https://www.youtube.com/watch?v=_W2R-3dGHc4
// https://pub.dev/packages/gscarousel
// https://www.google.com/search?q=flutter+carousel+images&client=firefox-b-d&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjxu_Gh2enkAhUrMewKHSzjDEMQ_AUIEigC&biw=1536&bih=750#imgrc=_
// https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e

class MarkerPage extends StatefulWidget {
  final Heatspot hs;
  List<CachedNetworkImage> images;

  MarkerPage(this.hs) {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heatspot"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showImageCarousel(),
              Text("asda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\n"
                  "asda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\nasda\nasdasd\nasdasd\n"),
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

  Widget _showImageCarousel() {
    return SizedBox(
      height: 200.0,
      child: Center(
        child: Carousel(
          images: widget.images,
          dotSize: 6.0,
          dotSpacing: 15.0,
          dotColor: Colors.lightGreenAccent,
          indicatorBgPadding: 5.0,
          //dotBgColor: Colors.purple.withOpacity(0.5),
          borderRadius: false,
          autoplayDuration: Duration(milliseconds: 5000),
        ),
      ),
    );
  }
}
