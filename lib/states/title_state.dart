import 'package:flutter/material.dart';

class TitleState extends ChangeNotifier {
  String title = '';

  void setTitle(String t) {
    title = t;
    notifyListeners();
  }
}
