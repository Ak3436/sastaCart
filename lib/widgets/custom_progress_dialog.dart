import 'package:flutter/material.dart';

class CustomProgressDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (context) {
        return const SafeArea(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
