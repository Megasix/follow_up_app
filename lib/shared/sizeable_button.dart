import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeableButton extends StatelessWidget {
  final bool centered;
  final double borderRadius;
  final double buttonBorderWidth;
  final double buttonPadding;

  final VoidCallback? onPressed;

  final Color buttonColor;
  final Color buttonBorderColor;
  final Color overlayColor;

  final List<Widget> children;

  SizeableButton({
    this.onPressed,
    required this.buttonColor,
    this.buttonBorderColor = Colors.transparent,
    this.overlayColor = Colors.transparent,
    this.children = const [],
    this.borderRadius = 50.0,
    this.buttonBorderWidth = 2.0,
    this.centered = true,
    this.buttonPadding = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            overlayColor: MaterialStateProperty.all(overlayColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(color: buttonBorderColor, width: buttonBorderWidth),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: children,
          ),
        );
      },
    );
  }
}
