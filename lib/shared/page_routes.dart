import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/admin/instructor_editor.dart';
import 'package:follow_up_app/screens/admin/user_info.dart';
import 'package:follow_up_app/screens/authenticate/authenticate.dart';
import 'package:follow_up_app/shared/dialogs/forgot_pass_dialog.dart';
import 'package:follow_up_app/shared/dialogs/verify_codes_dialog.dart';

class Routes {
  //TODO: check if this can be converted to a function
  static PageRoute instructorEditorPage() => PageRouteBuilder(
        fullscreenDialog: true,
        opaque: false,
        transitionDuration: Duration(milliseconds: 100),
        pageBuilder: (context, animIn, animOut) => InstructorCreator(),
        transitionsBuilder: (context, anim, secondAnim, child) {
          final tweenFade = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOutQuart));
          final fadeAnimation = anim.drive(tweenFade);

          return FadeTransition(opacity: fadeAnimation, child: child);
        },
      );

  static PageRoute userInfoPage(UserData userData) => PageRouteBuilder(
        fullscreenDialog: true,
        opaque: false,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animIn, animOut) => UserInfoPage(userData),
        transitionsBuilder: (context, anim, secondAnim, child) {
          final tweenFade = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOutQuart));
          final fadeAnimation = anim.drive(tweenFade);

          return FadeTransition(opacity: fadeAnimation, child: child);
        },
      );

  static PageRoute authPage(bool showSignIn) => PageRouteBuilder(
        fullscreenDialog: true,
        opaque: true,
        pageBuilder: (context, animIn, animOut) => Authenticate(showSignIn),
        transitionsBuilder: (context, anim, secondAnim, child) {
          final tweenInSlide = Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeInOutQuart));
          final slideAnimation = anim.drive(tweenInSlide);

          return SlideTransition(position: slideAnimation, child: child);
        },
      );

  static PageRoute forgotPassDialog() => PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        opaque: false,
        pageBuilder: (context, animIn, animOut) => ForgotPassDialogBox(),
        transitionsBuilder: (context, anim, secondAnim, child) {
          final tweenInSlide = Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeOutQuart));
          final slideAnimation = anim.drive(tweenInSlide);

          final tweenInFade = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInQuart));
          final fadeAnimation = anim.drive(tweenInFade);

          return FadeTransition(opacity: fadeAnimation, child: SlideTransition(position: slideAnimation, child: child));
        },
      );

  static PageRoute<UserData?> codesVerificationdialog() => PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: false,
        opaque: false,
        pageBuilder: (context, animIn, animOut) => VerifyCodesDialogBox(),
        transitionsBuilder: (context, anim, secondAnim, child) {
          final tweenInSlide = Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeOutQuart));
          final slideAnimation = anim.drive(tweenInSlide);

          final tweenInFade = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInQuart));
          final fadeAnimation = anim.drive(tweenInFade);

          return FadeTransition(opacity: fadeAnimation, child: SlideTransition(position: slideAnimation, child: child));
        },
      );
}
