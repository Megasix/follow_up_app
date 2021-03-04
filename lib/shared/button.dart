import 'package:flutter/material.dart';

class SizeableButton extends StatelessWidget {
  final double borderRadius;
  final VoidCallback onPressed;
  final bool centered;
  final Color buttonColor, splashColor;
  final double buttonPadding;
  final Color buttonBorderColor;
  final List<Widget> children;

  SizeableButton({
    @required this.buttonColor,
    @required this.children,
    this.borderRadius = 3.0,
    this.onPressed,
    this.centered,
    this.splashColor,
    this.buttonPadding = 3.0,
    this.buttonBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var contents = List<Widget>.from(children);

        if (constraints.minWidth == 0) {
          contents.add(SizedBox.shrink());
        } else {
          if (centered) {
            contents.insert(0, Spacer());
          }
          contents.add(Spacer());
        }

        BorderSide bs;
        if (buttonBorderColor != null) {
          bs = BorderSide(
            color: buttonBorderColor,
          );
        } else {
          bs = BorderSide.none;
        }

        return ButtonTheme(
          height: 40.0,
          minWidth: 40.0,
          padding: EdgeInsets.all(buttonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: bs,
          ),
          child: RaisedButton(
            onPressed: onPressed,
            color: buttonColor,
            splashColor: splashColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: contents,
            ),
          ),
        );
      },
    );
  }
}
