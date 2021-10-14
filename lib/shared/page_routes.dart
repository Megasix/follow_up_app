import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/screens/admin/instructor_editor.dart';
import 'package:follow_up_app/screens/authenticate/authenticate.dart';
import 'package:follow_up_app/screens/authenticate/sign_in.dart';
import 'package:get/get.dart';

class Routes {
  //TODO: check if this can be converted to a function
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

  PageRoute authPage(UserType type) => PageRouteBuilder(
        fullscreenDialog: true,
        opaque: true,
        pageBuilder: (context, animIn, animOut) => Authenticate(type),
        transitionsBuilder: (context, anim, secondAnim, child) {
          final tweenInSlide = Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeInOutQuart));
          final slideAnimation = anim.drive(tweenInSlide);

          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        },
      );
}
