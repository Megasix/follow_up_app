import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/admin/instructor_editor.dart';

class Routes {
  final PageRoute instructorEditorPage = PageRouteBuilder(
    fullscreenDialog: true,
    opaque: false,
    transitionDuration: Duration(milliseconds: 100),
    pageBuilder: (context, animIn, animOut) => InstructorCreator(),
    transitionsBuilder: (context, anim, secondAnim, child) {
      const beginFade = 0.0;
      const endFade = 1.0;
      final tweenFade = Tween(begin: beginFade, end: endFade);
      final fadeAnimation = anim.drive(tweenFade);

      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    },
  );
}
