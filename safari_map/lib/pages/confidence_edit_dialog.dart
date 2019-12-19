import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safari_map/data/animal_confidence.dart';

class ConfidenceEditDialog extends StatefulWidget {
  static const int cancelled = -1;
  final AnimalConfidence _animalConfidence;
  ConfidenceEditDialog({AnimalConfidence animalConfidence}) : _animalConfidence = animalConfidence;

  @override
  State<StatefulWidget> createState() => _ConfidenceEditState();

}

class _ConfidenceEditState extends State<ConfidenceEditDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _confidenceInputController;
  TextEditingController _animalInputController;
  String _errorText;
  bool isCreating;


  @override
  void initState() {
    isCreating = widget._animalConfidence == null;
    _confidenceInputController = TextEditingController(text: !isCreating ?
    widget._animalConfidence.confidence.toString() : "");

    if (isCreating)
      _animalInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(!isCreating ? widget._animalConfidence.animal : "Animal"),
      /*content: TextFormField(
        controller: _confidenceInputController = TextEditingController(text: widget._animalConfidence.confidence.toString()),
        keyboardType: TextInputType.number,
        maxLines: 1,
        maxLength: 3,
        validator: _checkTextInput,
        decoration: InputDecoration(
          errorText: _errorText,
        ),
      ),*/
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _animalInputField(),
            SizedBox(height: 5),
            TextFormField(
              controller: _confidenceInputController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 3,
              validator: _checkTextInput,
              decoration: InputDecoration(
                errorText: _errorText,
              ),
            )
          ],
        ),
      actions: <Widget>[
        new FlatButton(
          child: Text("Save"),
          onPressed: () {
            setState(() {
              _errorText = _checkTextInput(_confidenceInputController.text);
            });
            if (_errorText == null) {
              if (!isCreating) {
                final int newConfidence = int.parse(_confidenceInputController.text);
                AnimalConfidence ac = AnimalConfidence(
                    animal: widget._animalConfidence.animal, confidence: newConfidence);
                Navigator.of(context).pop(ac);
              } else {
                final String animal = _animalInputController.text;
                final int confidence = int.parse(_confidenceInputController.text);

                AnimalConfidence ac = AnimalConfidence(animal: animal, confidence: confidence);
                Navigator.of(context).pop(ac);
              }
            }
          },

        ),
        new FlatButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop(null);
          },
        )
      ],
    );
  }

  Widget _animalInputField() {
    if (isCreating) {
      return TextFormField(
        controller: _animalInputController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: InputDecoration(
          errorText: null,
        ),
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }

  @override
  void dispose() {
    _confidenceInputController.dispose();
    if (_animalInputController != null)
      _animalInputController.dispose();
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