import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:safari_map/data/animal_confidence.dart';
import 'package:safari_map/data/heatspot.dart';
import 'package:safari_map/pages/confidence_edit_dialog.dart';

class EditHeatspotPage extends StatefulWidget {
  List<AnimalConfidence> _animals = List();
  Heatspot _hs;
  EditHeatspotPage(this._hs) {
    _hs.confidenceLevels.forEach((k, v) {
      _animals.add(AnimalConfidence(animal: k, confidence: v));
    });
  }

  @override
  State<StatefulWidget> createState() => _EditHeatspotState();
}

class _EditHeatspotState extends State<EditHeatspotPage> {
  bool _edited = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editing confidence levels'),
        ),
        body: _buildListView(context),
        floatingActionButton: _addButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildListView(BuildContext ctx) {
    int count = 20;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
      itemCount: widget._animals.length,
      separatorBuilder: (context, index) => Divider(),

      itemBuilder: (context, index) {
        //if (index.isOdd) return Divider();
        return Slidable(
          key: UniqueKey(),
          actionPane: SlidableDrawerActionPane(),
//          actions: <Widget>[
//          IconSlideAction(
//            caption: 'Archive',
//            color: Colors.blue,
//            icon: Icons.archive,
//          ),
//          IconSlideAction(
//            caption: 'Share',
//            color: Colors.indigo,
//            icon: Icons.share,
//          ),
//        ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.grey.shade200,
              icon: Icons.edit,
              onTap: () async {
                  AnimalConfidence ac = widget._animals[index];
                  final AnimalConfidence result = await showDialog(
                  context: ctx,
                  builder: (BuildContext bContext) => ConfidenceEditDialog(
                    animalConfidence: ac
                  )
                );
                  // widget._hs.confidenceLevels[animal.animal] = result
                  if (result != null) {
                    _edited = true;
                    setState(() {
                      widget._hs.confidenceLevels[result.animal] = result.confidence;
                    });
                  }

              }, // TODO spawn prompt to edit confidence levels
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,

            ),
          ],
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onDismissed: (SlideActionType t) {
              _edited = true;

              setState(() {
                AnimalConfidence removedAc = widget._animals.removeAt(index);
                widget._hs.confidenceLevels.remove(removedAc.animal);
              });
            },
          ),
          child: ListTile(
            title: Text(widget._animals[index].toString()),
          ),
        );
      },
    );
//    return ListView.builder(
//      //padding: const EdgeInsets.all(16.0),
//      itemCount: 100,
//      itemBuilder: (context, index) {
//        _buildSlidable(index);
//      },
//    );
  }

  Slidable _buildSlidable(int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text('$index'),
            foregroundColor: Colors.white,
          ),
          title: Text('Tile n°$index'),
          subtitle: Text('SlidableDrawerDelegate'),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,

        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,

        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
        ),
      ],
    );
//    return Slidable(
//      key: ValueKey(index),
//      actionPane: SlidableDrawerActionPane(),
//      actions: <Widget>[
//        IconSlideAction(
//            caption: 'Archive',
//            color: Colors.blue,
//            icon: Icons.archive
//        ),
//        IconSlideAction(
//          caption: 'Share',
//          color: Colors.indigo,
//          icon: Icons.share,
//        ),
//      ],
//      secondaryActions: <Widget>[
//        IconSlideAction(
//          caption: 'More',
//          color: Colors.grey.shade200,
//          icon: Icons.more_horiz,
//        ),
//        IconSlideAction(
//          caption: 'Delete',
//          color: Colors.red,
//          icon: Icons.delete,
//        ),
//      ],
//      dismissal: SlidableDismissal(
//        child: SlidableDrawerDismissal(),
//      ),
//      child: ListTile(
//        title: Text('$index'),
//      ),
//    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      onPressed: () async {
        final AnimalConfidence result = await showDialog(
            context: context,
            builder: (BuildContext bContext) => ConfidenceEditDialog()
        );

        if (result != null) {
          _edited = true;
          setState(() {
            widget._hs.confidenceLevels.putIfAbsent(result.animal, ()=> result.confidence);
          });
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.add, color: Colors.black),
      heroTag: "add_animal_conf_fab",
    );
  }
  Future<bool> _onWillPop() {
    Navigator.pop(context, (_edited) ? widget._hs : null);
    return Future.value(false);
  }

}
