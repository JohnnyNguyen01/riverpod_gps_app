import 'package:flutter/material.dart';

class Snackbars {
  static SnackBar displayErrorSnackbar(String errorText) {
    return SnackBar(
      content: Text(errorText),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    );
  }

  static SnackBar genericSnackbar(
      {required String text,
      required Color backgroundColor,
      required int duration}) {
    return SnackBar(
      content: Text(text),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: duration),
    );
  }
}
