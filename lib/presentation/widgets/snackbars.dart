import 'package:flutter/material.dart';

class Snackbars {
  static SnackBar displayErrorSnackbar(String errorText) {
    return SnackBar(
      content: Text(errorText),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    );
  }
}
