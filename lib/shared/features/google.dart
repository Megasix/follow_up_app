import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/button.dart';

/// A sign in button that matches Google's design guidelines.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool darkMode;

  /// Creates a new button. Set [darkMode] to `true` to use the dark
  /// blue background variant with white text
  GoogleSignInButton({
    this.onPressed,
    this.darkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonColor: darkMode ? Color(0xFF4285F4) : Colors.white,
      children: <Widget>[
        Image(
          image: AssetImage(
            "assets/images/google-logo.png",
          ),
          height: 25.0,
          width: 25.0,
        ),
      ],
    );
  }
}
