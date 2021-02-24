import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/button.dart';

/// A sign in button that matches Facebook's design guidelines.
class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  /// Creates a new button.
  FacebookSignInButton({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonColor: Color(0xFF1877F2),
      children: <Widget>[
        Image(
          image: AssetImage(
            "assets/images/flogo-HexRBG-Wht-100.png",
          ),
          height: 25.0,
          width: 25.0,
        ),
      ],
    );
  }
}
