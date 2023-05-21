import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackbar(String message, {Color? backgroundColor}) {
  snackBarKey.currentState?.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor ?? Colors.white,
  ));
}

void showSuccessSnackbar(String message) {
  showSnackbar(message, backgroundColor: Colors.green);
}

void showErrorSnackbar(String message) {
  showSnackbar(message, backgroundColor: Colors.red);
}
