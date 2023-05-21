import 'package:flutter/material.dart';

class LoadingState extends ChangeNotifier {
  bool state = false;

  void showLoading() {
    state = true;

    notifyListeners();
  }

  void hideLoading() {
    state = false;

    notifyListeners();
  }
}
