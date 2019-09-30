import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:safari_map/firebase/authentication.dart';
import 'package:carousel_pro/carousel_pro.dart';

// Resources
// https://www.youtube.com/watch?v=_W2R-3dGHc4
// https://pub.dev/packages/gscarousel
// https://www.google.com/search?q=flutter+carousel+images&client=firefox-b-d&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjxu_Gh2enkAhUrMewKHSzjDEMQ_AUIEigC&biw=1536&bih=750#imgrc=_
// https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e

class MarkerPage extends StatefulWidget {
  MarkerPage({this.hs});

  final Heatspot hs;

  @override
  State<StatefulWidget> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {

  static final List<String> imgList = [
    "https://www.kids-world-travel-guide.com/images/xsouthafricanlion_andrewpauldeer_ssk-2.jpg.pagespeed.ic.CMraoKsADq.jpg",
    "https://r7h9p6s7.stackpathcdn.com/wp-content/uploads/2002/04/wildlife-dec16.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Heatspot"),),
      body: SingleChildScrollView(
       child: Container(
         child: SizedBox(
           height: 200.0,
           child: Center(
             child: Carousel(
               images: [
                 NetworkImage("https://www.kids-world-travel-guide.com/images/xsouthafricanlion_andrewpauldeer_ssk-2.jpg.pagespeed.ic.CMraoKsADq.jpg"),
                 NetworkImage("https://r7h9p6s7.stackpathcdn.com/wp-content/uploads/2002/04/wildlife-dec16.jpg")
               ],
               dotSize: 6.0,
               dotSpacing: 15.0,
               dotColor: Colors.lightGreenAccent,
               indicatorBgPadding: 5.0,
               //dotBgColor: Colors.purple.withOpacity(0.5),
               borderRadius: false,
               autoplayDuration: Duration(milliseconds: 5000),
             ),
           ),
         ),
       ),
      ),
    );
  }
}