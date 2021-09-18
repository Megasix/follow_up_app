import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/sizeable_button.dart';

/// A sign in button that matches Apple's design guidelines.
class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool darkMode;

  /// Creates a new button. Set [darkMode] to `true` to use the dark black background variant
  AppleSignInButton({
    required this.onPressed,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonColor: darkMode ? Colors.black : Colors.white,
      children: <Widget>[
        Image(
          image: AssetImage(
            "assets/images/apple_logo_${darkMode ? "white" : "black"}.png",
          ),
          height: 25.0,
          width: 25.0,
        ),
      ],
    );
  }
}
