import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeableButton extends StatelessWidget {
  final bool centered;
  final double borderRadius;
  final double buttonPadding;

  final VoidCallback? onPressed;

  Color buttonColor = Get.theme.buttonColor;
  Color buttonBorderColor = Get.theme.accentColor;
  Color overlayColor = Get.theme.splashColor;

  final List<Widget> children;

  SizeableButton({
    this.onPressed,
    required this.buttonColor,
    this.buttonBorderColor = Colors.transparent,
    this.overlayColor = Colors.transparent,
    this.children = const [],
    this.borderRadius = 3.0,
    this.centered = true,
    this.buttonPadding = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.minWidth == 0) {
          children.add(SizedBox.shrink());
        } else {
          if (centered) {
            children.insert(0, Spacer());
          }
          children.add(Spacer());
        }

        BorderSide bs = buttonBorderColor != Colors.transparent
            ? BorderSide(
                color: buttonBorderColor,
              )
            : BorderSide.none;

        return ButtonTheme(
          height: 40.0,
          minWidth: 40.0,
          padding: EdgeInsets.all(buttonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: bs,
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(buttonColor),
              overlayColor: MaterialStateProperty.all(overlayColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
