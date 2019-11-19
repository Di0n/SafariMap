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
  TextEditingController _textController;
  TextEditingController _animalInputController;
  String _errorText;
  bool isCreating;


  @override
  void initState() {
    isCreating = widget._animalConfidence == null;
    _textController = TextEditingController(text: !isCreating ?
    widget._animalConfidence.confidence.toString() : "");

    if (isCreating)
      _animalInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(!isCreating ? widget._animalConfidence.animal : "Animal"),
      /*content: TextFormField(
        controller: _textController = TextEditingController(text: widget._animalConfidence.confidence.toString()),
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
              controller: _textController,
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
    _textController.dispose();
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