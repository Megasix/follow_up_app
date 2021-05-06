import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/button.dart';

/// A sign in button that matches Google's design guidelines.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  /// Creates a new button.
  GoogleSignInButton({
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonColor: Colors.white,
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
