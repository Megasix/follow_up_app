import 'package:flutter/material.dart';

class CustomSnackbar {
  static showBar(BuildContext context, String message, {Function? action, String actionMessage = ''}) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      action: action != null ? SnackBarAction(label: actionMessage, onPressed: () => action) : null,
      content: Text(message),
    ));
  }
}
