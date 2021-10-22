import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/features/sizeable_button.dart';

//TODO: implement dark theme
/// A sign in button that matches Facebook's design guidelines.
class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color mainColor = Color(0xFF1877F2);

  /// Creates a new button.
  FacebookSignInButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonColor: mainColor,
      overlayColor: mainColor.withOpacity(0.5),
      children: <Widget>[
        SizedBox(width: 10),
        Image(
          image: AssetImage(
            "assets/images/flogo-HexRBG-Wht-100.png",
          ),
          height: 35,
          width: 35,
        ),
        SizedBox(width: 10),
        Text('Sign in with Facebook', style: TextStyle(color: Colors.white))
      ],
    );
  }
}
