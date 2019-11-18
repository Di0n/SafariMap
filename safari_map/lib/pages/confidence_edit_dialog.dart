import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safari_map/data/animal_confidence.dart';

class ConfidenceEditDialog extends StatefulWidget {
  static const int cancelled = -1;
  final AnimalConfidence _animalConfidence;
  ConfidenceEditDialog(this._animalConfidence);

  @override
  State<StatefulWidget> createState() => _ConfidenceEditState();

}

class _ConfidenceEditState extends State<ConfidenceEditDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textController;
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget._animalConfidence.animal),
      content: TextFormField(
        controller: _textController = TextEditingController(text: widget._animalConfidence.confidence.toString()),
        keyboardType: TextInputType.number,
        maxLines: 1,
        maxLength: 3,
        validator: _checkTextInput,
        decoration: InputDecoration(
          errorText: _errorText,
        ),
      ),
//      content: TextField(
//        controller: controller,
//        decoration: InputDecoration(hintText: _animalConfidence.confidence.toString() + "%"),
//      ),
      actions: <Widget>[
        new FlatButton(
          child: Text("Save"),
          onPressed: () {
            setState(() {
              _errorText = _checkTextInput(_textController.text);
            });
            if (_errorText == null) {
              Navigator.of(context).pop(int.parse(_textController.text));
            }
          },

        ),
        new FlatButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop(ConfidenceEditDialog.cancelled);
          },
        )
      ],
    );
  }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _checkTextInput(String text) {
    final int nr = int.tryParse(text);
    if (nr == null)
      return "Could not parse number.";

    if (nr < 0)
      return "Percentage can't be smaller than 0.";
    else if (nr > 100)
      return "Percentage can't be bigger than 100.";

    return null;
  }
//  Future<void> displayDialog(BuildContext context, TextEditingController controller) async {
//    return showDialog(
//      context: context,
//      builder: (context) {
//        return AlertDialog(
//          title: Text(_animalConfidence.animal),
//          content: TextField(
//            controller: controller,
//            decoration: InputDecoration(hintText: _animalConfidence.confidence.toString() + "%"),
//          ),
//          actions: <Widget>[
//            new FlatButton(
//              child: Text("Save"),
//              onPressed: () {},
//            ),
//            new FlatButton(
//                child: Text("Cancel"),
//                onPressed: (){
//                  Navigator.of(context).pop();
//                },
//            )
//          ],
//        );
//      });
//  }


}