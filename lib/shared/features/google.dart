import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/features/sizeable_button.dart';
import 'package:get/get.dart';

//TODO: implement dark theme
/// A sign in button that matches Google's design guidelines.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color mainColor = Color(0xff4285F4);

  /// Creates a new button.
  GoogleSignInButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizeableButton(
      onPressed: onPressed,
      buttonBorderColor: mainColor,
      overlayColor: mainColor.withOpacity(0.5),
      buttonColor: Get.theme.backgroundColor,
      children: <Widget>[
        SizedBox(width: 10),
        Image(
          image: AssetImage(
            "assets/images/google-logo.png",
          ),
          height: 35,
          width: 35,
        ),
        SizedBox(width: 10),
        Text('Sign in with Google', style: TextStyle(color: mainColor))
      ],
    );
  }
}
