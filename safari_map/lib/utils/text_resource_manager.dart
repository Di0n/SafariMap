import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class TextResourceManager {
  static final TextResourceManager _textResourceManager = new TextResourceManager._internal();

  factory TextResourceManager() {
    return _textResourceManager;
  }

  TextResourceManager._internal();

  Map<String, dynamic> resource;

  Future<String> loadAssets() async {
    final String jsonData = await rootBundle.loadString("assets/lang/en.json");
    resource = jsonDecode(jsonData);
  }
}