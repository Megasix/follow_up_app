import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/features/sizeable_button.dart';

/// A sign in button that matches Twitter's design guidelines.
class TwitterSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  TwitterSignInButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonColor: Color(0xFFE7E7E7),
      children: <Widget>[
        Image(
          image: AssetImage(
            "assets/images/Twitter_Logo_Blue.png",
          ),
          height: 25.0,
          width: 25.0,
        ),
      ],
    );
  }
}
