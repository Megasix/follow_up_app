import 'package:flutter/material.dart';

class CustomSnackbar {
  static showBar(BuildContext context, String message, {Function? action, String actionMessage = ''}) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      action: SnackBarAction(label: actionMessage, onPressed: () => action),
      content: Text(message),
    ));
  }
}
