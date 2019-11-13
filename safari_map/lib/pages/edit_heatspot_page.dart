import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class EditHeatspotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditHeatspotState();

}

class _EditHeatspotState extends State<EditHeatspotPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit heatspot confidence"),

      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 100,
      itemBuilder: (context, index) {
        _buildSlidable(index);
      },
    );
  }

  Slidable _buildSlidable(int index) {
    return Slidable(
      key: ValueKey(index),
      actionPane: SlidableDrawerActionPane(),
      actions: <Widget>[
        IconSlideAction(
            caption: 'Archive',
            color: Colors.blue,
            icon: Icons.archive
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
          color: Colors.grey.shade200,
          icon: Icons.more_horiz,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
      ),
      child: ListTile(
        title: Text('$index'),
      ),
    );
  }
}
