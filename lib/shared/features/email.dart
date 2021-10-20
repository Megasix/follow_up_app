import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/features/sizeable_button.dart';
import 'package:get/get.dart';

//TODO: implement dark theme
/// A sign in button that matches Google's design guidelines.
class EmailSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color mainColor = Colors.red;

  /// Creates a new button.
  EmailSignInButton({
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
        Icon(
          Icons.email,
          color: mainColor,
          size: 35,
        ),
        SizedBox(width: 10),
        Text('Sign in with Email', style: TextStyle(color: mainColor))
      ],
    );
  }
}
