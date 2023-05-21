import 'package:flutter/material.dart';

void showConfirmDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  VoidCallback? onYes,
  String yesButtonText = 'YES',
  String noButtonText = 'NO',
  Color? backgroundColor,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(noButtonText),
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);

              if (onYes != null) {
                onYes();
              }
            },
            child: Text(yesButtonText),
          ),
        ],
      );
    },
  );
}
