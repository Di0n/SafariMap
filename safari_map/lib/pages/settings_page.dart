import 'package:flutter/material.dart';

class ListViewItem {
  String name;

}
class SettingsPage extends StatelessWidget {
  final List<String> _items = ["Password", "About"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView.separated(
            itemCount: _items.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_items[index]),
                onTap: (){},
              );
            }));
  }
}
